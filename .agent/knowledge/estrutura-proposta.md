# Estrutura Obrigatória de Proposta Comercial

Toda proposta gerada pelo agente deve conter exatamente estas seções, nesta ordem. A ausência de qualquer seção bloqueia a aprovação pelo DoD.

---

## 1. Contexto e Problema

**O que deve conter:**
- Descrição do problema de negócio do cliente em linguagem do próprio cliente (não nossa).
- Impacto atual mensurável: custo, tempo perdido, risco, oportunidade não capturada.
- Razão pela qual o problema persiste (diagnóstico inicial).

**Critério de qualidade:** um executivo sem contexto deve entender o problema após ler este bloco.

---

## 2. Escopo do Projeto

**O que deve conter:**
- O que está dentro do escopo (lista explícita).
- O que está explicitamente fora do escopo (lista explícita — evita litígios futuros).
- Responsabilidades do cliente x responsabilidades da Apex.

**Proibido:** escopo vago como "melhorias gerais" ou "suporte conforme necessário".

---

## 3. Entregáveis

**O que deve conter:**
- Lista numerada de cada entregável com nome, descrição em uma frase e critério de aceite.
- Formato de entrega (documento, sistema, workshop, relatório).

**Critério de qualidade:** cada entregável deve ter critério de aceite binário (passou / não passou).

---

## 4. Metodologia e Abordagem

**O que deve conter:**
- As fases do projeto com descrição de cada uma.
- Método de trabalho (sprints, marcos, ritmo de reuniões).
- Como o cliente participa e o que precisa disponibilizar.

---

## 5. Prazo e Cronograma

**O que deve conter:**
- Data de início (ou condição de início: "após assinatura do contrato").
- Duração total em semanas ou dias úteis.
- Marcos principais com datas relativas (ex.: "Semana 2 — entrega do diagnóstico").
- SLA de resposta e resolução conforme pricing-policy.

**Proibido:** datas absolutas sem âncora (o cliente não sabe quando vai assinar).

---

## 6. Investimento

**O que deve conter:**
- Valor total ou tabela de fases com valores individuais.
- Forma de pagamento (ex.: 50% na assinatura, 50% na entrega final).
- O que está incluso e o que gera custo adicional (ex.: viagens, licenças de software).
- Validade da proposta (padrão: 30 dias corridos).

**Regra de pricing:** valores devem estar dentro das faixas de `.agent/knowledge/pricing-policy.md`. Qualquer desvio exige flag `[APROVAÇÃO NECESSÁRIA]`.

---

## 7. Premissas e Exclusões

**O que deve conter:**
- Premissas que foram assumidas e que, se falsas, invalidam prazo ou custo.
- Exclusões explícitas que o cliente pode esperar mas que não estão cobertas.

**Exemplo de premissa:** "Assumimos que o cliente tem acesso aos dados de vendas dos últimos 24 meses no formato .xlsx ou equivalente."

---

## 8. Próximos Passos

**O que deve conter:**
- Ação imediata do cliente (ex.: "Confirme o interesse por e-mail até [data]").
- Ação imediata da Apex (ex.: "Enviaremos o contrato em até 2 dias úteis após confirmação").
- Contato responsável na Apex com nome, e-mail e telefone.

---

## Checklist de Completude (usado pelo DoD)

```
[ ] 1. Contexto e Problema
[ ] 2. Escopo do Projeto
[ ] 3. Entregáveis
[ ] 4. Metodologia e Abordagem
[ ] 5. Prazo e Cronograma
[ ] 6. Investimento
[ ] 7. Premissas e Exclusões
[ ] 8. Próximos Passos
```
