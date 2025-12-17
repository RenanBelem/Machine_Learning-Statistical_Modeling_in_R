install.packages("e1071")
install.packages("randomForest")
install.packages("neuralnet")
install.packages("kernlab")
install.packages("caret")
library("caret") 


# Calcular R² para cada modelo
calcular_r2 <- function(y_real, y_pred) {
  ss_res <- sum((y_real - y_pred)^2)  # Soma dos quadrados dos resíduos
  ss_tot <- sum((y_real - mean(y_real))^2)  # Soma total dos quadrados
  r2 <- 1 - (ss_res / ss_tot)
  return(r2)
}

# Calcular Erro Padrão da Estimativa (Syx)
calcular_syx <- function(y_real, y_pred) {
  n <- length(y_real)  # Número de observações
  p <- 1  # Número de variáveis preditoras
  syx <- sqrt(sum((y_real - y_pred)^2) / (n - p - 1))
  return(syx)
}

calcular_syx_percentual <- function(syx, y_real) {
  syx_percentual <- (syx / mean(y_real)) * 100
  return(syx_percentual)
}

dados <- read.csv2("http://www.razer.net.br/datasets/Volumes.csv", header = TRUE, sep = ";", fill = TRUE)
#print(head(dados))
dados <- dados[, -c(1)]
print(summary(dados))

semente<- set.seed(7)
indice <- createDataPartition(dados$VOL, p = 0.80, list = FALSE)
treino <- dados[indice,] #indices gerados na base de treino
teste <- dados[-indice,] #tudo q nao tiver na lista de indices gerados

cat("---------treinar modelo base random forest----------\n")
rf <- train(VOL~., data=treino, method="rf")
predicoes.rf<- predict(rf, teste) #compara os dados de teste com os dados preditor



cat("---------treinar modelo base-svm ---------\n")
svm <- train(VOL~., data=treino, method="svmRadial")
predicoes.svm <- predict(svm, teste)


cat("---------treinar modelo neuralnet ---------\n")
rn <- train(VOL~., data=treino, method="neuralnet")
predicoes.rn <- predict(rn, teste)

cat("---------treinar modelo SPURR ---------\n")
alom <- nls(VOL ~ b0 + b1*DAP*DAP*HT, dados, 
start=list(b0=0.5, b1=0.5))
predicoes.alom <- predict(alom, teste)

r2_rf <- calcular_r2(as.numeric(teste$VOL), as.numeric(predicoes.rf))
r2_svm <- calcular_r2(as.numeric(teste$VOL), as.numeric(predicoes.svm))
r2_rn <- calcular_r2(as.numeric(teste$VOL), as.numeric(predicoes.rn))
r2_alom <- calcular_r2(as.numeric(teste$VOL), as.numeric(predicoes.alom))
cat("\n---------r2 Metrica---------\n")

cat("---------r2 rf ---------\n")
print(r2_rf)

cat("---------r2 svm ---------\n")
print(r2_svm)

cat("---------r2 rn ---------\n")
print(r2_rn)

cat("---------r2 alom ---------\n")
print(r2_alom)

syx_rf <- calcular_syx(as.numeric(teste$VOL), as.numeric(predicoes.rf))
syx_svm <- calcular_syx(as.numeric(teste$VOL), as.numeric(predicoes.svm))
syx_rn <- calcular_syx(as.numeric(teste$VOL), as.numeric(predicoes.rn))
syx_alom <- calcular_syx(as.numeric(teste$VOL), as.numeric(predicoes.alom))

cat("\n---------syx Metrica---------\n")
cat("---------syx rf ---------\n")
print(syx_rf)

cat("---------syx base-svm ---------\n")
print(syx_svm)

cat("---------syx rn ---------\n")
print(syx_rn)

cat("---------syx alom ---------\n")
print(syx_alom)



syx_rf_percentual <-calcular_syx_percentual(as.numeric(teste$VOL), as.numeric(predicoes.rf))
syx_svm_percentual <-calcular_syx_percentual(as.numeric(teste$VOL), as.numeric(predicoes.svm))
syx_rn_percentual <-calcular_syx_percentual(as.numeric(teste$VOL), as.numeric(predicoes.rn))
syx_alom_percentual <-calcular_syx_percentual(as.numeric(teste$VOL), as.numeric(predicoes.alom))

cat("\n---------syx perc Metrica---------\n")
cat("---------syx perc rf ---------\n")
print(syx_rf_percentual)

cat("---------syx perc base-svm ---------\n")
print(syx_svm_percentual)

cat("---------syx perc rn ---------\n")
print(syx_rn_percentual)

cat("---------syx perc alom ---------\n")
print(syx_alom_percentual)
