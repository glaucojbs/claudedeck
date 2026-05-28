# Governança do Agente — Apex Consultoria

Este documento mapeia como a estrutura deste repositório responde às 3 perguntas fundamentais de governança de agentes de IA. Cada resposta aponta para o artefato concreto que a suporta.

---

## Pergunta 1 — Esta ação é permitida?

**Resposta:** Sim/Não é determinado pela combinação de três camadas lidas em sequência antes de qualquer geração.

### Camada A — O agente pode usar esta ferramenta?
**Arquivo:** `.agent/tools.md`

Contém a lista branca de ferramentas permitidas (Read, Write, Edit, Bash restrito a dod-check.sh, Grep/Find no repo) e a lista negra explícita (Gmail, Google Calendar, Google Drive, WebSearch, Bash geral). O princípio é lista branca: se não está liberado, está proibido.

### Camada B — Esta ação viola uma regra dura?
**Arquivo:** `.agent/rules/proposta.md`

Contém 5 guardrails com gatilhos concretos:
- Regra 1: SLA/desconto fora de faixa → bloqueia e insere flag `[APROVAÇÃO NECESSÁRIA]`
- Regra 2: dados de outros clientes → bloqueia sem exceção
- Regra 3: declarar "pronto" sem DoD aprovado → bloqueia
- Regra 4: placeholders no documento final → bloqueia
- Regra 5: remover o header STATUS → bloqueia

### Camada C — A ação está dentro do workflow declarado?
**Arquivo:** `.agent/skills/gerar-proposta/SKILL.md`

O workflow é spec-driven: o agente só gera proposta se existir uma spec em `specs/<cliente>/`. Gerar a partir de prompt livre não é um passo do workflow — portanto não está permitido.

**Como as três camadas se relacionam:** Tools.md define a superfície de execução. Rules/proposta.md define as regras de negócio. SKILL.md define o fluxo de trabalho. Uma ação só é permitida se passa pelos três.

---

## Pergunta 2 — Qual agente fez?

**Resposta:** O documento gerado carrega sua autoria e o registro de quem o produziu de forma imutável até revisão humana.

### Frontmatter do documento
**Arquivo:** Todo arquivo em `output/propostas/*.md`

O header obrigatório de toda proposta gerada inclui:
```yaml
autor: Agente Apex (revisão humana pendente)
STATUS: RASCUNHO — Pendente revisão humana
```

Este header não pode ser removido pelo agente (Regra 5 de `.agent/rules/proposta.md`). Só um humano pode remover.

### Versionamento git
**Mecanismo:** `git log`

Todo arquivo gerado ou modificado é commitado com autoria do usuário que executou a sessão. O histórico de commits é a trilha de auditoria de quem iniciou cada geração.

### Skill versionada
**Arquivo:** `.agent/skills/gerar-proposta/SKILL.md` (campo `Versão: 1.0.0`)

A versão da skill usada na geração é rastreável pelo commit do arquivo. Se a política mudou entre a geração e a revisão, é possível verificar qual versão da skill estava vigente.

---

## Pergunta 3 — Consigo provar o que aconteceu?

**Resposta:** Sim, através de três artefatos independentes que se corroboram.

### Artefato 1 — A spec
**Diretório:** `specs/<nome-do-cliente>/`

Contém `draft.md` (problema capturado), `design.md` (requisitos Given/When/Then aprovados) e `tasks.md` (checklist de execução com estado no momento da geração). Prova o que o agente sabia antes de gerar.

### Artefato 2 — O documento gerado
**Diretório:** `output/propostas/`

O documento em si é o artefato primário. O frontmatter carrega data, tipo, versão e autor. Prova o que foi produzido.

### Artefato 3 — O relatório do DoD
**Arquivo:** `scripts/dod-check.sh` (executado sobre o documento gerado)

O script produz um relatório com lista de verificações passadas e falhas, com timestamp. Executável novamente a qualquer momento sobre o mesmo arquivo para reproduzir o resultado. Prova que o documento passou (ou não) nos critérios mínimos no momento da entrega.

---

## Resumo Visual

```
Pergunta de Governança          Onde a resposta está
─────────────────────────────── ────────────────────────────────────────────
Esta ação é permitida?          .agent/tools.md         (superfície de execução)
                                .agent/rules/proposta.md (guardrails de negócio)
                                .agent/skills/*/SKILL.md (fluxo autorizado)

Qual agente fez?                output/propostas/*.md   (frontmatter: autor + status)
                                git log                  (histórico de commits)
                                SKILL.md versão          (versão do workflow usado)

Consigo provar o que aconteceu? specs/<cliente>/         (o que foi especificado)
                                output/propostas/*.md    (o que foi gerado)
                                scripts/dod-check.sh     (validação reproduzível)
```

---

## O que esta estrutura não resolve

Honestidade sobre os limites é parte da governança:

1. **Qualidade do conteúdo:** o DoD valida estrutura e conformidade de política, não se o diagnóstico do problema está correto. Revisão humana é obrigatória e insubstituível.
2. **Vazamento semântico:** o guardrail de "outros clientes" detecta referências a paths de specs, mas não detecta se o agente parafrasear informações de memória de sessões anteriores. Cada sessão deve começar limpa.
3. **Aprovações humanas:** a flag `[APROVAÇÃO NECESSÁRIA]` bloqueia o fluxo, mas não garante que a aprovação foi dada. O processo de aprovação humana é externo a este harness.
