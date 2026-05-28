# Tasks — [Nome do Cliente]

> Checklist de execução do workflow de proposta.
> Atualizar o estado de cada item conforme avança na sessão.

---

## Pré-geração

- [ ] `draft.md` preenchido (obrigatório: perguntas 1, 2 e 4)
- [ ] `design.md` com mínimo 3 critérios GWT
- [ ] Escopo dentro/fora delimitado
- [ ] Tipo de engajamento confirmado: Diagnóstico / Implementação / Sustentação
- [ ] Porte do cliente confirmado (para faixa de precificação)

## Geração (`/gerar-proposta`)

- [ ] Arquivo criado em `output/propostas/<cliente>-proposta-v1.md`
- [ ] Frontmatter completo (cliente, tipo, data, autor, STATUS)
- [ ] 8 seções redigidas com conteúdo real (sem placeholders)
- [ ] Valores calculados dentro das faixas de `pricing-policy.md`
- [ ] Flags `[APROVAÇÃO NECESSÁRIA]` inseridas onde aplicável

## Validação

- [ ] Auto-revisão manual concluída (checklist Passo 3 do SKILL.md)
- [ ] DoD executado com saída 0
- [ ] Proposta registrada no índice via `register-proposal.sh`

## Revisão (se houver feedback — `/revisar-proposta`)

- [ ] `feedback-v1.md` catalogado antes de qualquer edição
- [ ] Nova versão criada (v2, v3…)
- [ ] GWTs verificados — nenhum descoberto
- [ ] DoD da nova versão com saída 0

## Aprovação (`/aprovar-proposta`)

- [ ] DoD da versão final com saída 0
- [ ] Checklist de revisão humana confirmado
- [ ] STATUS atualizado para APROVADO no frontmatter
- [ ] Índice atualizado

## Desfecho (`/fechar-proposta`)

- [ ] Status de envio registrado (ENVIADO)
- [ ] Resultado final registrado (GANHO / PERDIDO / ARQUIVADO)
- [ ] Motivo documentado no índice
