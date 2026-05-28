# claudedeck

Demonstração de **harness engineering** — como transformar um LLM em um agente confiável e governado.

O caso de uso é deliberadamente simples: geração, revisão e ciclo de vida completo de propostas comerciais para uma consultoria fictícia (Apex Consultoria). O foco é a **estrutura**, não a complexidade do domínio.

---

## O que é um harness?

Um harness é a camada de engenharia ao redor do modelo que define o que ele pode fazer, como ele age, e como você prova o que aconteceu. Sem harness, você tem um LLM. Com harness, você tem um agente governável.

```
modelo + harness = agente confiável
```

---

## As 5 camadas materializadas

### Camada 1 — Contexto
> *Impede que o agente opere de memória*

| Arquivo | Papel |
|---|---|
| `CLAUDE.md` | Identidade da consultoria, tom de voz, convenções de escrita, skills disponíveis |
| `.agent/knowledge/estrutura-proposta.md` | As 8 seções obrigatórias de toda proposta |
| `.agent/knowledge/pricing-policy.md` | Faixas de investimento, tabela de descontos, SLAs padrão |
| `.agent/knowledge/proposal-states.md` | Máquina de estados: ciclo de vida completo de uma proposta |
| `.agent/policy-config.json` | **Fonte única de verdade** para constantes numéricas — lida pelo DoD via `jq` |

O `policy-config.json` elimina a divergência silenciosa entre documentação e validação: qualquer mudança de política atualiza um único arquivo, e o DoD automaticamente passa a usar os novos valores.

### Camada 2 — Ferramentas
> *Impede que o agente escape do sandbox*

**Arquivo:** `.agent/tools.md`

Lista branca explícita: Read, Write, Edit, Bash (restrito a três scripts do repo), Grep/Find no repo. Tudo o que não está na lista está proibido — incluindo Gmail, Google Drive, WebSearch.

Scripts autorizados: `dod-check.sh`, `register-proposal.sh`, `update-proposal-status.sh`.

### Camada 3 — Guardrails
> *Impede violações de negócio antes de acontecerem*

**Arquivos:** `.agent/rules/proposta.md` e `.agent/rules/revisao.md`

`proposta.md` — cinco regras duras para geração:
1. SLA ou desconto fora de faixa → insere flag `[APROVAÇÃO NECESSÁRIA]` e para
2. Dados de outros clientes → bloqueado sem exceção
3. Declarar "pronto" sem DoD aprovado → bloqueado
4. Placeholders no documento final → bloqueado
5. Remover header `STATUS: RASCUNHO` → somente humano pode fazer

`revisao.md` — cinco guardrails adicionais para revisões:
- Nenhuma seção obrigatória pode ser removida
- Feedback deve ser catalogado antes de qualquer edição
- Alterações financeiras seguem as mesmas restrições da geração
- Versão deve ser incrementada — versão anterior não pode ser sobrescrita
- Todos os critérios GWT do `design.md` devem permanecer cobertos

### Camada 4 — Skills (Workflows)
> *Impede geração por prompt livre e cobre o ciclo de vida completo*

O harness tem quatro skills versionadas, cada uma com escopo e guardrails específicos:

| Skill | Trigger | Propósito |
|---|---|---|
| `gerar-proposta` v1.0.0 | `/gerar-proposta` | Workflow spec-driven de geração: spec → rascunho → DoD → índice |
| `revisar-proposta` v1.0.0 | `/revisar-proposta` | Feedback → nova versão → DoD + verificação de GWTs |
| `aprovar-proposta` v1.0.0 | `/aprovar-proposta` | Checklist de revisão humana → RASCUNHO → APROVADO |
| `fechar-proposta` v1.0.0 | `/fechar-proposta` | Registra desfecho: ENVIADO / GANHO / PERDIDO / ARQUIVADO |

### Camada 5 — Verificação (DoD)
> *Impede que "pronto" seja subjetivo — e garante que o validador ele mesmo é validado*

**Arquivo:** `scripts/dod-check.sh`

Script executável com 17 verificações objetivas. Saída `0` (aprovado) ou `1` (reprovado). Lê limites diretamente de `.agent/policy-config.json` via `jq`. Valida:
- As 8 seções obrigatórias estão presentes
- Nenhum placeholder (`TODO`, `[inserir]`, `???`, etc.)
- Header `STATUS: RASCUNHO` presente
- Nenhuma flag de aprovação pendente não resolvida
- Valores de investimento dentro do limite autônomo (lido do `policy-config.json`)
- Nenhuma referência cruzada a dados de outros clientes
- Frontmatter completo (`cliente`, `tipo`, `data`, `autor`)

**O harness testa a si mesmo:** `tests/dod-check.test.sh` executa 7 casos com fixtures reais (propostas que devem passar e propostas que devem falhar em cada bloco específico).

```bash
bash tests/dod-check.test.sh
# → 7/7 testes passaram — STATUS: APROVADO
```

---

## Ciclo de vida completo

Toda proposta começa por especificação e percorre estados explícitos até o desfecho.

```
specs/<cliente>/
  draft.md    ← Fase 1: briefing do problema (5 perguntas)
  design.md   ← Fase 2: contrato Given/When/Then
  tasks.md    ← Fase 3: checklist de execução
      ↓
/gerar-proposta  (skill)
      ↓
output/propostas/<cliente>-proposta-v1.md   [STATUS: RASCUNHO]
      ↓
scripts/dod-check.sh  →  saída 0 ou 1
      ↓
scripts/register-proposal.sh  →  output/proposals-index.json
      ↓
/revisar-proposta  (skill — se houver feedback)
      ↓
output/propostas/<cliente>-proposta-v2.md   [STATUS: RASCUNHO]
      ↓
/aprovar-proposta  (skill — revisão humana obrigatória)
      ↓
[STATUS: APROVADO]
      ↓
/fechar-proposta  (skill)
      ↓
[STATUS: ENVIADO → GANHO | PERDIDO | ARQUIVADO]
```

A máquina de estados completa com todas as transições válidas está em `.agent/knowledge/proposal-states.md`. Nenhuma transição de estado ocorre sem ação humana explícita.

O diretório `specs/_template/` contém os templates canônicos de `draft.md`, `design.md` e `tasks.md` — copiar para `specs/<novo-cliente>/` antes de iniciar uma proposta.

---

## Governança: as 3 perguntas

| Pergunta | Onde está a resposta |
|---|---|
| Esta ação é permitida? | `.agent/tools.md` + `.agent/rules/proposta.md` + `.agent/rules/revisao.md` + `SKILL.md` |
| Qual agente fez? | Frontmatter do documento (`autor:`, `skill_version:`) + `git log` |
| Consigo provar o que aconteceu? | `specs/<cliente>/` + `output/` + `dod-check.sh` + `output/proposals-index.json` |
| Em que estado está a proposta? | `output/proposals-index.json` + `.agent/knowledge/proposal-states.md` |

O `proposals-index.json` é o registro auditável de todos os artefatos gerados — cliente, skill usada, se o DoD passou, quantas flags de aprovação existiam, estado atual e histórico de transições.

Detalhamento completo em `GOVERNANCE.md`.

---

## Como usar

```bash
# Clonar e rodar os testes do harness
git clone git@github.com:glaucojbs/claudedeck.git
cd claudedeck
bash tests/dod-check.test.sh

# Rodar o DoD contra a proposta de exemplo
bash scripts/dod-check.sh output/propostas/cliente-exemplo-proposta-v1.md

# Consultar o índice de propostas
cat output/proposals-index.json | jq .

# Para gerar uma nova proposta (dentro do Claude Code)
# 1. Copie specs/_template/ para specs/<nome-do-cliente>/
# 2. Execute /gerar-proposta
# 3. O agente roda o DoD e registra no índice automaticamente

# Para revisar uma proposta existente
# 1. Forneça o feedback do cliente ao agente
# 2. Execute /revisar-proposta
# 3. O agente verifica cobertura de GWTs, roda o DoD e registra v2

# Para aprovar uma proposta (revisão humana)
# Execute /aprovar-proposta
# O agente apresenta checklist, aguarda confirmação e registra APROVADO

# Para registrar o desfecho
# Execute /fechar-proposta
# O agente captura contexto (canal, motivo, contato) e atualiza índice
```

---

## Estrutura do repositório

```
.agent/
  knowledge/
    estrutura-proposta.md      ← Camada 1: 8 seções obrigatórias
    pricing-policy.md          ← Camada 1: faixas e SLAs (narrativa)
    proposal-states.md         ← Camada 1: máquina de estados do ciclo de vida
  policy-config.json           ← Camada 1: constantes numéricas (fonte de verdade)
  rules/
    proposta.md                ← Camada 3: 5 guardrails de geração
    revisao.md                 ← Camada 3: 5 guardrails de revisão
  skills/
    gerar-proposta/
      SKILL.md                 ← Camada 4: workflow de geração v1.0.0
    revisar-proposta/
      SKILL.md                 ← Camada 4: workflow de revisão v1.0.0
    aprovar-proposta/
      SKILL.md                 ← Camada 4: workflow de aprovação v1.0.0
    fechar-proposta/
      SKILL.md                 ← Camada 4: workflow de fechamento v1.0.0
  tools.md                     ← Camada 2: interface curada (3 scripts autorizados)
scripts/
  dod-check.sh                 ← Camada 5: DoD executável (lê policy-config.json)
  register-proposal.sh         ← Registra artefato no índice após geração/revisão
  update-proposal-status.sh    ← Transições de estado no índice
specs/
  _template/                   ← Templates canônicos (draft + design + tasks)
  proposta-cliente-exemplo/    ← Spec de demonstração
output/
  propostas/                   ← Artefatos gerados
  proposals-index.json         ← Registro auditável com estado de cada proposta
tests/
  dod-check.test.sh            ← Suite de auto-teste do harness (7/7)
  fixtures/                    ← Propostas de teste (válida + 5 casos de falha)
CLAUDE.md                      ← Identidade e convenções do agente
GOVERNANCE.md                  ← Mapeamento das 3+1 perguntas de governança
CHANGELOG.md                   ← Histórico versionado do harness
```
