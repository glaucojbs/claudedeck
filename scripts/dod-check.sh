#!/usr/bin/env bash
# Definition of Done — Validação de Proposta Comercial Apex
# Uso: bash scripts/dod-check.sh <caminho-da-proposta.md>
# Saída: 0 (passou) | 1 (falhou)

set -euo pipefail

PROPOSTA="${1:-}"
ERRORS=()
CHECKS_PASSED=()

# ── Helpers ────────────────────────────────────────────────────────────────────

check_pass() { CHECKS_PASSED+=("  ✓ $1"); }
check_fail() { ERRORS+=("  ✗ $1"); }

# ── Argumento ──────────────────────────────────────────────────────────────────

if [[ -z "$PROPOSTA" ]]; then
  echo "Uso: bash scripts/dod-check.sh <caminho-da-proposta.md>"
  exit 1
fi

if [[ ! -f "$PROPOSTA" ]]; then
  echo "Arquivo não encontrado: $PROPOSTA"
  exit 1
fi

# ── Carregar constantes de política (fonte única de verdade) ───────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POLICY_CONFIG="$SCRIPT_DIR/../.agent/policy-config.json"

if [[ -f "$POLICY_CONFIG" ]] && command -v jq &>/dev/null; then
  LIMITE_AUTONOMO=$(jq '.autonomous_limit' "$POLICY_CONFIG")
  MAX_DESCONTO=$(jq '.max_discount_pct' "$POLICY_CONFIG")
  POLICY_VERSION=$(jq -r '.version' "$POLICY_CONFIG")
else
  # Fallback para valores padrão se jq ou policy-config.json não disponíveis
  LIMITE_AUTONOMO=150000
  MAX_DESCONTO=10
  POLICY_VERSION="(fallback)"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  DoD Check — Apex Consultoria"
echo "  Arquivo: $PROPOSTA"
echo "  Política: v${POLICY_VERSION} | Limite autônomo: R\$ ${LIMITE_AUTONOMO}"
echo "  Data:    $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════════════════════"
echo ""

CONTENT=$(cat "$PROPOSTA")

# ── BLOCO 1: Seções Obrigatórias ───────────────────────────────────────────────

echo "[ BLOCO 1 ] Seções obrigatórias"

NOMES=("1. Contexto" "2. Escopo" "3. Entregáveis" "4. Metodologia" "5. Prazo" "6. Investimento" "7. Premissas" "8. Próximos Passos")
PADROES=("Contexto" "Escopo" "[Ee]ntreg" "Metodologia" "Prazo" "Investimento" "Premissas" "[Pp]r[oó]ximos")

for i in "${!NOMES[@]}"; do
  NOME="${NOMES[$i]}"
  PADRAO="${PADROES[$i]}"
  if echo "$CONTENT" | grep -qE "^#+ .*${PADRAO}"; then
    check_pass "Seção '$NOME' encontrada"
  else
    check_fail "Seção '$NOME' AUSENTE"
  fi
done

# ── BLOCO 2: Placeholders Proibidos ───────────────────────────────────────────

echo ""
echo "[ BLOCO 2 ] Placeholders proibidos"

ALL_CLEAN=true

# TODO como palavra isolada em maiúsculo — não captura "todos", "toda"
if echo "$CONTENT" | grep -qE '\bTODO\b'; then
  check_fail "Placeholder encontrado: TODO (palavra isolada)"
  ALL_CLEAN=false
fi

# Padrões entre colchetes
for P in '\[inserir\]' '\[preencher\]' '\[data\]' '\[valor\]' '\[nome\]' '\[TODO\]'; do
  if echo "$CONTENT" | grep -qi "$P"; then
    check_fail "Placeholder encontrado: $P"
    ALL_CLEAN=false
  fi
done

# Sequências vagas
for P in '???' 'TBD'; do
  if echo "$CONTENT" | grep -qF "$P"; then
    check_fail "Placeholder encontrado: $P"
    ALL_CLEAN=false
  fi
done

# XX como valor numérico vago
if echo "$CONTENT" | grep -qE '\bXX\b'; then
  check_fail "Placeholder encontrado: XX (valor vago)"
  ALL_CLEAN=false
fi

if $ALL_CLEAN; then
  check_pass "Nenhum placeholder proibido encontrado"
fi

# ── BLOCO 3: Header de Status ──────────────────────────────────────────────────

echo ""
echo "[ BLOCO 3 ] Header de status"

if echo "$CONTENT" | grep -q "STATUS: RASCUNHO"; then
  check_pass "Header 'STATUS: RASCUNHO' presente"
else
  check_fail "Header 'STATUS: RASCUNHO' AUSENTE — documento não pode ser enviado sem revisão humana"
fi

# ── BLOCO 4: Flags de Aprovação Pendentes ─────────────────────────────────────

echo ""
echo "[ BLOCO 4 ] Flags de aprovação pendentes"

if echo "$CONTENT" | grep -q "\[APROVAÇÃO NECESSÁRIA"; then
  while IFS= read -r FLAG; do
    ERRORS+=("    → $FLAG")
  done < <(echo "$CONTENT" | grep -o "\[APROVAÇÃO NECESSÁRIA[^]]*\]" | head -5)
  check_fail "Proposta contém flags de aprovação pendentes — requer autorização humana antes do envio"
else
  check_pass "Nenhuma flag de aprovação pendente"
fi

# ── BLOCO 5: Valores de Investimento — apenas na seção Investimento ────────────

echo ""
echo "[ BLOCO 5 ] Faixas de investimento (limite autônomo: R\$ ${LIMITE_AUTONOMO})"

# Extrai linhas APÓS o heading de Investimento até o próximo heading (ou fim do arquivo)
SECAO_INVESTIMENTO=$(echo "$CONTENT" | awk '/^#+ .*[Ii]nvestimento/{found=1; next} found && /^#+ /{found=0} found{print}' || true)

VIOLACAO=false

if [[ -n "$SECAO_INVESTIMENTO" ]]; then
  while IFS= read -r V; do
    [[ -z "$V" ]] && continue
    V_NUM=$(echo "$V" | tr -d '.')
    if (( V_NUM > LIMITE_AUTONOMO )); then
      if ! echo "$CONTENT" | grep -q "\[APROVAÇÃO NECESSÁRIA"; then
        check_fail "Valor R\$ ${V} na seção Investimento excede o limite autônomo de R\$ ${LIMITE_AUTONOMO} sem flag de aprovação"
        VIOLACAO=true
      fi
    fi
  done < <(echo "$SECAO_INVESTIMENTO" | grep -oE 'R\$[[:space:]]*[0-9]{1,3}(\.[0-9]{3})*' | grep -oE '[0-9]{1,3}(\.[0-9]{3})*')
fi

if ! $VIOLACAO; then
  check_pass "Valores de investimento dentro do limite autônomo ou com flag de aprovação"
fi

# ── BLOCO 6: Isolamento de Dados de Clientes ──────────────────────────────────

echo ""
echo "[ BLOCO 6 ] Isolamento de dados de clientes"

if echo "$CONTENT" | grep -qE 'specs/[a-z]'; then
  check_fail "Referência a diretório de specs encontrada — verificar se há dados de outros clientes"
else
  check_pass "Nenhuma referência cruzada a specs de outros clientes"
fi

# ── BLOCO 7: Campos Mínimos do Frontmatter ────────────────────────────────────

echo ""
echo "[ BLOCO 7 ] Frontmatter do documento"

for CAMPO in "cliente:" "tipo:" "data:" "autor:"; do
  if echo "$CONTENT" | grep -qi "^${CAMPO}"; then
    check_pass "Campo '$CAMPO' presente no frontmatter"
  else
    check_fail "Campo '$CAMPO' AUSENTE no frontmatter"
  fi
done

# ── Resultado Final ────────────────────────────────────────────────────────────

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  RESULTADO"
echo "═══════════════════════════════════════════════════════"
echo ""

if [[ ${#CHECKS_PASSED[@]} -gt 0 ]]; then
  echo "Passou (${#CHECKS_PASSED[@]} verificações):"
  for C in "${CHECKS_PASSED[@]}"; do echo "$C"; done
fi

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  echo ""
  echo "Falhou (${#ERRORS[@]} problemas):"
  for E in "${ERRORS[@]}"; do echo "$E"; done
  echo ""
  echo "─────────────────────────────────────────────────────"
  echo "  STATUS: REPROVADO — corrigir os itens acima"
  echo "─────────────────────────────────────────────────────"
  echo ""
  exit 1
else
  echo ""
  echo "─────────────────────────────────────────────────────"
  echo "  STATUS: APROVADO — proposta liberada para revisão humana"
  echo "─────────────────────────────────────────────────────"
  echo ""
  exit 0
fi
