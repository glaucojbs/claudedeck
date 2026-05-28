#!/usr/bin/env bash
# Suite de testes do dod-check.sh
# O harness testa a si mesmo.
# Uso: bash tests/dod-check.test.sh
# Saída: 0 (todos passaram) | 1 (algum falhou)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$SCRIPT_DIR/.."
DOD="$ROOT/scripts/dod-check.sh"
FIXTURES="$SCRIPT_DIR/fixtures"

PASSED=0
FAILED=0
FAILURES=()

# ── Helper ─────────────────────────────────────────────────────────────────────

assert_exit() {
  local DESCRICAO="$1"
  local ARQUIVO="$2"
  local EXIT_ESPERADO="$3"

  set +e
  bash "$DOD" "$ARQUIVO" > /dev/null 2>&1
  local EXIT_REAL=$?
  set -e

  if [[ "$EXIT_REAL" -eq "$EXIT_ESPERADO" ]]; then
    echo "  ✓ $DESCRICAO"
    (( PASSED++ )) || true
  else
    echo "  ✗ $DESCRICAO (esperado exit $EXIT_ESPERADO, obteve $EXIT_REAL)"
    FAILURES+=("$DESCRICAO")
    (( FAILED++ )) || true
  fi
}

# ── Runner ─────────────────────────────────────────────────────────────────────

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  Testes do DoD — Apex Harness Self-Test"
echo "  Data: $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════════════════════"
echo ""

echo "[ CASO 1 ] Proposta válida deve passar (exit 0)"
assert_exit \
  "proposta-valida.md retorna exit 0" \
  "$FIXTURES/proposta-valida.md" \
  0

echo ""
echo "[ CASO 2 ] Proposta sem seções obrigatórias deve falhar (exit 1)"
assert_exit \
  "proposta-sem-secoes.md retorna exit 1" \
  "$FIXTURES/proposta-sem-secoes.md" \
  1

echo ""
echo "[ CASO 3 ] Proposta com placeholder deve falhar (exit 1)"
assert_exit \
  "proposta-com-placeholder.md retorna exit 1" \
  "$FIXTURES/proposta-com-placeholder.md" \
  1

echo ""
echo "[ CASO 4 ] Proposta sem header STATUS deve falhar (exit 1)"
assert_exit \
  "proposta-sem-status.md retorna exit 1" \
  "$FIXTURES/proposta-sem-status.md" \
  1

echo ""
echo "[ CASO 5 ] Proposta com flag de aprovação pendente deve falhar (exit 1)"
assert_exit \
  "proposta-com-flag.md retorna exit 1" \
  "$FIXTURES/proposta-com-flag.md" \
  1

echo ""
echo "[ CASO 6 ] Proposta com valor acima do limite sem flag deve falhar (exit 1)"
assert_exit \
  "proposta-valor-alto.md retorna exit 1" \
  "$FIXTURES/proposta-valor-alto.md" \
  1

echo ""
echo "[ CASO 7 ] Proposta de demonstração real deve passar (exit 0)"
assert_exit \
  "cliente-exemplo-proposta-v1.md retorna exit 0" \
  "$ROOT/output/propostas/cliente-exemplo-proposta-v1.md" \
  0

# ── Resultado ──────────────────────────────────────────────────────────────────

TOTAL=$(( PASSED + FAILED ))
echo ""
echo "═══════════════════════════════════════════════════════"
echo "  RESULTADO: $PASSED/$TOTAL testes passaram"
echo "═══════════════════════════════════════════════════════"

if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo ""
  echo "Testes com falha:"
  for F in "${FAILURES[@]}"; do echo "  ✗ $F"; done
  echo ""
  echo "─────────────────────────────────────────────────────"
  echo "  STATUS: REPROVADO"
  echo "─────────────────────────────────────────────────────"
  echo ""
  exit 1
else
  echo ""
  echo "─────────────────────────────────────────────────────"
  echo "  STATUS: APROVADO — harness validado"
  echo "─────────────────────────────────────────────────────"
  echo ""
  exit 0
fi
