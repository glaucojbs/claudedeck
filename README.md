# claudedeck

Demonstração de **harness engineering** — como transformar um LLM em um agente confiável e governado.

O caso de uso é deliberadamente simples: geração e revisão de propostas comerciais para uma consultoria fictícia (Apex Consultoria). O foco é a **estrutura**, não a complexidade do domínio.

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
| `.agent/policy-config.json` | **Fonte única de verdade** para constantes numéricas — lida pelo DoD via `jq` |

O `policy-config.json` elimina a divergência silenciosa entre documentação e validação: qualquer mudança de política atualiza um único arquivo, e o DoD automaticamente passa a usar os novos valores.

### Camada 2 — Ferramentas
> *Impede que o agente escape do sandbox*

**Arquivo:** `.agent/tools.md`

Lista branca explícita: Read, Write, Edit, Bash (restrito a scripts do repo), Grep/Find no repo. Tudo o que não está na lista está proibido — incluindo Gmail, Google Drive, WebSearch.

### Camada 3 — Guardrails
> *Impede violações de negócio antes de acontecerem*

**Arquivo:** `.agent/rules/proposta.md`

Cinco regras duras:
1. SLA ou desconto fora de faixa → insere flag `[APROVAÇÃO NECESSÁRIA]` e para
2. Dados de outros clientes → bloqueado sem exceção
3. Declarar "pronto" sem DoD aprovado → bloqueado
4. Placeholders no documento final → bloqueado
5. Remover header `STATUS: RASCUNHO` → somente humano pode fazer

### Camada 4 — Skills (Workflows)
> *Impede geração por prompt livre e demonstra que o padrão escala*

O harness tem duas skills versionadas com guardrails especializados:

| Skill | Trigger | Propósito |
|---|---|---|
| `gerar-proposta` v1.0.0 | `/gerar-proposta` | Workflow spec-driven de geração: spec → rascunho → DoD |
| `revisar-proposta` v1.0.0 | `/revisar-proposta` | Workflow de revisão: feedback → revisão → DoD + verificação de GWTs |

A skill de revisão tem guardrails adicionais: nunca remove seções obrigatórias, exige cobertura de todos os critérios Given/When/Then do `design.md`, e gera seção de histórico de revisões no documento.

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

## Spec-driven: o fluxo de trabalho

Toda proposta começa por especificação, nunca por prompt livre.

```
specs/<cliente>/
  draft.md    ← Fase 1: brainstorm do problema (5 perguntas)
  design.md   ← Fase 2: contrato Given/When/Then
  tasks.md    ← Fase 3: checklist de execução
      ↓
/gerar-proposta  (skill)
      ↓
output/propostas/<cliente>-proposta-v1.md
      ↓
scripts/dod-check.sh  →  saída 0 ou 1
      ↓
scripts/register-proposal.sh  →  output/proposals-index.json
```

Para revisões, o fluxo continua:

```
feedback do cliente
      ↓
/revisar-proposta  (skill)
      ↓
output/propostas/<cliente>-proposta-v2.md
      ↓
scripts/dod-check.sh  →  saída 0 ou 1
      ↓
scripts/register-proposal.sh  →  output/proposals-index.json
```

O diretório `specs/proposta-cliente-exemplo/` é a demonstração completa com um cliente fictício (Cliente Exemplo Ltda).

---

## Governança: as 3 perguntas

| Pergunta | Onde está a resposta |
|---|---|
| Esta ação é permitida? | `.agent/tools.md` + `.agent/rules/proposta.md` + `SKILL.md` |
| Qual agente fez? | Frontmatter do documento (`autor:`, `skill_version:`) + `git log` |
| Consigo provar o que aconteceu? | `specs/<cliente>/` + `output/` + `dod-check.sh` + `output/proposals-index.json` |

O `proposals-index.json` é o registro auditável de todos os artefatos gerados — cliente, skill usada, se o DoD passou, quantas flags de aprovação existiam, e status de revisão humana.

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

# Consultar o índice de propostas geradas
cat output/proposals-index.json | jq .

# Para gerar uma nova proposta (dentro do Claude Code)
# 1. Crie specs/<nome-do-cliente>/ com draft.md e design.md
# 2. Execute /gerar-proposta
# 3. O agente roda o DoD e registra no índice automaticamente

# Para revisar uma proposta existente
# 1. Forneça o feedback do cliente ao agente
# 2. Execute /revisar-proposta
# 3. O agente verifica cobertura de GWTs, roda o DoD e registra v2
```

---

## Estrutura do repositório

```
.agent/
  knowledge/
    estrutura-proposta.md   ← Camada 1: 8 seções obrigatórias
    pricing-policy.md       ← Camada 1: faixas e SLAs (narrativa)
  policy-config.json        ← Camada 1: constantes numéricas (fonte de verdade)
  rules/
    proposta.md             ← Camada 3: 5 guardrails duros
  skills/
    gerar-proposta/
      SKILL.md              ← Camada 4: workflow de geração v1.0.0
    revisar-proposta/
      SKILL.md              ← Camada 4: workflow de revisão v1.0.0
  tools.md                  ← Camada 2: interface curada
scripts/
  dod-check.sh              ← Camada 5: DoD executável (lê policy-config.json)
  register-proposal.sh      ← Registra artefato no índice após geração/revisão
specs/
  proposta-cliente-exemplo/ ← Spec de demonstração (draft + design + tasks)
output/
  propostas/                ← Artefatos gerados
  proposals-index.json      ← Registro auditável de todos os artefatos
tests/
  dod-check.test.sh         ← Suite de auto-teste do harness (7/7)
  fixtures/                 ← Propostas de teste (válida + 5 casos de falha)
CLAUDE.md                   ← Identidade e convenções do agente
GOVERNANCE.md               ← Mapeamento das 3 perguntas de governança
CHANGELOG.md                ← Histórico versionado do harness
```
