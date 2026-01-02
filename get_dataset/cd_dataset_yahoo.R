
# Script para baixar a lista completa e colocar em um 1 único arquivo

library(quantmod)
library(lubridate)
library(dplyr)
library(xlsx)

setwd("/Users/cassianoa.cavalcanti/Insync/GoogleCass/Analytics/TCC/Code")

rm(list=ls())

## Baixa todos os tickers
setwd("/Users/cassianoa.cavalcanti/Insync/GoogleCass/Analytics/TCC/Code")

simbolos = read.csv('ds_tickers.csv', sep = ";")  # Ler arquivo com lista de tickers para baixar
names(simbolos) = c("simbolo", "nome")

for (simbolo in simbolos$simbolo) {
  if (simbolo %in% ls()) {
    print(paste0(simbolo, ' já existe'))
  } else {try(getSymbols(simbolo, from="2018-01-01", to="2021-06-05"))}
}

rm(simbolos)

acoes = ls() 

lista_acoes <- lapply(acoes, function(x) if (class(get(x)) == "xts") get(x)) 
names(lista_acoes) = acoes

resultado = lapply(lista_acoes, function(w) { w <- w; w })

resultado = do.call("cbind", resultado)

write.zoo(resultado, "ds_stocks.csv", index.name = "Data")


