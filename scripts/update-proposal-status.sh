#!/usr/bin/env bash
# Atualiza o status de uma proposta no índice output/proposals-index.json
# Uso: bash scripts/update-proposal-status.sh <caminho-da-proposta.md> <STATUS> [motivo]
# Status válidos: APROVADO | ENVIADO | GANHO | PERDIDO | ARQUIVADO

set -euo pipefail

PROPOSTA="${1:-}"
NOVO_STATUS="${2:-}"
MOTIVO="${3:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$SCRIPT_DIR/.."
INDEX="$ROOT/output/proposals-index.json"

ESTADOS_VALIDOS=("APROVADO" "ENVIADO" "GANHO" "PERDIDO" "ARQUIVADO")

# ── Validar argumentos ────────────────────────────────────────────────────────

if [[ -z "$PROPOSTA" || -z "$NOVO_STATUS" ]]; then
  echo "Uso: bash scripts/update-proposal-status.sh <caminho-da-proposta.md> <STATUS> [motivo]"
  echo "Status válidos: APROVADO | ENVIADO | GANHO | PERDIDO | ARQUIVADO"
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

# ── Validar status ────────────────────────────────────────────────────────────

VALIDO=false
for E in "${ESTADOS_VALIDOS[@]}"; do
  if [[ "$NOVO_STATUS" == "$E" ]]; then VALIDO=true; break; fi
done

if ! $VALIDO; then
  echo "Status inválido: '$NOVO_STATUS'"
  echo "Status válidos: ${ESTADOS_VALIDOS[*]}"
  exit 1
fi

# ── Derivar ID e data ─────────────────────────────────────────────────────────

ID=$(basename "$PROPOSTA" .md | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
DATA=$(date '+%Y-%m-%d')

# ── Verificar índice e entrada ────────────────────────────────────────────────

if [[ ! -f "$INDEX" ]]; then
  echo "Índice não encontrado: $INDEX"
  echo "Registre a proposta primeiro com: bash scripts/register-proposal.sh $PROPOSTA"
  exit 1
fi

if ! jq -e --arg id "$ID" '.[] | select(.id == $id)' "$INDEX" > /dev/null 2>&1; then
  echo "Proposta '$ID' não encontrada no índice."
  echo "Registre primeiro com: bash scripts/register-proposal.sh $PROPOSTA"
  exit 1
fi

# ── Capturar status atual para log ───────────────────────────────────────────

STATUS_ATUAL=$(jq -r --arg id "$ID" '.[] | select(.id == $id) | .status' "$INDEX")

# ── Atualizar índice ──────────────────────────────────────────────────────────

UPDATED=$(jq --arg id "$ID" \
             --arg status "$NOVO_STATUS" \
             --arg data "$DATA" \
             --arg motivo "$MOTIVO" \
  'map(if .id == $id then . + {
    status: $status,
    status_updated_at: $data,
    status_motivo: (if $motivo != "" then $motivo else (.status_motivo // null) end)
  } else . end)' "$INDEX")

echo "$UPDATED" > "$INDEX"

# ── Relatório ─────────────────────────────────────────────────────────────────

echo ""
echo "Status atualizado no índice:"
echo "  ID:            $ID"
echo "  Status:        $STATUS_ATUAL → $NOVO_STATUS"
echo "  Data:          $DATA"
if [[ -n "$MOTIVO" ]]; then
  echo "  Motivo:        $MOTIVO"
fi
echo "  Índice:        $INDEX"
echo ""
