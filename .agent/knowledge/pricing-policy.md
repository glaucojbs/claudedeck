# Política de Precificação — Apex Consultoria

Versão: 1.2 | Vigência: 2026-01-01 | Aprovado por: Diretoria Comercial

> **Fonte de verdade para validação automática:** `.agent/policy-config.json`
> Os valores numéricos abaixo (faixas, limites, SLAs) são lidos de `policy-config.json`
> pelo `scripts/dod-check.sh`. Ao alterar qualquer valor neste documento, atualize
> o JSON correspondente para manter a validação sincronizada.

---

## Faixas de Investimento por Tipo de Engajamento

### Diagnóstico
| Porte do Cliente | Faixa | Duração Típica |
|---|---|---|
| Pequeno (< 50 funcionários) | R$ 5.000 – R$ 12.000 | 2–3 semanas |
| Médio (50–300 funcionários) | R$ 12.000 – R$ 25.000 | 3–5 semanas |
| Grande (> 300 funcionários) | R$ 25.000 – R$ 50.000 | 5–8 semanas |

### Implementação
| Complexidade | Faixa | Duração Típica |
|---|---|---|
| Baixa (processo único, equipe ≤ 5) | R$ 20.000 – R$ 60.000 | 4–8 semanas |
| Média (2–4 processos, equipe ≤ 20) | R$ 60.000 – R$ 120.000 | 8–16 semanas |
| Alta (> 4 processos ou multissite) | R$ 120.000 – R$ 150.000 | 16–24 semanas |

> **Limite autônomo:** o agente pode propor valores até R$ 150.000 sem aprovação.
> Acima deste valor: inserir `[APROVAÇÃO NECESSÁRIA — Valor acima do limite autônomo]`.

### Sustentação Mensal (pós-implementação)
| Nível de Serviço | Faixa Mensal |
|---|---|
| Básico (monitoramento + relatório mensal) | R$ 3.000 – R$ 5.000 |
| Padrão (+ suporte reativo 4h) | R$ 5.000 – R$ 8.000 |
| Avançado (+ SLA customizado) | Somente com aprovação — ver abaixo |

---

## Descontos

| Situação | Desconto Permitido | Requer Aprovação? |
|---|---|---|
| Pagamento antecipado (100% na assinatura) | Até 5% | Não |
| Projeto de longa duração (> 6 meses) | Até 8% | Não |
| Cliente recorrente (≥ 2 projetos anteriores) | Até 10% | Não |
| Qualquer outro caso | Qualquer valor | **Sim — inserir flag** |

Flag obrigatória: `[APROVAÇÃO NECESSÁRIA — Desconto fora da política padrão: X%]`

---

## SLAs Padrão (Sustentação)

| Severidade | Tempo de Primeira Resposta | Tempo de Resolução |
|---|---|---|
| Crítica (sistema parado) | 2 horas | 8 horas úteis |
| Alta (impacto significativo) | 4 horas | 2 dias úteis |
| Média (workaround disponível) | 1 dia útil | 5 dias úteis |
| Baixa (melhoria / dúvida) | 2 dias úteis | 15 dias úteis |

**SLA customizado** (ex.: 1h para todos os níveis, 24×7): requer aprovação da diretoria.
Flag obrigatória: `[APROVAÇÃO NECESSÁRIA — SLA fora do padrão: descrever desvio]`

---

## Itens de Custo Adicional (nunca inclusos no valor base)

- Viagens fora da região metropolitana (cobradas a custo + 10%)
- Licenças de software de terceiros
- Treinamentos para mais de 20 pessoas no mesmo módulo
- Tradução de documentos para idioma estrangeiro

Estes itens devem ser listados explicitamente em **Premissas e Exclusões** da proposta.

---

## Tabela de Validação Automática (usada pelo dod-check.sh)

```
DIAGNOSTICO_MIN=5000
DIAGNOSTICO_MAX=50000
IMPLEMENTACAO_MIN=20000
IMPLEMENTACAO_MAX=150000
SUSTENTACAO_MIN=3000
SUSTENTACAO_MAX=8000
DESCONTO_MAX_SEM_APROVACAO=10
VALOR_LIMITE_AUTONOMO=150000
```
