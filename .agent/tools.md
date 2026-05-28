# Interface de Ferramentas — Workflow de Proposta

Princípio: o agente opera com o mínimo de superfície necessária. Cada ferramenta liberada é uma decisão deliberada, não um padrão.

---

## Ferramentas PERMITIDAS

### Leitura de arquivos (`Read`)
- **Escopo:** qualquer arquivo em `specs/`, `.agent/`, `scripts/`
- **Por quê:** o agente precisa ler a spec do cliente, as políticas e o conhecimento base antes de redigir.
- **Restrição:** não pode ler arquivos fora deste repositório ou em paths absolutos externos.

### Escrita de arquivos (`Write`, `Edit`)
- **Escopo:** apenas dentro de `specs/<nome-do-cliente>/` e `output/propostas/`
- **Por quê:** o agente produz rascunhos e a proposta final — isso requer escrita.
- **Restrição:** proibido sobrescrever arquivos que não foram criados nesta sessão sem confirmação explícita do usuário.

### Execução de scripts (`Bash`)
- **Escopo:** exclusivamente `bash scripts/dod-check.sh <caminho-da-proposta>`
- **Por quê:** o DoD é a única etapa de validação que requer execução de shell.
- **Restrição:** nenhum outro comando bash é permitido. Qualquer outro uso requer aprovação.

### Busca de contexto (`Grep`, `Find`)
- **Escopo:** apenas dentro deste repositório
- **Por quê:** localizar seções existentes, verificar se placeholder foi removido, checar consistência.
- **Restrição:** não pode ser usado para minerar dados de outros clientes.

---

## Ferramentas PROIBIDAS neste workflow

| Ferramenta | Razão da Proibição |
|---|---|
| `WebSearch` / `WebFetch` | Informações externas não auditadas podem contaminar a proposta com dados incorretos ou de concorrentes |
| `mcp__claude_ai_Gmail__*` | O agente não envia comunicações — isso é responsabilidade humana |
| `mcp__claude_ai_Google_Calendar__*` | Agendamentos requerem confirmação humana; o agente não compromete agenda |
| `mcp__claude_ai_Google_Drive__*` | Acesso ao Drive pode expor dados de outros clientes |
| `TaskCreate` / `TaskUpdate` | Gerenciamento de tarefas não faz parte do escopo de proposta |
| `Bash` (uso geral) | Superfície de execução irrestrita — somente dod-check.sh é autorizado |
| Qualquer ferramenta MCP não listada acima | Princípio de lista branca: se não está liberado, está proibido |

---

## Princípio de Interface Curada

Este arquivo representa o **contrato de ferramentas** deste workflow. A curadoria protege três valores:

1. **Confinamento:** o agente não pode vazar para sistemas externos sem aprovação.
2. **Auditabilidade:** qualquer ação tomada usa uma das ferramentas desta lista — portanto é rastreável.
3. **Mínimo privilégio:** o agente tem acesso apenas ao que precisa para a tarefa atual.

Revisar este arquivo a cada nova versão da SKILL (`gerar-proposta/SKILL.md`).
