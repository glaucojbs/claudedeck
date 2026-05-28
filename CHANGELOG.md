# Changelog — Harness Apex

Todas as mudanças relevantes neste harness são documentadas aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).
Versionamento segue [Semantic Versioning](https://semver.org/lang/pt-BR/):
- `MAJOR` — mudança em guardrail ou regra dura (comportamento do agente muda)
- `MINOR` — nova skill, nova seção obrigatória, novo bloco no DoD
- `PATCH` — correção de texto, ajuste de faixa de preço, bug em script

---

## [Não lançado]

### Adicionado
- `.agent/policy-config.json` como fonte única de verdade para constantes numéricas
- `tests/` — suite de testes do próprio DoD (o harness testa a si mesmo)
- Skill `revisar-proposta` para o workflow de revisão de propostas existentes
- `output/proposals-index.json` — registro auditável de todos os artefatos gerados
- `scripts/register-proposal.sh` — atualiza o índice após geração/revisão
- `CHANGELOG.md` — este arquivo

### Alterado
- `scripts/dod-check.sh` — lê `LIMITE_AUTONOMO` e `MAX_DESCONTO` de `policy-config.json` (elimina constantes hardcoded)
- `.agent/knowledge/pricing-policy.md` — referencia `policy-config.json` como fonte de verdade

---

## [1.0.0] — 2026-05-28

### Adicionado
- `CLAUDE.md` — identidade da Apex Consultoria, convenções de escrita, tom de voz
- `GOVERNANCE.md` — mapeamento das 3 perguntas de governança para artefatos concretos
- `.agent/knowledge/estrutura-proposta.md` — 8 seções obrigatórias de toda proposta
- `.agent/knowledge/pricing-policy.md` v1.2 — faixas de investimento, tabela de descontos, SLAs padrão
- `.agent/tools.md` — lista branca de ferramentas permitidas e lista negra explícita
- `.agent/rules/proposta.md` — 5 guardrails duros com gatilhos concretos
- `.agent/skills/gerar-proposta/SKILL.md` v1.0.0 — workflow spec-driven de 5 passos
- `scripts/dod-check.sh` — Definition of Done executável com 17 verificações em 7 blocos
- `specs/proposta-cliente-exemplo/` — spec completa de demonstração (draft + design + tasks)
- `output/propostas/cliente-exemplo-proposta-v1.md` — proposta gerada que passa o DoD

### Decisões de design desta versão
- Princípio de lista branca para ferramentas: se não está liberado, está proibido
- Workflow spec-driven: spec sempre precede geração
- DoD como contrato de qualidade: saída 0/1, determinístico, re-executável
- STATUS: RASCUNHO imutável pelo agente: toda proposta exige revisão humana antes do envio
