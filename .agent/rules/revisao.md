# Guardrails — Workflow de Revisão de Proposta

Estas regras são específicas do workflow `revisar-proposta`. Lidas em conjunto com `.agent/rules/proposta.md`, que continua sendo a base.

---

## REGRA R1 — Nenhuma seção obrigatória pode ser removida

**Regra:** A revisão não pode reduzir o número de seções obrigatórias. As 8 seções de `estrutura-proposta.md` devem estar presentes na nova versão, independentemente do feedback do cliente.

**O que o agente NÃO pode fazer:** remover uma seção mesmo que o cliente solicite explicitamente.

**O que o agente PODE fazer:** reformular, condensar ou expandir o conteúdo de uma seção.

**Se o cliente pedir remoção:** recusar, explicar, e propor alternativa (ex.: "posso reduzir a seção a um parágrafo") para aprovação do usuário.

---

## REGRA R2 — Todo feedback deve ser catalogado antes de qualquer edição

**Regra:** O arquivo `specs/<cliente>/feedback-v<N>.md` deve ser criado e preenchido **antes** de qualquer modificação na proposta. Editar sem catalogar impede rastreabilidade.

**Por quê:** sem o catálogo de feedback, não é possível verificar quais itens foram aplicados e quais foram recusados — o que fragiliza qualquer revisão futura ou litígio.

**Gatilho:** qualquer instrução de "altere X na proposta" sem que feedback-v<N>.md exista para esta versão.

---

## REGRA R3 — Alterações financeiras seguem as mesmas regras da geração original

**Regra:** Qualquer mudança de valor, desconto, prazo de pagamento ou SLA na revisão está sujeita às mesmas restrições de `rules/proposta.md` REGRA 1. Não há relaxamento por ser uma revisão.

**Exemplo:** se a versão v1 tinha R$ 80.000 e o cliente pede redução para R$ 60.000, isso é uma redução de 25% — acima do limite autônomo de desconto. Inserir flag `[APROVAÇÃO NECESSÁRIA — Desconto fora da política padrão: 25%]`.

---

## REGRA R4 — O número de versão deve ser incrementado

**Regra:** Cada revisão gera um novo arquivo com versão incremental (`v2.md`, `v3.md`). O arquivo da versão anterior não pode ser sobrescrito.

**Verificação:** o campo `versão:` no frontmatter deve ser maior que o da versão anterior.

**O que o agente NÃO pode fazer:** editar a proposta v1 diretamente sem criar uma v2.

---

## REGRA R5 — Todo GWT do design.md deve continuar coberto

**Regra:** Após aplicar os feedbacks, verificar que cada critério Given/When/Then de `specs/<cliente>/design.md` ainda está endereçado por alguma seção da nova proposta.

**Se um GWT ficar descoberto:** apontar ao usuário e aguardar instrução antes de avançar. Não gerar v<N+1> com GWT órfão.

**Por quê:** o design.md é o contrato de requisitos. Perder cobertura de um GWT sem registro é tecnicamente uma mudança de escopo não aprovada.

---

## Como estas regras se relacionam com `rules/proposta.md`

As regras de `proposta.md` (Regras 1–5) continuam válidas na revisão:

| Regra base | Comportamento na revisão |
|---|---|
| REGRA 1 (SLA/desconto fora de faixa) | Ver REGRA R3 acima — sem relaxamento |
| REGRA 2 (dados de outros clientes) | Aplica identicamente |
| REGRA 3 (DoD obrigatório) | Aplica identicamente — rodar sobre a nova versão |
| REGRA 4 (sem placeholders) | Aplica identicamente |
| REGRA 5 (STATUS: RASCUNHO) | Aplica identicamente — nova versão começa como RASCUNHO |

| Guardrail desta skill | Reforçado por |
|---|---|
| Sem remoção de seções | `revisar-proposta/SKILL.md` Passo 2 |
| Feedback catalogado primeiro | `revisar-proposta/SKILL.md` Passo 1 |
| Alterações financeiras com flag | `rules/proposta.md` REGRA 1 |
| Versão incrementada | `revisar-proposta/SKILL.md` Passo 3 (frontmatter) |
| GWT coberto | `revisar-proposta/SKILL.md` Passo 4 |
