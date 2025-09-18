# Lighter Tracker 2.0


<center>

![Logo Lighter Tracker](https://github.com/murilomike/Lighter-Tracker-2.0/blob/main/Prototipos/sistema_usu%C3%A1rio.jpg)

</center>


**Prevendo Perdas de Isqueiros com Machine Learning e Visualizações no Power BI**

O **Lighter Tracker 2.0** é um aplicativo inovador que prevê quando você provavelmente perderá seu isqueiro (inspirado no meu próprio Bic laranja perdido!) usando um modelo de regressão logística (F1-Score 72%) e dashboards vibrantes no Power BI.  
Construído com **Python, Pandas, scikit-learn e Faker**, ele rastreia padrões de uso (10.000 usos, 200 perdas) para alertar usuários em cenários de alto risco, como bares ou eventos sociais.  

Da minha história pessoal de perder isqueiros em piqueniques a insights acionáveis para usuários e lojistas, este projeto mostra ciência de dados ponta a ponta: geração de dados sintéticos, modelagem em ML e visualizações interativas.

---
## LINKS

### [DASHBOARD NO POWERBI](https://app.powerbi.com/view?r=eyJrIjoiNDQyZjBlYTEtZDQzYS00NGVkLWI4NDgtZDkwOGY3NDFiOTg5IiwidCI6IjEwMmNkOTJhLTE3ZjctNDlmYi1hYzJlLTZhMzc0YWIzNzk3NiJ9)
### [MEU PORTFÓLIO](https://lightertracker-ypqxmlg.gamma.site/)
### [PROTÓTIPO DA APLICAÇÃO](https://spark-wise-habit.lovable.app/)
---

## 🔎 Background
Tudo começou com meu confiável Bic laranja. Usei-o cerca de 50 vezes — piqueniques, encontros sociais — mas um dia, emprestei a um amigo que esqueceu de devolver. **Puf, sumiu!**  

Isso me fez refletir: *por que perdemos isqueiros e será que dá para prever isso?* O **Lighter Tracker 2.0** nasceu para responder, transformando dados do dia a dia (onde você usa, quem perde) em um app inteligente que prevê a probabilidade de perda (ex.: "65% de chance de perder em um bar").  

Além de usuários, gera insights para:  
- **Lojistas:** 60% dos isqueiros são vendidos por distribuidores.  
- **Campanhas ambientais:** 37% das perdas são de jovens usuários.  

**Objetivo:** Criar um app que rastreie o uso de isqueiros e preveja perdas usando ML, com dashboards no Power BI para visualizar padrões como perdas sociais (30% dos casos).

---

## ✨ Features
- **Rastreamento de Uso:** Registra usos por contexto (Tabaco, Social, Incenso), local (Casa, Bar, Rua) e ambiente (Sozinho, Com amigos).  
- **Previsão de Perdas:** Modelo de regressão logística (F1-Score 72%) estima probabilidade de perda com base no perfil do usuário.  
- **Visualizações no Power BI:**  
  - Gráficos de barras: Usos/Perdas por gênero e fumantes.  
  - Pizza: 30% das perdas em contextos sociais.  
  - Linha: Evolução do uso de Jan-Set 2025.  
  - Mapas: Hotspots (bares em São Paulo = 35% das perdas).  
  - Tabelas segmentadas: Ex.: filtrando por "Rua" mostra idade/usos/perdas.  
- **Dados Sintéticos:** 10.000 usos, 200 perdas, 50 usuários — gerados com Faker.  
- **Visão do App:** Alertar usuários em cenários de risco ("Cuidado nesse bar!") e ajudar lojistas no estoque.  

---

## 🛠️ Tech Stack
- **Python 3.8+:** Linguagem principal.  
- **Pandas/Numpy:** Manipulação de dados.  
- **scikit-learn:** Modelo de regressão logística (F1-Score 72%, K-Fold 70%).  
- **Faker:** Dados sintéticos realistas.  
- **Power BI:** Dashboards interativos.  
- **Jupyter Notebook:** Desenvolvimento e prototipagem.  
- **Git/GitHub:** Controle de versão e compartilhamento.  

---

## 📂 Dataset
O dataset (**base_powerbi_apresentacao_limpa.csv**) é sintético, sem valores nulos, com ~200 registros simulando dados reais do app (Jan-Set 2025).  

**Exemplo de colunas:**
| Coluna        | Descrição                              | Exemplo        |
|---------------|----------------------------------------|----------------|
| id_usuario    | ID do usuário                          | 1              |
| genero        | Gênero (M/F)                           | M              |
| idade         | Idade (18-60)                          | 28             |
| fumante       | Sim/Não                                | Sim            |
| tipo_usuario  | Fumante/Avulso                         | Fumante        |
| data_registro | Data de uso/perda (Jan-Set 2025)       | 2025-03-15     |
| local         | Casa/Bar/Rua                           | Rua            |
| contexto_uso  | Tabaco/Social                          | Social         |
| total_usos    | Usos por usuário/isqueiro              | 45             |
| total_perdas  | Perdas por usuário/isqueiro            | 3              |
| evolucao_uso  | Incremento mensal de uso               | 8              |
| faixa_idade   | 18-25, 26-35, 36+                      | 26-35          |
| mes_ano       | Análise temporal                       | 2025-03        |

**Destaques:**
- Homens: 55% fumantes, 60% das perdas.  
- Rua: 2,5 perdas médias (vs. 1,0 em Casa).  
- 18-25 anos: 50% mais perdas.  
- Contextos sociais: 30% das perdas.  

---

## 🤖 Machine Learning Model
- **Algoritmo:** Regressão Logística (scikit-learn).  
- **Features:** idade, gênero, fumante, local, contexto_uso, total_usos, evolucao_uso (One-Hot Encoding).  
- **Target:** total_perdas (binário: 0 = não perdeu, 1 = perdeu).  

**Performance:**  
- F1-Score: 72%  
- Acurácia: 68%  
- K-Fold: 70% F1 médio  

**Use case:** prever probabilidade de perda (ex.: "65% de risco em um bar").  

Notebook: `lighter_tracker_ml.ipynb`.

---

## 📊 Power BI 
**Dashboards interativos** com o dataset `base_powerbi_apresentacao_limpa.csv`:  
- **Barras:** Usos/Perdas por gênero e fumantes.  
- **Pizza:** Perdas por tipo_usuario (Fumante vs. Avulso).  
- **Barras agrupadas:** Usos/Perdas por faixa_idade e local.  
- **Linha:** Evolução de total_usos (Jan-Set 2025).  
- **Tabela segmentada:** filtrando por local = Rua.  
- **Slicers:** local, mes_ano para filtros dinâmicos.  

---
![Logo Lighter Tracker](https://github.com/murilomike/Lighter-Tracker-2.0/blob/main/Dashboard_PowerBI.jpg)

