# Ciclo de Vida da Proposta

Este documento define os estados possíveis de uma proposta, as transições válidas, e quem pode executar cada transição.

---

## Estados

| Estado | Significado | Quem pode atribuir |
|---|---|---|
| `RASCUNHO` | Gerado pelo agente, pendente revisão humana | Agente (automaticamente) |
| `APROVADO` | Revisado e aprovado por humano da Apex | Humano via `/aprovar-proposta` |
| `ENVIADO` | Entregue ao cliente | Humano via `/fechar-proposta` |
| `GANHO` | Cliente aceitou e projeto iniciará | Humano via `/fechar-proposta` |
| `PERDIDO` | Cliente recusou ou proposta expirou | Humano via `/fechar-proposta` |
| `ARQUIVADO` | Cancelada antes do envio (decisão interna) | Humano via `/fechar-proposta` |

---

## Transições Válidas

```
RASCUNHO ──────────────────────────────► APROVADO
                                             │
                                             ▼
                                          ENVIADO
                                         /       \
                                        ▼         ▼
                                      GANHO     PERDIDO

RASCUNHO ──► ARQUIVADO   (descartado antes de aprovar)
APROVADO ──► ARQUIVADO   (descartado antes de enviar)
```

Transições não listadas são inválidas. Exemplos de transições proibidas: `GANHO → RASCUNHO`, `PERDIDO → APROVADO`.

---

## Regras de Transição

### RASCUNHO → APROVADO
- DoD deve ter passado com código 0.
- Nenhuma flag `[APROVAÇÃO NECESSÁRIA]` pendente (ou todas resolvidas com aprovação documentada).
- Um humano da Apex executa `/aprovar-proposta` e confirma explicitamente.

### APROVADO → ENVIADO
- Humano executa `/fechar-proposta status=ENVIADO`.
- A data de envio e canal são registrados no índice.

### ENVIADO → GANHO ou PERDIDO
- Humano executa `/fechar-proposta status=GANHO` ou `status=PERDIDO`.
- O motivo é capturado e registrado no índice.

### * → ARQUIVADO
- Humano executa `/fechar-proposta status=ARQUIVADO` com justificativa.
- Qualquer estado pode ir para ARQUIVADO.

---

## Onde o estado é armazenado

1. **Frontmatter do documento** (`output/propostas/*.md`): campo `STATUS:` — legível por humanos.
2. **Índice** (`output/proposals-index.json`): campo `"status"` — legível por máquinas e scripts.

Ambos devem estar sincronizados. Se divergirem, o índice prevalece para fins de relatório; o documento prevalece para fins de auditoria.

---

## Validade da Proposta

Conforme `policy-config.json`, o campo `proposal_validity_days` define a validade padrão (atualmente 30 dias corridos a partir da data no frontmatter). Uma proposta não enviada após esse prazo deve ser revisada ou arquivada.

O DoD não verifica validade automaticamente — isso é responsabilidade do processo humano de acompanhamento comercial.
