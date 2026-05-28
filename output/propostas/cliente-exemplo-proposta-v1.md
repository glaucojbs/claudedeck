---
cliente: Cliente Exemplo Ltda
tipo: Implementação
versão: 1.0
data: 2026-05-28
autor: Agente Apex (revisão humana pendente)
STATUS: RASCUNHO — Pendente revisão humana
---

# Proposta Comercial — Otimização do Processo de Controle de Estoque

**Para:** Carlos Mendes, Diretor de Operações — Cliente Exemplo Ltda
**De:** Apex Consultoria
**Data:** 28 de maio de 2026
**Validade:** 30 dias corridos a partir desta data

---

## 1. Contexto e Problema

A equipe de operações da Cliente Exemplo Ltda enfrenta um processo de fechamento mensal de estoque que consome entre 8 e 12 dias úteis. Durante esse intervalo, a área de vendas opera sem visibilidade real de posição de estoque, o que gera dois problemas simultâneos: comprometimento de produtos inexistentes e perda de vendas de produtos disponíveis.

A raiz do problema não é tecnológica. O ERP Protheus já possui o módulo de controle de estoque, mas os dados não são confiáveis porque o processo de entrada e baixa não é disciplinado. Duas tentativas anteriores de resolver o problema — uma planilha compartilhada e um relatório de consultoria pontual — não chegaram à causa raiz.

O impacto financeiro estimado é de aproximadamente R$ 305.000 por ano, entre pedidos cancelados por ruptura não identificada (R$ 180.000), custo operacional de reconciliação manual (R$ 85.000) e multas contratuais por atraso (R$ 40.000).

---

## 2. Escopo do Projeto

### Dentro do escopo

1. Diagnóstico detalhado do processo atual de entrada e baixa de estoque no Protheus
2. Redesenho do processo com pontos de controle que eliminam a reconciliação manual
3. Configuração de alertas automáticos de ruptura iminente (estoque abaixo do ponto de reorder)
4. Dashboard de visibilidade de estoque para a equipe de vendas (leitura apenas)
5. Treinamento da equipe operacional — até 15 pessoas — no novo processo
6. Elaboração do POP (Procedimento Operacional Padrão) cobrindo os 5 cenários de exceção mais frequentes
7. Acompanhamento de 4 semanas pós-go-live incluído no contrato

### Fora do escopo

- Troca, upgrade ou recontratação do ERP Protheus
- Integração com fornecedores externos ou EDI
- Módulos de compras, financeiro ou outros módulos do Protheus além do de estoque
- Desenvolvimento de software customizado de qualquer natureza
- Treinamento para mais de 15 pessoas no mesmo módulo (disponível como extensão com custo adicional)
- Infraestrutura de TI (servidores, rede, licenças de software)

### Responsabilidades

| Atividade | Apex | Cliente |
|---|---|---|
| Diagnóstico e redesenho do processo | Liderança | Participação e validação |
| Configuração do Protheus | Execução | Acesso ao ambiente e credenciais |
| Testes em homologação | Co-execução | Disponibilização do ambiente |
| Treinamento | Condução | Disponibilização da equipe |
| Go-live | Suporte | Decisão e autorização |
| Documentação (POP) | Elaboração | Revisão e aprovação formal |

---

## 3. Entregáveis

| # | Entregável | Descrição | Critério de Aceite |
|---|---|---|---|
| E1 | Diagnóstico do processo atual | Mapeamento AS-IS com identificação das causas raiz de divergência de estoque | Cliente aprova o mapeamento como representativo da realidade atual |
| E2 | Processo redesenhado (TO-BE) | Fluxo novo com pontos de controle, responsabilidades e regras de negócio | Cliente valida que o fluxo é operável pela equipe atual sem contratações |
| E3 | Configuração no Protheus | Alertas de ruptura ativos e dashboard de vendas funcionando em produção | Alertas disparam em até 15 minutos para itens abaixo do ponto de reorder; dashboard mostra posição com delay máximo de 1 hora |
| E4 | Treinamento concluído | Equipe operacional (até 15 pessoas) treinada no novo processo | 100% dos participantes aprovam na avaliação de conhecimento com nota ≥ 70% |
| E5 | POP aprovado | Procedimento Operacional Padrão cobrindo os 5 cenários de exceção mais frequentes | Aprovação formal assinada pelo Diretor de Operações |
| E6 | Relatório de sustentação (4 semanas) | Relatório quinzenal durante o pós-go-live com indicadores de acuracidade e ocorrências | Acuracidade de estoque ≥ 98% ao final das 4 semanas de acompanhamento |

---

## 4. Metodologia e Abordagem

O projeto segue quatro fases sequenciais, com marcos de validação ao final de cada uma. A decisão de avançar a cada fase é tomada em conjunto com o Diretor de Operações.

**Fase 1 — Diagnóstico (Semanas 1–3)**
Entrevistas com a equipe de operações e vendas, análise dos dados de divergência dos últimos 12 meses no Protheus, mapeamento do fluxo atual. Entrega: E1.

**Fase 2 — Redesenho e Configuração (Semanas 4–8)**
Co-criação do novo processo com a equipe do cliente, configuração dos alertas e dashboard em ambiente de homologação, testes com dados reais. Entregas: E2 e E3 em homologação.

**Fase 3 — Treinamento e Go-live (Semanas 9–11)**
Treinamento da equipe, go-live com suporte presencial da Apex na primeira semana de produção. Entregas: E3 em produção, E4 e E5.

**Fase 4 — Sustentação (Semanas 13–16)**
Acompanhamento pós-go-live, monitoramento de indicadores, suporte a ajustes. Entrega: E6.

**Ritmo de trabalho:** reunião semanal de alinhamento (30 minutos), relatório quinzenal de progresso. A Apex não requer dedicação exclusiva da equipe do cliente — estimamos 4 horas por semana do Diretor de Operações e 8 horas por semana de um analista de operações durante as fases 1 e 2.

---

## 5. Prazo e Cronograma

**Início:** até 5 dias úteis após a assinatura do contrato
**Duração total:** 16 semanas (12 semanas de projeto + 4 semanas de sustentação incluída)

| Marco | Semana | Entregável |
|---|---|---|
| Kickoff | Semana 1 | — |
| Diagnóstico concluído | Semana 3 | E1 |
| Processo redesenhado aprovado | Semana 6 | E2 |
| Homologação concluída | Semana 8 | E3 (homologação) |
| Treinamento concluído | Semana 10 | E4 |
| Go-live | Semana 11 | E3 (produção), E5 |
| Encerramento da sustentação | Semana 16 | E6 |

**SLA durante a sustentação (4 semanas pós-go-live):**

| Severidade | Primeira Resposta | Resolução |
|---|---|---|
| Crítica (processo parado) | 2 horas | 8 horas úteis |
| Alta (impacto significativo) | 4 horas | 2 dias úteis |
| Média (workaround disponível) | 1 dia útil | 5 dias úteis |

---

## 6. Investimento

**Valor total do projeto:** R$ 88.000

| Fase | Valor |
|---|---|
| Diagnóstico e Redesenho (Fases 1–2) | R$ 52.000 |
| Treinamento e Go-live (Fase 3) | R$ 24.000 |
| Sustentação 4 semanas (Fase 4) | R$ 12.000 |
| **Total** | **R$ 88.000** |

**Forma de pagamento:**
- 40% na assinatura do contrato: R$ 35.200
- 30% na aprovação do diagnóstico (E1): R$ 26.400
- 30% no go-live (E3 em produção): R$ 26.400

**O que está incluso:** todos os honorários profissionais da Apex, materiais de treinamento e documentação, e as 4 semanas de sustentação pós-go-live.

**Custos adicionais não inclusos:** eventuais deslocamentos fora da região metropolitana (cobrados a custo + 10%), licenças de software de terceiros (se necessárias — não antecipamos necessidade), treinamento para além de 15 pessoas no mesmo módulo.

**Validade desta proposta:** 30 dias corridos a partir de 28 de maio de 2026.

---

## 7. Premissas e Exclusões

**Premissas assumidas — se falsas, prazo e custo precisam ser renegociados:**

1. O cliente possui acesso ao ambiente Protheus com permissões para configurar alertas e relatórios no módulo de estoque.
2. Os dados de movimentação de estoque dos últimos 12 meses estão disponíveis no Protheus ou em formato exportável.
3. Existe um ambiente de homologação separado do ambiente de produção para testes (ou possibilidade de criar um).
4. O Diretor de Operações tem autoridade para aprovar o redesenho do processo sem necessidade de aprovação de comitê de maior prazo.
5. A equipe a ser treinada não ultrapassa 15 pessoas. Caso haja mais participantes, custo adicional de R$ 800 por pessoa adicional se aplica.

**Exclusões explícitas:**

- Qualquer trabalho fora do módulo de estoque do Protheus está excluído, mesmo que seja identificado como problema relacionado durante o projeto.
- A Apex não se responsabiliza por dados históricos incorretos já existentes no Protheus — o projeto trabalha com os dados a partir do go-live do novo processo.
- Suporte após as 4 semanas de sustentação incluída requer contratação de plano de sustentação mensal separado.

---

## 8. Próximos Passos

**Para o cliente:**
1. Confirmar interesse por e-mail para o contato abaixo até **27 de junho de 2026** (validade da proposta).
2. Agendar reunião de alinhamento final (30 minutos) para esclarecer eventuais dúvidas antes da assinatura.

**Para a Apex:**
1. Enviar contrato formal em até 2 dias úteis após confirmação de interesse.
2. Disponibilizar agenda para kickoff em até 5 dias úteis após a assinatura.

**Contato responsável na Apex:**
- **Nome:** Equipe Comercial Apex
- **E-mail:** comercial@apex-consultoria.com.br
- **Telefone:** (11) 3000-0000

---

*Esta proposta foi gerada pelo Agente Apex e está sujeita à revisão humana antes do envio ao cliente. O conteúdo é baseado nas informações coletadas na especificação do projeto e nas políticas vigentes da Apex Consultoria.*
