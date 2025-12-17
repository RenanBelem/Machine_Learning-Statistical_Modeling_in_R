# Aprendizado de Máquina e Modelagem Estatística em R
> Trabalho realizado para a disciplina: Linguagem R, no curso de Inteligência Artifical Aplicada da UFPR

## Visão Geral

Este projeto consiste em duas tarefas distintas de análise de dados utilizando R, focando em **Classificação** (Tarefa 1) e **Regressão** (Tarefa 2). O objetivo é comparar métodos estatísticos tradicionais com algoritmos de aprendizado de máquina (*machine learning*) utilizando a estrutura do pacote `caret`.

O projeto avalia o desempenho dos modelos utilizando métricas como Acurácia e Kappa para classificação, e R^2 (Coeficiente de Determinação) e S_{yx} (Erro Padrão da Estimativa) para regressão.

---

## 🛠 Pré-requisitos

Para executar estes scripts, são necessários os seguintes pacotes R. Os scripts utilizam o `caret` para o pipeline de treinamento e bibliotecas específicas para cada algoritmo.

```r
install.packages(c("caret", "e1071", "randomForest", "kernlab", "neuralnet", "mlbench"))

```

* **caret:** *Classification And REgression Training* (interface unificada).
* **e1071:** Funções diversas (necessário para SVM e dependências).
* **randomForest:** Implementação do algoritmo Random Forest (Florestas Aleatórias).
* **kernlab:** Aprendizado de máquina baseado em Kernel (utilizado para SVM).
* **neuralnet:** Treinamento de redes neurais (utilizado na Tarefa 2).
* **mlbench:** Problemas de *Benchmark* de Aprendizado de Máquina (fonte do conjunto de dados *Satellite*).

---

## 📂 Estrutura do Projeto

### 1. Tarefa 1: Classificação de Imagens de Satélite (`T1.r`)

Este script resolve um problema de classificação utilizando dados multiespectrais para identificar tipos de solo e cultivo.

* **Conjunto de Dados:** `Satellite` da biblioteca `mlbench`.
* **Variáveis Utilizadas:** `x.17`, `x.18`, `x.19`, `x.20` (bandas espectrais).
* **Alvo (Target):** `classes` (Fator com 6 níveis: solo vermelho, cultivo de algodão, solo cinza, solo cinza úmido, restolho de vegetação, solo cinza muito úmido).
* **Divisão dos Dados:** 80% Treino / 20% Teste utilizando `createDataPartition`.


#### Modelos Implementados:

1. **Random Forest (`rf`)**: Método de aprendizado *ensemble* (conjunto) utilizando árvores de decisão.
2. **Support Vector Machine (`svmRadial`)**: SVM com kernel de Função de Base Radial.
3. **Neural Network (`nnet`)**: Rede neural *feed-forward*.

#### 📊 Resultados da Tarefa 1

Com base nos logs de execução, os modelos tiveram o seguinte desempenho no conjunto de teste:

| Modelo | Acurácia | Kappa | Notas |
| --- | --- | --- | --- |
| **SVM (Radial)** | **0.8707** | **0.8399** | Melhor desempenho geral.
| **Random Forest** | **0.8419** | **0.8047** | Desempenho forte, ligeiramente abaixo do SVM.
| **Neural Network** | **0.7998** | **0.7510** | Exigiu iterações significativas para convergir.

> **Observação:** O modelo SVM apresentou a maior acurácia geral e estatística Kappa, sugerindo ser o classificador mais robusto para a distribuição específica destes dados espectrais.

---

### 2. Tarefa 2: Regressão de Volume Florestal (`T2.r`)

Este script resolve um problema de regressão para prever o volume de madeira com base em medidas das árvores.

* **Conjunto de Dados:** Externo (`Volumes.csv`).
* **Variáveis:** `DAP` (Diâmetro à Altura do Peito), `HT` (Altura Total).
* **Alvo (Target):** `VOL` (Volume).
* **Métricas Personalizadas:**
* **R^2:** Coeficiente de Determinação (Explica a variância).
* **S_{yx}:** Erro Padrão da Estimativa (Erro absoluto).
* **S_{yx}\%:** Erro Padrão em porcentagem relativo à média.



#### Modelos Implementados:

1. **Random Forest (`rf`)**: Ensemble de árvores de regressão.
2. **Support Vector Machine (`svmRadial`)**: Regressão baseada em kernel.
3. **Neural Network (`neuralnet`)**: Perceptron multicamadas para regressão.
4. **Modelo SPURR (Alométrico)**: Uma equação florestal não linear tradicional definida como VOL \approx b_0 + b_1 \cdot DAP^2 \cdot HT.

#### 📊 Resultados da Tarefa 2

Comparação de desempenho nos dados de teste:

| Modelo | R^2 (Maior é melhor) | S_{yx} (Menor é melhor) |
| --- | --- | --- |
| **Neural Network** | **0.8824** | **0.1295** |
| Random Forest | 0.8535 | 0.1445 |
| SVM (Radial) | 0.8484 | 0.1470 |
| SPURR (Alométrico) | 0.8356 | 0.1531 |

> **Observação:** A **Neural Network** (Rede Neural) superou tanto as alternativas de aprendizado de máquina quanto a equação tradicional SPURR, alcançando o maior R^2 e o menor erro (S_{yx}). O modelo tradicional SPURR serviu como base (baseline), mas obteve a menor precisão entre os métodos testados.

---

## 🚀 Como Executar

1. Garanta que você tenha uma conexão ativa com a internet (para baixar o CSV da Tarefa 2 e os pacotes).
2. Abra seu console R ou RStudio.
3. Defina seu diretório de trabalho para o local dos scripts.
4. Execute o comando `source` para a tarefa desejada:

```r
# Executar Tarefa 1 (Classificação)
source("T1.r")

# Executar Tarefa 2 (Regressão)
source("T2.r")

```

---

## 📝 Notas Técnicas

* **Reprodutibilidade:** Ambos os scripts utilizam `set.seed(7)` para garantir que a divisão dos dados e a inicialização dos modelos sejam reprodutíveis.
* **Pré-processamento:** A Tarefa 2 calcula explicitamente métricas de erro personalizadas manualmente dentro das funções do código (`calcular_r2`, `calcular_syx`, e `calcular_syx_percentual`) ao invés de depender apenas dos padrões do `caret`.
* **Convergência:** A rede neural na Tarefa 1 utilizou o método `nnet` (via caret) e exibiu logs extensos de iteração, indicando que exigiu muitas épocas para minimizar a função de erro em comparação com os outros modelos .
