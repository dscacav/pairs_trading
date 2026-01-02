
# Libraries

library(tidyverse)
library(tseries)
library(quantmod)

# Getting the data

mySymbols <- c('GOOGL', 'TSLA', 'FB', 'AMZN', 'AAPL', 'MSFT', 'VOD',  'ADBE', 'NVDA', 'CRM',
               'EBAY', 'YNDX', 'TRIP', 'NFLX', 'DBX', 'ETSY', 'PYPL','EA', 'BIDU', 'TMUS',
               'SPLK', 'CTXS', 'OKTA', 'MDB', 'ZM', 'INTC', 'GT', 'SBUX', 'WIX', 'ZNGA')

myStocks <-lapply(mySymbols, function(x) {getSymbols(x, 
                                                     from = "2020-01-01", 
                                                     to = "2021-01-03",
                                                     periodicity = "daily",
                                                     auto.assign=FALSE)} )


names(myStocks)<-mySymbols


closePrices <- lapply(myStocks, Cl)
closePrices <- do.call(merge, closePrices)

names(closePrices)<-sub("\\.Close", "", names(closePrices))
head(closePrices)

# Analyzing

# train
train<-log(closePrices[1:220])

# test
test<-log(closePrices[221:252])

# get the correlation of each pair
left_side<-NULL
right_side<-NULL
correlation<-NULL
beta<-NULL
pvalue<-NULL

for (i in 1:length(mySymbols)) {
  for (j in 1:length(mySymbols)) {
    
    if (i>j) {
      left_side<-c(left_side, mySymbols[i])
      right_side<-c(right_side, mySymbols[j])
      correlation<-c(correlation, cor(train[,mySymbols[i]], train[,mySymbols[j]]))
      
      # linear regression withoout intercept
      m<-lm(train[,mySymbols[i]]~train[,mySymbols[j]]-1)
      beta<-c(beta, as.numeric(coef(m)[1]))
      
      # get the mispricings of the spread
      sprd<-residuals(m)
      
      # adf test
      pvalue<-c(pvalue, adf.test(sprd, alternative="stationary", k=0)$p.value)
      
    }
  }
  
}

df<-data.frame(left_side, right_side, correlation, beta, pvalue)

mypairs<-df%>%filter(pvalue<=0.05, correlation>0.95)%>%arrange(-correlation)




# Spread

myspread<-train[,"NFLX"]-0.7739680*train[,"AMZN"]
plot(myspread, main = "NFLX vs AMZN")

myspread<-test[,"NFLX"]-0.7739680*test[,"AMZN"]
plot(myspread, main = "NFLX vs AMZN")
