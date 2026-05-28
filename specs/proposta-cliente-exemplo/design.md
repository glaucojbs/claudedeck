# Design — Cliente Exemplo Ltda

**Fase 2: Contrato de Requisitos**
Criado em: 2026-05-28 | Baseado em: draft.md | Status: Aprovado para execução

---

## Objetivo do Projeto

Reduzir o ciclo de fechamento de estoque de 8–12 dias para **no máximo 2 dias úteis**, eliminando as causas raiz de ruptura não identificada e dando visibilidade em tempo real para vendas.

---

## Escopo

### Dentro do escopo
- Redesenho do processo de entrada e baixa de estoque no Protheus existente
- Configuração de alertas automáticos de ruptura iminente (estoque < ponto de reorder)
- Dashboard de visibilidade de estoque para equipe de vendas (leitura apenas)
- Treinamento da equipe operacional (até 15 pessoas) no novo processo
- Documentação do processo (POP — Procedimento Operacional Padrão)
- Acompanhamento de 4 semanas pós-go-live (sustentação incluída)

### Fora do escopo
- Troca ou upgrade do ERP Protheus
- Integração com fornecedores externos ou EDI
- Treinamento para mais de 15 pessoas no mesmo módulo (custo adicional)
- Módulos de compras ou financeiro do Protheus
- Desenvolvimento de software customizado

---

## Critérios de Aceitação — Formato Given/When/Then

### GWT-01 — Ciclo de fechamento
```
GIVEN que o processo redesenhado está em produção há pelo menos 30 dias
WHEN o time de operações executa o fechamento mensal de estoque
THEN o processo completo deve ser concluído em no máximo 2 dias úteis
  AND a reconciliação manual por 3 funcionários dedicados deve ser eliminada
```

### GWT-02 — Alertas de ruptura
```
GIVEN que um item de estoque atinge ou fica abaixo do ponto de reorder configurado
WHEN o sistema processa a movimentação de saída
THEN um alerta deve ser gerado automaticamente em até 15 minutos
  AND o alerta deve chegar ao responsável de compras e ao supervisor de logística
  AND o alerta deve ser visível no dashboard de vendas
```

### GWT-03 — Visibilidade para vendas
```
GIVEN que um vendedor acessa o dashboard de estoque
WHEN ele busca um produto pelo código ou nome
THEN a posição atual de estoque deve ser exibida com delay máximo de 1 hora em relação ao ERP
  AND a posição não deve ser editável pelo usuário de vendas (somente leitura)
```

### GWT-04 — Confiabilidade dos dados
```
GIVEN que o novo processo está rodando por 60 dias
WHEN a Apex realiza auditoria de acuracidade de estoque
THEN a divergência entre estoque físico e sistêmico deve ser inferior a 2%
```

### GWT-05 — Operabilidade pelo negócio
```
GIVEN que a implementação foi concluída
WHEN o TI interno precisar fazer manutenção ou ajuste de configuração
THEN o processo deve ser documentado de forma que 1 profissional de TI consiga operar sem suporte externo
  AND o POP deve cobrir os 5 cenários de exceção mais frequentes identificados durante o projeto
```

---

## Responsabilidades

| Responsabilidade | Apex | Cliente |
|---|---|---|
| Redesenho do processo | Liderança | Validação e aprovação |
| Configuração do Protheus | Execução | Acesso ao ambiente e credenciais |
| Testes em homologação | Co-execução | Disponibilização do ambiente |
| Treinamento | Execução | Disponibilização da equipe |
| Go-live | Suporte | Decisão e execução |
| Documentação (POP) | Elaboração | Revisão e aprovação |

---

## Restrições Técnicas e de Negócio

1. Nenhuma janela de parada de produção superior a 2 horas consecutivas.
2. A solução deve rodar na infraestrutura existente do cliente (sem novos servidores).
3. Usuários de vendas não terão acesso de escrita ao ERP em nenhuma circunstância.
4. Dados de estoque não devem sair do ambiente do cliente (sem integrações com serviços externos).
