Ideias

#### Filter
PETR4.SA[which(index(PETR4.SA) == index(IBOV.SA))]
Tes <- PETR4.SA[-which(index(PETR4.SA) %in% index(IBOV.SA))]

### Subset xts
subset xts https://rdrr.io/cran/xts/man/subset.xts.html

#### Variação em relação ao primeiro valor
# usado no método de distância
teste <- Cl(get("PETR4.SA")[3500:4048])
teste2 <- as.data.frame(teste) %>% rownames_to_column(var = "date")
teste3 <- teste2 %>% select_if(is.numeric) %>%
  mutate_all(function(x) x/first(x))
merge(teste, zoo(teste3, order.by = teste2$date))
teste4 <- as.xts(teste3, order.by = as.POSIXct(teste2$date))

plot(teste4)

#### Beta
# 1o métodos
Beta = cov(ativo, mercado) / var(mercado)
cov(tail(PETR4.SAret, 500),tail(IBOV.SAret, 500)) / var(tail(IBOV.SAret, 500))
# 2o Método
lm(tail(PETR4.SAret, 500) ~ tail(IBOV.SAret, 500))$coef[2]

#### Volatilidade Anualizadas
library(TTR) # função runSD
realized.vol <- xts(apply(sp500ret,2,runSD,n=22), index(sp500ret))*sqrt(252)
plot(realized.vol["2000::2017"])

#### Hurst
library(pracma)
# Hurst exponent
hurst <- hurstexp(log(ratio_vec))

#### Pairs Trading por Distância
# calcular a diferença entre os preços normalizados e depois padronizar o spread
# acima ou abaixo de 2 dp, sinal de trade
dist_eucl <- function(x, y, na.rm = TRUE) {
  return(sum((x- min(x)) /(max(x)-min(x))-(y- min(y)) /(max(y)-min(y)))^2)
}

##### Combinações
expand.grid(c('ITUB3','ITUB4','VALE5'), c('ITUB3','ITUB4','VALE5')) # com repetição
t(combn(c('ITUB3','ITUB4','VALE5'),2)) # sem repetição