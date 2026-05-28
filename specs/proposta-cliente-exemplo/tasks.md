# Tasks — Cliente Exemplo Ltda

**Fase 3: Checklist de Execução da Proposta**
Criado em: 2026-05-28 | Baseado em: design.md | Status: Pronto para execução do agente

---

## Bloco A — Spec e Validação (pré-geração)

- [x] `draft.md` criado e revisado com o usuário
- [x] `design.md` criado com no mínimo 3 critérios GWT
- [x] Escopo com delimitação explícita (dentro/fora)
- [x] Tipo de engajamento identificado: **Implementação — complexidade média**
- [x] Orçamento do cliente confirmado: R$ 80.000–100.000
- [x] Prazo do cliente confirmado: 12 semanas

## Bloco B — Geração da Proposta

- [ ] Verificar faixa de pricing aplicável (Implementação média: R$ 60k–120k)
- [ ] Calcular investimento total dentro da faixa permitida
- [ ] Redigir seção 1 — Contexto e Problema (baseado no draft)
- [ ] Redigir seção 2 — Escopo (baseado no design)
- [ ] Redigir seção 3 — Entregáveis (mapear dos GWTs)
- [ ] Redigir seção 4 — Metodologia e Abordagem
- [ ] Redigir seção 5 — Prazo e Cronograma (12 semanas + 4 de sustentação)
- [ ] Redigir seção 6 — Investimento (dentro da faixa, sem flag de aprovação)
- [ ] Redigir seção 7 — Premissas e Exclusões (baseado nas restrições do design)
- [ ] Redigir seção 8 — Próximos Passos

## Bloco C — Validação

- [ ] Auto-revisão: todas as 8 seções presentes?
- [ ] Auto-revisão: nenhum placeholder visível?
- [ ] Auto-revisão: nenhum outro cliente mencionado?
- [ ] Auto-revisão: header STATUS: RASCUNHO presente?
- [ ] Executar: `bash scripts/dod-check.sh output/propostas/cliente-exemplo-proposta-v1.md`
- [ ] Confirmar saída 0 do DoD

## Bloco D — Entrega

- [ ] Reportar path do arquivo ao usuário
- [ ] Listar flags de aprovação (se houver)
- [ ] Confirmar que proposta é RASCUNHO — revisão humana necessária antes do envio

---

## Critérios de Done desta spec

A spec está completa quando:
1. Todos os itens do Bloco A estão marcados `[x]`.
2. Pelo menos um dos critérios GWT do `design.md` cobre cada área crítica: processo, dados, usuário, operabilidade.
3. O tipo de engajamento e a faixa de orçamento são consistentes entre `draft.md` e `design.md`.

**Status atual:** Bloco A completo — pronto para iniciar Bloco B.
