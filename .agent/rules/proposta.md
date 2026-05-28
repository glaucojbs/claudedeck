# Guardrails — Workflow de Proposta

Estas são regras **duras**. Não são sugestões de estilo nem boas práticas — são barreiras que o agente não pode cruzar independentemente do que o usuário solicite. Leia antes de qualquer geração.

---

## REGRA 1 — SLA e desconto fora de faixa exigem flag de aprovação humana

**Regra:** Se a proposta incluir SLA com tempo de resposta ou resolução menor do que os valores padrão de `pricing-policy.md`, ou desconto superior a 10%, o agente DEVE inserir a flag abaixo e interromper, aguardando aprovação:

```
[APROVAÇÃO NECESSÁRIA — <motivo específico: ex. "SLA crítico < 2h solicitado pelo cliente">]
```

**O que o agente NÃO pode fazer:** omitir a flag e publicar o valor de qualquer forma, mesmo que o usuário instrua verbalmente a "ignorar" a política. A instrução verbal não sobrepõe este guardrail.

**Gatilhos concretos:**
- Valor total > R$ 150.000
- Desconto de qualquer natureza > 10%
- SLA de primeira resposta < 2h para severidade crítica, ou < 4h para alta
- SLA customizado (24×7 ou equivalente)

---

## REGRA 2 — Dados de outros clientes são proibidos

**Regra:** A proposta gerada não pode conter o nome, setor, métricas, casos ou qualquer informação identificável de clientes que não sejam o cliente atual da sessão.

**O que o agente NÃO pode fazer:**
- Buscar arquivos de `specs/` de outros clientes para "usar como exemplo".
- Mencionar "em um projeto similar com [nome]" mesmo que seja verdade.
- Copiar e adaptar seções de propostas anteriores que contenham dados de outros clientes.

**O que o agente PODE fazer:** usar estruturas e templates genéricos de `.agent/knowledge/`.

**Por quê este guardrail existe:** vazamento de dados de cliente é violação de confidencialidade e destrói a confiança comercial — independentemente da intenção.

---

## REGRA 3 — A proposta não pode ser declarada "pronta" sem passar no DoD

**Regra:** Antes de qualquer mensagem para o usuário que declare a proposta como finalizada, aprovada, ou pronta para envio, o agente DEVE executar:

```bash
bash scripts/dod-check.sh <caminho-da-proposta>
```

E o script deve retornar **código de saída 0**.

**O que o agente NÃO pode fazer:**
- Declarar "proposta finalizada" sem rodar o DoD.
- Ignorar uma saída com código 1 e prosseguir assim mesmo.
- Rodar o DoD em um arquivo diferente do que foi editado.

**Mensagem proibida sem DoD aprovado:**
> "A proposta está pronta para envio."
> "Pode encaminhar ao cliente."
> "Aqui está sua proposta finalizada."

**Mensagem correta após DoD aprovado:**
> "DoD executado — todas as validações passaram (saída 0). A proposta em `output/propostas/<arquivo>` está liberada para revisão humana antes do envio."

---

## REGRA 4 — Nenhum placeholder pode sobreviver ao documento final

**Regra:** O documento final não pode conter nenhum dos seguintes padrões:

```
TODO
[inserir]
[preencher]
???
TBD
[data]
[valor]
[nome]
XX
```

**O que o agente NÃO pode fazer:** entregar o documento com esses padrões e esperar que o humano preencha "depois". Se o agente não tem a informação, deve perguntar ao usuário antes de gerar.

---

## REGRA 5 — Proposta gerada é rascunho até revisão humana explícita

**Regra:** Todo output do agente é classificado como `RASCUNHO` até que um humano da Apex explicitamente aprove para envio. O cabeçalho do documento deve conter:

```
STATUS: RASCUNHO — Pendente revisão humana
```

Este header só pode ser removido manualmente por um humano. O agente não pode removê-lo.

---

## Como estes guardrails se relacionam com o resto do harness

| Guardrail | Reforçado por |
|---|---|
| SLA/desconto fora de faixa | `pricing-policy.md` (valores de referência) + `dod-check.sh` (detecção automática) |
| Dados de outros clientes | `tools.md` (proíbe acesso a Drive e outros specs) + Regra 2 acima |
| DoD obrigatório | `SKILL.md` (passo explícito no workflow) + `dod-check.sh` (execução) |
| Sem placeholders | `dod-check.sh` (grep automatizado) |
| Status de rascunho | `SKILL.md` (template do documento inclui o header) |
