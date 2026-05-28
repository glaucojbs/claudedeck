# SKILL: gerar-proposta

Versão: 1.0.0 | Trigger: `/gerar-proposta`

---

## Trigger Description

Ativada quando o usuário solicita a geração de uma proposta comercial para um cliente específico. A skill espera que exista (ou seja criada nesta sessão) uma spec em `specs/<nome-do-cliente>/`.

**Não** gera proposta a partir de prompt livre. Toda proposta começa por spec.

---

## Pré-condições

Antes de iniciar, verificar:

1. Existe um diretório `specs/<nome-do-cliente>/`?
   - Não → executar **Passo 0** para criar a spec do zero.
   - Sim → verificar se `draft.md` e `design.md` existem e estão preenchidos.

2. O usuário forneceu o nome do cliente e o tipo de engajamento (Diagnóstico / Implementação / Sustentação)?
   - Não → perguntar antes de continuar.

3. Ler e confirmar entendimento de:
   - `.agent/knowledge/estrutura-proposta.md`
   - `.agent/knowledge/pricing-policy.md`
   - `.agent/rules/proposta.md`

---

## Passo 0 — Criar Spec (se não existir)

```
specs/<nome-do-cliente>/
  draft.md    ← criado agora (brainstorm do problema)
  design.md   ← criado agora (contrato Given/When/Then)
  tasks.md    ← criado agora (checklist de execução)
```

Preencher `draft.md` fazendo ao usuário no máximo 5 perguntas:
1. Qual o problema central que o cliente quer resolver?
2. Qual o impacto mensurável atual desse problema?
3. O que já foi tentado e por que não funcionou?
4. Qual o prazo que o cliente tem em mente?
5. Existe orçamento estimado ou restrição conhecida?

**Não gerar a proposta até ter respostas a pelo menos 1, 2 e 4.**

---

## Passo 1 — Validar a Spec

Ler `specs/<nome-do-cliente>/design.md` e verificar:
- Há pelo menos 3 critérios Given/When/Then?
- O escopo está delimitado (o que está dentro E o que está fora)?
- Os entregáveis têm critério de aceite definido?

Se qualquer item falhar: apontar o gap ao usuário e aguardar correção. **Não avançar com spec incompleta.**

---

## Passo 2 — Redigir a Proposta

Criar arquivo em `output/propostas/<nome-do-cliente>-proposta-v1.md`.

O documento deve começar exatamente com:

```markdown
---
cliente: <nome>
tipo: <Diagnóstico | Implementação | Sustentação>
versão: 1.0
data: <AAAA-MM-DD>
autor: Agente Apex (revisão humana pendente)
STATUS: RASCUNHO — Pendente revisão humana
---
```

Seguir rigorosamente a ordem de seções de `estrutura-proposta.md` (seções 1 a 8).

Regras de redação durante este passo:
- Usar os dados da spec, não inventar.
- Aplicar tom e convenções de `CLAUDE.md`.
- Se precisar de um valor de investimento, calcular a partir das faixas de `pricing-policy.md`.
- Se algum valor exigir aprovação, inserir a flag `[APROVAÇÃO NECESSÁRIA — ...]` e continuar redigindo o resto.

---

## Passo 3 — Auto-revisão

Antes de rodar o DoD, fazer uma passagem manual:

- [ ] Todas as 8 seções estão presentes com conteúdo real?
- [ ] Nenhum placeholder (`TODO`, `[inserir]`, `???`) visível?
- [ ] Nenhum nome de outro cliente mencionado?
- [ ] Valores dentro das faixas ou com flag de aprovação?
- [ ] Header de STATUS presente?

Se algum item falhar: corrigir antes de rodar o DoD.

---

## Passo 4 — Executar o DoD

```bash
bash scripts/dod-check.sh output/propostas/<nome-do-cliente>-proposta-v1.md
```

- Saída 0 → avançar para Passo 5.
- Saída 1 → ler o relatório de erros, corrigir, e rodar novamente. **Não declarar pronto com código 1.**

---

## Passo 5 — Registrar no Índice e Entregar ao Usuário

```bash
bash scripts/register-proposal.sh output/propostas/<nome-do-cliente>-proposta-v1.md
```

Reportar ao usuário:
1. O path do arquivo gerado.
2. O resultado do DoD (itens validados).
3. Se houver flags `[APROVAÇÃO NECESSÁRIA]`: listar quais são e quem precisa aprovar.
4. Lembrar que o STATUS no header é `RASCUNHO` e requer revisão humana antes do envio.
5. Sugerir próximo passo: `/aprovar-proposta` após revisão humana.

**Mensagem padrão de encerramento:**

> "Proposta gerada em `output/propostas/<arquivo>`. DoD passou com código 0. [Se houver flags: X itens requerem aprovação humana — listados acima.] O documento está marcado como RASCUNHO e pronto para revisão antes do envio ao cliente."

---

## O que esta skill NÃO faz

- Não envia a proposta ao cliente.
- Não agenda reuniões.
- Não acessa CRM ou sistemas externos.
- Não aprova seus próprios desvios de política.
- Não remove o header de STATUS.
