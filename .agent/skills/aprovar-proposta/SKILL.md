# SKILL: aprovar-proposta

Versão: 1.0.0 | Trigger: `/aprovar-proposta`

---

## Trigger Description

Ativada quando um humano da Apex revisa um rascunho de proposta e decide aprová-la para envio ao cliente. Esta skill **não** aprova sozinha — ela guia o processo de revisão humana e registra a decisão.

**Pré-requisito:** a proposta deve existir em `output/propostas/` com `STATUS: RASCUNHO`.

---

## Pré-condições

Antes de iniciar, verificar:

1. O usuário forneceu o nome do cliente e/ou o path da proposta?
   - Não → perguntar.

2. O arquivo `output/propostas/<cliente>-proposta-v<N>.md` existe?
   - Não → interromper. Não há o que aprovar.

3. O STATUS atual no frontmatter é `RASCUNHO`?
   - Se já for `APROVADO` ou posterior: informar o usuário e encerrar sem alterações.

---

## Passo 1 — Executar o DoD

```bash
bash scripts/dod-check.sh output/propostas/<cliente>-proposta-v<N>.md
```

- Código 1 → reportar falhas ao usuário e **interromper**. Aprovação não é possível com DoD falhando.
- Código 0 → avançar.

---

## Passo 2 — Apresentar Checklist de Revisão Humana

Exibir ao usuário o seguinte checklist. O agente **NÃO** marca os itens — apenas o humano pode confirmar:

```
CHECKLIST DE REVISÃO HUMANA — <cliente> v<N>
─────────────────────────────────────────────
[ ] O diagnóstico do problema está correto e reflete o que o cliente disse?
[ ] O escopo (dentro e fora) reflete o acordado na conversa com o cliente?
[ ] Os entregáveis têm critérios de aceite claros e verificáveis?
[ ] Os valores e prazos foram verificados internamente e são viáveis?
[ ] Não há informações de outros clientes no documento?
[ ] As premissas e exclusões estão completas e protegem a Apex?
[ ] Os próximos passos têm responsável e prazo definidos?
[ ] Todas as flags [APROVAÇÃO NECESSÁRIA] foram resolvidas (se houver)?
```

Aguardar a resposta explícita do usuário: "aprovado", "ok", "pode aprovar" ou equivalente.

Se o usuário apontar problemas: **interromper** e orientar a usar `/revisar-proposta` para uma nova versão antes de retornar aqui.

---

## Passo 3 — Registrar a Aprovação

Após confirmação explícita do usuário:

1. Editar o frontmatter do arquivo: substituir a linha `STATUS: RASCUNHO — Pendente revisão humana` por:
   ```
   STATUS: APROVADO — Revisado por humano em <AAAA-MM-DD>
   ```

2. Atualizar o índice via script:
   ```bash
   bash scripts/update-proposal-status.sh output/propostas/<cliente>-proposta-v<N>.md APROVADO
   ```

---

## Passo 4 — Entregar Confirmação

Reportar ao usuário:
1. Path da proposta aprovada.
2. Data do registro da aprovação.
3. Próximo passo sugerido: quando enviar ao cliente, executar `/fechar-proposta` para registrar o envio.

**Mensagem padrão de encerramento:**

> "Proposta `output/propostas/<arquivo>` aprovada e registrada com STATUS: APROVADO em <data>. Quando a proposta for enviada ao cliente, execute `/fechar-proposta` para registrar o envio e acompanhar o desfecho."

---

## O que esta skill NÃO faz

- Não aprova automaticamente sem confirmação humana explícita.
- Não envia a proposta ao cliente.
- Não resolve flags `[APROVAÇÃO NECESSÁRIA]` — essas precisam ser resolvidas externamente antes.
- Não aprova propostas com DoD falhando.
- Não remove o campo `autor: Agente Apex (revisão humana pendente)` — isso é responsabilidade do revisor.
