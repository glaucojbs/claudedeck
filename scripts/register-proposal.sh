#!/usr/bin/env bash
# Registra uma proposta no índice output/proposals-index.json
# Uso: bash scripts/register-proposal.sh <caminho-da-proposta.md>
# Requer: jq

set -euo pipefail

PROPOSTA="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$SCRIPT_DIR/.."
INDEX="$ROOT/output/proposals-index.json"
DOD="$ROOT/scripts/dod-check.sh"

if [[ -z "$PROPOSTA" ]]; then
  echo "Uso: bash scripts/register-proposal.sh <caminho-da-proposta.md>"
  exit 1
fi

if [[ ! -f "$PROPOSTA" ]]; then
  echo "Arquivo não encontrado: $PROPOSTA"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "Erro: jq é necessário. Instale com: brew install jq"
  exit 1
fi

CONTENT=$(cat "$PROPOSTA")

# ── Extrair frontmatter ────────────────────────────────────────────────────────

extract_field() {
  local match
  match=$(echo "$CONTENT" | grep -i "^${1}:" || true)
  echo "$match" | head -1 | sed "s/^${1}:[[:space:]]*//" | tr -d '"'
}

CLIENTE=$(extract_field "cliente")
TIPO=$(extract_field "tipo")
DATA=$(extract_field "data")
SKILL=$(extract_field "skill_version")
VERSAO=$(extract_field "versão")

# Gera um ID a partir do path normalizado
ID=$(basename "$PROPOSTA" .md | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# ── Rodar o DoD e capturar resultado ──────────────────────────────────────────

set +e
bash "$DOD" "$PROPOSTA" > /dev/null 2>&1
DOD_EXIT=$?
set -e

if [[ "$DOD_EXIT" -eq 0 ]]; then DOD_PASSOU="true"; else DOD_PASSOU="false"; fi

# Contar flags de aprovação
FLAGS=$(echo "$CONTENT" | grep -c "\[APROVAÇÃO NECESSÁRIA" || true)

# ── Verificar se ID já existe no índice ───────────────────────────────────────

if [[ -f "$INDEX" ]] && jq -e --arg id "$ID" '.[] | select(.id == $id)' "$INDEX" > /dev/null 2>&1; then
  echo "Entrada '$ID' já existe no índice. Atualizando..."
  UPDATED=$(jq --arg id "$ID" \
               --arg cliente "$CLIENTE" \
               --arg tipo "$TIPO" \
               --arg arquivo "$PROPOSTA" \
               --arg gerado_em "$DATA" \
               --arg skill "${SKILL:-desconhecida}" \
               --argjson dod_passou "$DOD_PASSOU" \
               --argjson flags "$FLAGS" \
    'map(if .id == $id then {
      id: $id,
      cliente: $cliente,
      tipo: $tipo,
      arquivo: $arquivo,
      gerado_em: $gerado_em,
      skill_usada: $skill,
      dod_passou: $dod_passou,
      dod_verificacoes: 17,
      flags_aprovacao: $flags,
      status: "RASCUNHO",
      revisao_humana: null
    } else . end)' "$INDEX")
  echo "$UPDATED" > "$INDEX"
else
  # Append nova entrada
  NOVA_ENTRADA=$(jq -n \
    --arg id "$ID" \
    --arg cliente "$CLIENTE" \
    --arg tipo "$TIPO" \
    --arg arquivo "$PROPOSTA" \
    --arg gerado_em "$DATA" \
    --arg skill "${SKILL:-desconhecida}" \
    --argjson dod_passou "$DOD_PASSOU" \
    --argjson flags "$FLAGS" \
    '{
      id: $id,
      cliente: $cliente,
      tipo: $tipo,
      arquivo: $arquivo,
      gerado_em: $gerado_em,
      skill_usada: $skill,
      dod_passou: $dod_passou,
      dod_verificacoes: 17,
      flags_aprovacao: $flags,
      status: "RASCUNHO",
      revisao_humana: null
    }')

  CURRENT=$(cat "$INDEX")
  echo "$CURRENT" | jq --argjson nova "$NOVA_ENTRADA" '. + [$nova]' > "$INDEX"
fi

echo ""
echo "Proposta registrada no índice:"
echo "  ID:           $ID"
echo "  Cliente:      $CLIENTE"
echo "  Tipo:         $TIPO"
echo "  DoD passou:   $DOD_PASSOU"
echo "  Flags:        $FLAGS"
echo "  Índice:       $INDEX"
echo ""
