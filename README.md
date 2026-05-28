# claudedeck

Demonstração de **harness engineering** — como transformar um LLM em um agente confiável e governado.

O caso de uso é deliberadamente simples: geração de proposta comercial para uma consultoria fictícia (Apex Consultoria). O foco é a **estrutura**, não a complexidade do domínio.

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

### Camada 2 — Ferramentas
> *Impede que o agente escape do sandbox*

**Arquivo:** `.agent/tools.md`

Lista branca explícita: Read, Write, Edit, Bash (restrito a `dod-check.sh`), Grep/Find no repo. Tudo o que não está na lista está proibido — incluindo Gmail, Google Drive, WebSearch.

### Camada 3 — Guardrails
> *Impede violações de negócio antes de acontecerem*

**Arquivo:** `.agent/rules/proposta.md`

Cinco regras duras:
1. SLA ou desconto fora de faixa → insere flag `[APROVAÇÃO NECESSÁRIA]` e para
2. Dados de outros clientes → bloqueado sem exceção
3. Declarar "pronto" sem DoD aprovado → bloqueado
4. Placeholders no documento final → bloqueado
5. Remover header `STATUS: RASCUNHO` → somente humano pode fazer

### Camada 4 — Skill (Workflow)
> *Impede geração por prompt livre*

**Arquivo:** `.agent/skills/gerar-proposta/SKILL.md`

Workflow spec-driven em 5 passos: validar pré-condições → validar spec → redigir proposta → auto-revisão → executar DoD. O agente não gera proposta a partir de prompt solto — exige spec prévia.

### Camada 5 — Verificação (DoD)
> *Impede que "pronto" seja subjetivo*

**Arquivo:** `scripts/dod-check.sh`

Script executável com 17 verificações objetivas. Saída `0` (aprovado) ou `1` (reprovado). Valida:
- As 8 seções obrigatórias estão presentes
- Nenhum placeholder (`TODO`, `[inserir]`, `???`, etc.)
- Header `STATUS: RASCUNHO` presente
- Nenhuma flag de aprovação pendente não resolvida
- Valores de investimento dentro do limite autônomo (R$ 150k)
- Nenhuma referência cruzada a dados de outros clientes
- Frontmatter completo (`cliente`, `tipo`, `data`, `autor`)

---

## Spec-driven: o fluxo de trabalho

Toda proposta começa por especificação, nunca por prompt livre.

```
specs/<cliente>/
  draft.md    ← Fase 1: brainstorm do problema (5 perguntas)
  design.md   ← Fase 2: contrato Given/When/Then
  tasks.md    ← Fase 3: checklist de execução
      ↓
output/propostas/<cliente>-proposta-v1.md
      ↓
scripts/dod-check.sh  →  saída 0 ou 1
```

O diretório `specs/proposta-cliente-exemplo/` é a demonstração completa com um cliente fictício (Cliente Exemplo Ltda).

---

## Governança: as 3 perguntas

| Pergunta | Onde está a resposta |
|---|---|
| Esta ação é permitida? | `.agent/tools.md` + `.agent/rules/proposta.md` + `SKILL.md` |
| Qual agente fez? | Frontmatter do documento (`autor:`) + `git log` + versão da SKILL |
| Consigo provar o que aconteceu? | `specs/<cliente>/` (o que foi especificado) + `output/` (o que foi gerado) + `dod-check.sh` (validação reproduzível) |

Detalhamento completo em `GOVERNANCE.md`.

---

## Como usar

```bash
# Clonar e rodar o DoD contra a proposta de exemplo
git clone git@github.com:glaucojbs/claudedeck.git
cd claudedeck
bash scripts/dod-check.sh output/propostas/cliente-exemplo-proposta-v1.md

# Para gerar uma nova proposta (dentro do Claude Code)
# 1. Crie specs/<nome-do-cliente>/ com draft.md e design.md
# 2. Execute a skill /gerar-proposta
# 3. O agente roda o DoD automaticamente antes de declarar pronto
```

---

## Estrutura do repositório

```
.agent/
  knowledge/          ← Camada 1: base de conhecimento
  rules/              ← Camada 3: guardrails
  skills/             ← Camada 4: workflows versionados
  tools.md            ← Camada 2: interface curada
scripts/
  dod-check.sh        ← Camada 5: DoD executável
specs/
  proposta-cliente-exemplo/   ← Spec de demonstração
output/
  propostas/          ← Artefatos gerados
CLAUDE.md             ← Identidade e convenções do agente
GOVERNANCE.md         ← Mapeamento das 3 perguntas de governança
```
