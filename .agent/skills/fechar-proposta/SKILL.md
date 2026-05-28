# SKILL: fechar-proposta

Versão: 1.0.0 | Trigger: `/fechar-proposta`

---

## Trigger Description

Ativada para registrar uma transição de estado após o envio ou desfecho de uma proposta. Cobre os estados: `ENVIADO`, `GANHO`, `PERDIDO`, `ARQUIVADO`.

Consulte `.agent/knowledge/proposal-states.md` para entender as transições válidas.

---

## Pré-condições

Antes de iniciar, verificar:

1. O usuário forneceu o nome do cliente e/ou o path da proposta?
   - Não → perguntar.

2. O usuário informou o novo status desejado?
   - Não → perguntar. Opções válidas: `ENVIADO`, `GANHO`, `PERDIDO`, `ARQUIVADO`.

3. A transição solicitada é válida conforme `proposal-states.md`?
   - Não → informar qual estado atual está registrado e quais transições são possíveis a partir dele.

---

## Passo 1 — Capturar Contexto do Fechamento

Dependendo do status solicitado, coletar informações antes de continuar:

| Status | Campos obrigatórios |
|---|---|
| `ENVIADO` | Data de envio, canal (e-mail, reunião, plataforma) |
| `GANHO` | Data de aceite, valor contratado confirmado, nome do contato que confirmou |
| `PERDIDO` | Data, motivo (preço / prazo / concorrência / desistência / outro), feedback do cliente se disponível |
| `ARQUIVADO` | Motivo interno (cliente desapareceu / projeto cancelado / decisão estratégica / outro) |

Se algum campo obrigatório não foi fornecido: perguntar antes de continuar.

---

## Passo 2 — Atualizar o Frontmatter

Editar `output/propostas/<cliente>-proposta-v<N>.md`.

Substituir a linha de STATUS atual por:
```
STATUS: <NOVO_STATUS> — <AAAA-MM-DD> — <resumo de 1 linha>
```

Exemplos válidos:
```
STATUS: GANHO — 2026-06-15 — Contrato assinado por João Silva (CEO)
STATUS: PERDIDO — 2026-06-10 — Preço acima do orçamento aprovado pelo cliente
STATUS: ENVIADO — 2026-06-01 — Enviado por e-mail para contato@cliente.com.br
STATUS: ARQUIVADO — 2026-05-30 — Cliente encerrou processo de avaliação sem retorno
```

---

## Passo 3 — Atualizar o Índice

```bash
bash scripts/update-proposal-status.sh output/propostas/<cliente>-proposta-v<N>.md <NOVO_STATUS> "<motivo resumido>"
```

---

## Passo 4 — Confirmar ao Usuário

Reportar:
1. Estado anterior e novo estado registrado.
2. Data do registro.
3. Contexto específico por desfecho:

**Se GANHO:**
> Parabéns. Lembrar de iniciar a spec do projeto de implementação em `specs/<cliente>/` assim que o contrato for assinado.

**Se PERDIDO:**
> Perguntar ao usuário se deseja registrar uma nota de aprendizado em `specs/<cliente>/feedback-perdido.md` para referência futura (mas não criar nada sem confirmação).

**Se ENVIADO:**
> Lembrar que a validade padrão da proposta é 30 dias (conforme `policy-config.json`). Considerar acompanhamento ativo antes do vencimento.

**Se ARQUIVADO:**
> Nenhuma ação adicional necessária. O histórico permanece em `output/propostas/` para referência.

---

## O que esta skill NÃO faz

- Não envia a proposta ao cliente — isso é responsabilidade humana.
- Não cancela projetos de implementação em andamento.
- Não cria spec de implementação automaticamente ao registrar GANHO.
- Não desfaz transições de estado — GANHO → RASCUNHO não existe.
- Não deleta propostas — o histórico é preservado mesmo para PERDIDO e ARQUIVADO.
