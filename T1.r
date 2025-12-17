install.packages("e1071")
install.packages("randomForest")
install.packages("kernlab")
install.packages("caret")
library("caret") 
library(mlbench)
data(Satellite)

dados <- Satellite[, c(17, 18, 19, 20, 37)]
str(dados)
dados$classes <- as.factor(dados$classes)
semente<- set.seed(7)
indice <- createDataPartition(dados$classes, p = 0.80, list = FALSE)

treino <- dados[indice,] #indices gerados na base de treino
teste <- dados[-indice,] #tudo q nao tiver na lista de indices gerados

cat("---------treinar modelo base random forest----------\n")
rf <- train(classes~., data=treino, method="rf")
predicoes.rf<- predict(rf, teste) #compara os dados de teste com os dados preditor
resultadorf <- confusionMatrix(predicoes.rf,teste$classes)
print(resultadorf)
cat("---------treinar modelo base-svm ---------\n")
svm <- train(classes~., data=treino, method="svmRadial")
predicoes.svm <- predict(svm, teste)
resultadosvm <-confusionMatrix(predicoes.svm,teste$classes)
print(resultadosvm)

cat("---------treinar modelo base-rna ---------\n")
rna <- train(classes~., data=treino, method="nnet")
predicoes.rna <- predict(rna, teste)
resultadorna <-confusionMatrix(predicoes.rna,teste$classes)
print(resultadorna)

