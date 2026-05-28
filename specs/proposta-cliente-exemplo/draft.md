# Draft — Cliente Exemplo Ltda

**Fase 1: Brainstorm do Problema**
Criado em: 2026-05-28 | Status: Aprovado para design

---

## Contexto do Cliente

**Empresa:** Cliente Exemplo Ltda
**Setor:** Distribuição e logística (médio porte, ~120 funcionários)
**Contato principal:** Carlos Mendes, Diretor de Operações

---

## Problema Central

O processo de fechamento mensal de estoque leva entre 8 e 12 dias úteis. Durante esse período, a equipe de vendas opera às cegas — sem visibilidade de posição real de estoque — e frequentemente compromete produtos que não existem ou deixa de vender produtos disponíveis.

---

## Impacto Mensurável Atual

- Média de 23 pedidos cancelados por mês por ruptura de estoque não identificada a tempo → estimativa de R$ 180.000/ano em receita perdida.
- 3 funcionários dedicados exclusivamente ao processo de reconciliação manual durante os 8–12 dias → custo operacional estimado de R$ 85.000/ano.
- Multas contratuais por atraso de entrega: R$ 40.000 no último ano.
- **Total estimado de impacto:** ~R$ 305.000/ano.

---

## O que Já Foi Tentado

1. **Planilha central compartilhada (2023):** abandonada em 3 meses por conflitos de edição simultânea.
2. **Módulo de estoque do ERP atual (Protheus):** subutilizado — os dados estão lá, mas ninguém confia porque o processo de entrada não é disciplinado. O problema é de processo, não de sistema.
3. **Contratação de consultor pontual (2024):** fez um relatório, mas sem implementação. O relatório ficou na gaveta.

---

## Prazo Desejado pelo Cliente

Resultado visível em **no máximo 12 semanas**. Carlos precisa apresentar resultado para o conselho no Q3 2026.

---

## Restrições Conhecidas

- Orçamento aprovado internamente: **R$ 80.000** (pode subir até R$ 100.000 com justificativa para o CFO).
- Não pode paralisar as operações durante a implementação — equipe de logística não pode ficar offline.
- Time de TI interno muito enxuto (1 pessoa) — qualquer solução precisa ser operable pelo próprio negócio.

---

## Diagnóstico Inicial (Apex)

O problema não é tecnológico — é de **processo e disciplina de entrada de dados**. A solução provável é redesenho do processo de baixa de estoque com pontos de controle automatizados dentro do Protheus existente, treinamento da equipe e dashboard de visibilidade para vendas. Não envolve troca de sistema.

Isso encaixa no perfil de **Implementação de complexidade média** da pricing-policy.
