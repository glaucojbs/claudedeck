# Changelog — Harness Apex

Todas as mudanças relevantes neste harness são documentadas aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).
Versionamento segue [Semantic Versioning](https://semver.org/lang/pt-BR/):
- `MAJOR` — mudança em guardrail ou regra dura (comportamento do agente muda)
- `MINOR` — nova skill, nova seção obrigatória, novo bloco no DoD
- `PATCH` — correção de texto, ajuste de faixa de preço, bug em script

---

## [1.2.0] — 2026-05-28

### Adicionado
- `.agent/rules/revisao.md` — 5 guardrails específicos do workflow de revisão (referência quebrada: `revisar-proposta/SKILL.md` já apontava para este arquivo)
- `.agent/knowledge/proposal-states.md` — máquina de estados explícita com transições válidas, regras e onde o estado é armazenado
- `.agent/skills/aprovar-proposta/SKILL.md` v1.0.0 — workflow com checklist de revisão humana e promoção RASCUNHO → APROVADO
- `.agent/skills/fechar-proposta/SKILL.md` v1.0.0 — workflow de desfecho (ENVIADO / GANHO / PERDIDO / ARQUIVADO) com captura de contexto
- `scripts/update-proposal-status.sh` — transições de estado no índice com validação de estados permitidos
- `specs/_template/` — templates canônicos de `draft.md`, `design.md` e `tasks.md`

### Alterado
- `CLAUDE.md` — tabela de conhecimento e lista de skills atualizadas para refletir estrutura completa
- `.agent/tools.md` — corrigida inconsistência: `register-proposal.sh` e `update-proposal-status.sh` agora listados explicitamente como Bash autorizado
- `.agent/skills/gerar-proposta/SKILL.md` — Passo 5 agora chama `register-proposal.sh` (estava ausente; `revisar-proposta` já chamava)
- `GOVERNANCE.md` — Resumo Visual inclui dimensão "Em que estado está a proposta?"

---

## [1.1.0] — 2026-05-28

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
