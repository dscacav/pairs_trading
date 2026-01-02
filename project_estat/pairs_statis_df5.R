library(tidyverse)
library(tseries)
library(quantmod)

setwd("~/Insync/GoogleCass/Analytics/TCC/Code/project_estat")

rm(list = ls())
load("pairs.RData")

# Calcular distância euclidiana depois de normalizar
dist_eucl <- function(x, y, na.rm = TRUE) {
  return(sum(
    (((x- min(x)) /(max(x)-min(x))) -
       ((y- min(y)) /(max(y)-min(y))))^2))
}

# tempos analisados e linhas
t1 <- 250
t2 <- 125
t3 <- 50
linhas <- nrow(adjus_f)

# criando um df vazio
df <- data.frame(day=integer() , left_side=character(), right_side=character(),
                 correl_t1=double(), beta_t1=double(), interc_t1=double(), pvalue_t1=double())
df$day <- as.Date(df$day)

system.time(
  
  for (i in 14473:18090) {
    
    day <- integer(0); class(day) <- "Date"
    left_side <- NULL; right_side <- NULL
    
    price_l <- NULL; price_r <- NULL; ratio <- NULL; euclidian <- NULL
    
    sprd_last_t1 <- NULL; sprd_mean_t1 <- NULL; sprd_sd_t1 <- NULL
    sprd_last_t2 <- NULL; sprd_mean_t2 <- NULL; sprd_sd_t2 <- NULL
    sprd_last_t3 <- NULL; sprd_mean_t3 <- NULL; sprd_sd_t3 <- NULL
    
    correl_t1 <- NULL; correl_t2 <- NULL; correl_t3 <- NULL
    
    beta_t1 <- NULL; interc_t1 <- NULL; pvalue_t1 <- NULL
    beta_t2 <- NULL; interc_t2 <- NULL; pvalue_t2 <- NULL
    beta_t3 <- NULL; interc_t3 <- NULL; pvalue_t3 <- NULL
    
    half_t1 <- NULL; half_t2 <- NULL; half_t3 <- NULL
    
    left <- grade_l[i]; right <- grade_r[i]
    #left <- "ITUB3"; right <- "ITUB4"
    
    vec_l <- as.vector(adjus_f[,left])
    vec_r <- as.vector(adjus_f[,right])
    ratio_vec <- vec_r/vec_l
    
    for (a in t1:linhas) {
    #for (a in t1:251) {
      b <- a - 249 # início (begin)
      
      vec_l_maior <- vec_l[b:a]
      vec_r_maior <- vec_r[b:a]
      
      price_l <- c(price_l, vec_l[a])
      price_r <- c(price_r, vec_r[a])
      ratio <- c(ratio, ratio_vec[a])
      
      euclidian <- c(euclidian, dist_eucl(vec_l_maior, vec_r_maior))
      
      # salvando o índice
      day <- c(day, data[a]) # índice
      left_side <- c(left_side, left)
      right_side <- c(right_side, right)
      
      # correlação
      correl_t1 <- c(correl_t1, cor(vec_l_maior, vec_r_maior))
      correl_t2 <- c(correl_t2, cor(tail(vec_l_maior, t2), tail(vec_r_maior, t2)))
      correl_t3 <- c(correl_t3, cor(tail(vec_l_maior, t3), tail(vec_r_maior, t3)))
      
      # regressão linear com intercepto
      m_t1 <- lm( vec_l_maior ~ vec_r_maior)
      interc_t1 <- c(interc_t1, as.numeric(coef(m_t1)[1]))
      beta_t1 <- c(beta_t1, as.numeric(coef(m_t1)[2]))
      
      # regressão linear com intercepto
      m_t2 <- lm( tail(vec_l_maior, t2) ~ tail(vec_r_maior, t2))
      interc_t2 <- c(interc_t2, as.numeric(coef(m_t2)[1]))
      beta_t2 <- c(beta_t2, as.numeric(coef(m_t2)[2]))
      
      # regressão linear com intercepto
      m_t3 <- lm( tail(vec_l_maior, t3) ~ tail(vec_r_maior, t3))
      interc_t3 <- c(interc_t3, as.numeric(coef(m_t3)[1]))
      beta_t3 <- c(beta_t3, as.numeric(coef(m_t3)[2]))
      
      # salvando o spread (resíduo)
      sprd_t1 <- residuals(m_t1)
      sprd_last_t1 <- c(sprd_last_t1, sprd_t1[t1])
      sprd_mean_t1 <- c(sprd_mean_t1, mean(sprd_t1))
      sprd_sd_t1 <- c(sprd_sd_t1, sd(sprd_t1))
      pvalue_t1 <- c(pvalue_t1, adf.test(sprd_t1, alternative = "stationary", k = 0)$p.value)
      
      # salvando o spread (resíduo)
      sprd_t2 <- residuals(m_t2)
      sprd_last_t2 <- c(sprd_last_t2, sprd_t2[t2])
      sprd_mean_t2 <- c(sprd_mean_t2, mean(sprd_t2))
      sprd_sd_t2 <- c(sprd_sd_t2, sd(sprd_t2))
      pvalue_t2 <- c(pvalue_t2, adf.test(sprd_t2, alternative = "stationary", k = 0)$p.value)
      
      # salvando o spread (resíduo)
      sprd_t3 <- residuals(m_t3)
      sprd_last_t3 <- c(sprd_last_t3, sprd_t3[t3])
      sprd_mean_t3 <- c(sprd_mean_t3, mean(sprd_t3))
      sprd_sd_t3 <- c(sprd_sd_t3, sd(sprd_t3))
      pvalue_t3 <- c(pvalue_t3, adf.test(sprd_t3, alternative = "stationary", k = 0)$p.value)
      
      ###### Meia Vida
      lr_t1 <- lm(diff(sprd_t1) ~ sprd_t1[-1])
      lambda_t1 = -log(1+summary(lr_t1)$coefficients[2])
      half_t1 <- c(half_t1, 2/-log(1+lambda_t1))
      
      ###### Meia Vida
      lr_t2 <- lm(diff(sprd_t2) ~ sprd_t2[-1])
      lambda_t2 = -log(1+summary(lr_t2)$coefficients[2])
      half_t2 <- c(half_t2, 2/-log(1+lambda_t2))
      
      ###### Meia Vida
      lr_t3 <- lm(diff(sprd_t3) ~ sprd_t3[-1])
      lambda_t3 = -log(1+summary(lr_t3)$coefficients[2])
      half_t3 <- c(half_t3, 2/-log(1+lambda_t3))
      
      
    }
    df <- rbind(df,data.frame(day, left_side, right_side, price_l, price_r, ratio,euclidian,
                            correl_t1, correl_t2, correl_t3,
                            beta_t1, interc_t1, pvalue_t1, half_t1, sprd_last_t1, sprd_mean_t1, sprd_sd_t1,
                            beta_t2, interc_t2, pvalue_t2, half_t2, sprd_last_t2, sprd_mean_t2, sprd_sd_t2,
                            beta_t3, interc_t3, pvalue_t3, half_t3, sprd_last_t3, sprd_mean_t3, sprd_sd_t3))
  }
)

save(df, file = "df5.RData")




