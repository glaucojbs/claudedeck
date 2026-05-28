# SKILL: revisar-proposta

Versão: 1.0.0 | Trigger: `/revisar-proposta`

---

## Trigger Description

Ativada quando o cliente ou o time interno devolve uma proposta v1.x com feedback e solicita uma versão revisada. Pressupõe que spec e proposta original já existem.

**Não** gera nova proposta do zero — use `/gerar-proposta` para isso.

---

## Pré-condições

Antes de iniciar, verificar:

1. Existe `output/propostas/<cliente>-proposta-v<N>.md`?
   - Não → interromper e orientar o usuário a rodar `/gerar-proposta` primeiro.

2. Existe `specs/<cliente>/design.md` com critérios GWT?
   - Não → interromper. Revisões não podem remover critérios que nunca foram registrados.

3. O usuário forneceu a lista de feedbacks explicitamente (texto, e-mail, notas)?
   - Não → perguntar antes de continuar. Sem feedback estruturado, não há revisão.

4. Ler e confirmar entendimento de:
   - `.agent/knowledge/estrutura-proposta.md`
   - `.agent/knowledge/pricing-policy.md`
   - `.agent/rules/proposta.md`
   - `.agent/rules/revisao.md` (guardrails específicos desta skill)

---

## Passo 1 — Catalogar os Feedbacks

Criar ou atualizar `specs/<cliente>/feedback-v<N>.md` com o conteúdo recebido, organizado em:

```markdown
## Feedbacks de Revisão — v<N> → v<N+1>
Data: AAAA-MM-DD
Origem: <nome do contato / e-mail>

### Solicitações de alteração
- [ ] <feedback 1>
- [ ] <feedback 2>

### Restrições mantidas (não alterar)
- <item confirmado pelo cliente>
```

Classificar cada feedback como:
- **Conteúdo:** mudança no texto, escopo, metodologia
- **Financeiro:** mudança em valor, prazo, forma de pagamento
- **Estrutural:** adição ou reorganização de seção

Feedbacks **financeiros** que desviem da política ativam a Regra 1 de `rules/proposta.md` → inserir flag `[APROVAÇÃO NECESSÁRIA]`.

---

## Passo 2 — Verificar Integridade das Seções

Antes de editar, mapear quais seções existem na proposta original (v1.x) e quais critérios GWT do `design.md` cobrem cada seção.

**Guardrail desta skill:** nenhuma seção pode ser removida. Seções podem ser:
- Substituídas (conteúdo novo, mesma seção)
- Expandidas (novo conteúdo adicionado)
- Reordenadas (apenas com justificativa explícita do cliente)

Se o feedback solicitar remoção de seção obrigatória: recusar, explicar ao usuário, e propor reformulação que preserve a seção.

---

## Passo 3 — Redigir a Revisão

Criar novo arquivo `output/propostas/<cliente>-proposta-v<N+1>.md`.

O frontmatter deve incluir campos adicionais em relação à versão anterior:

```yaml
---
cliente: <nome>
tipo: <Diagnóstico | Implementação | Sustentação>
versão: <N+1>.0
data: <AAAA-MM-DD>
autor: Agente Apex (revisão humana pendente)
baseado_em: output/propostas/<cliente>-proposta-v<N>.md
skill_version: revisar-proposta/1.0.0
STATUS: RASCUNHO — Pendente revisão humana
---
```

Adicionar ao final do documento, antes dos Próximos Passos:

```markdown
## Histórico de Revisões

| Versão | Data | Alterações |
|---|---|---|
| v1.0 | <data original> | Versão inicial |
| v<N+1>.0 | <data atual> | <resumo dos feedbacks aplicados> |
```

Aplicar os feedbacks catalogados no Passo 1, marcando cada um como `[x]` no arquivo `feedback-v<N>.md` conforme aplicado.

---

## Passo 4 — Verificar Cobertura dos GWTs

Ler `specs/<cliente>/design.md` e confirmar que cada critério GWT ainda está coberto por alguma seção ou entregável da nova proposta.

Se algum GWT ficou sem cobertura após as alterações: apontar ao usuário e aguardar instrução. Não avançar com GWT descoberto.

---

## Passo 5 — Auto-revisão

- [ ] Todas as seções da v1 estão presentes na v<N+1>?
- [ ] A seção `Histórico de Revisões` foi adicionada?
- [ ] Nenhum placeholder visível?
- [ ] Frontmatter inclui `baseado_em` e `skill_version`?
- [ ] Feedbacks financeiros fora de faixa têm flag `[APROVAÇÃO NECESSÁRIA]`?
- [ ] Nenhum dado de outro cliente foi introduzido?

---

## Passo 6 — Executar o DoD

```bash
bash scripts/dod-check.sh output/propostas/<cliente>-proposta-v<N+1>.md
```

- Saída 0 → avançar para Passo 7.
- Saída 1 → corrigir e re-executar.

---

## Passo 7 — Registrar no Índice e Entregar

```bash
bash scripts/register-proposal.sh output/propostas/<cliente>-proposta-v<N+1>.md
```

Reportar ao usuário:
1. Path da nova versão.
2. Resultado do DoD.
3. Lista de feedbacks aplicados (do `feedback-v<N>.md`).
4. Flags de aprovação pendentes, se houver.
5. Lembrar que STATUS permanece `RASCUNHO`.

---

## O que esta skill NÃO faz

- Não gera proposta do zero — essa é a skill `gerar-proposta`.
- Não remove seções obrigatórias mesmo que o cliente solicite.
- Não aprova desvios de política financeira.
- Não envia a proposta ao cliente.
- Não remove o header `STATUS: RASCUNHO`.
