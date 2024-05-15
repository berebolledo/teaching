library(readr)
library(openxlsx)
# DIAGNOSTICO 1-35 variables 54-88
# PROCEDIMIENTO 1-30 variables 89-118

grd_extract <- function(file, pat1, pat2, pat3, year){
  
    d <- read_delim(file, delim = "|", escape_double = FALSE, trim_ws = TRUE)
    filterbydiag <- apply(d[, 54:88], 1, FUN = function(x) as.logical(sum(grepl(pat1,x))))
    d <- d[filterbydiag,]
        
    d$proc35.0 <- apply(d[, 89:118], 1, FUN = function(x) as.logical(sum(grepl(pat2,x))))
    d$proc35.2 <- apply(d[, 89:118], 1, FUN = function(x) as.logical(sum(grepl(pat3,x))))
        
    d$FECHA_GRD <- rep(year, nrow(d))
    
    return(d)
}

pat1 <- "I35\\.0$|I35\\.2$|I06\\.0$|I06\\.2$"
pat2 <- "35\\.0$|35\\.0[01]|35\\.96"
pat3 <- "35\\.2[012]|35\\.2$"

grd22 <- grd_extract("GRD_PUBLICO_2022-v2.txt", pat1, pat2, pat3, 2022)
grd21 <- grd_extract("GRD_PUBLICO_2021.txt", pat1, pat2, pat3, 2021)
grd20 <- grd_extract("GRD_PUBLICO_2020.txt", pat1, pat2, pat3, 2020)
grd19 <- grd_extract("GRD_PUBLICO_2019.txt", pat1, pat2, pat3, 2019)

merge <- rbind(grd19, grd20, grd21, grd22)

merge <- grd22

merge$IR_29301_PESO <- gsub(",", ".", merge$IR_29301_PESO)
merge$IR_29301_PESO <- as.numeric(merge$IR_29301_PESO)

merge$EDAD <- as.Date(merge$FECHA_INGRESO) - as.Date(merge$FECHA_NACIMIENTO)
merge$EDAD <- as.numeric(merge$EDAD)/365
merge$EDAD <- round(merge$EDAD,0)

merge$DIASHOSP <- as.Date(merge$FECHAALTA) - as.Date(merge$FECHA_INGRESO)
merge$DIASHOSP <- as.numeric(merge$DIASHOSP)

output <- "20240513_I35_o_I06_olivia"
write.table(merge, paste0(output,".txt"), sep = "|", row.names = FALSE)
write.xlsx(merge, paste0(output,".xlsx"))

table(merge$FECHA_GRD)
table(merge$FECHA_GRD,merge$proc35.2 )

library(ggplot2)

df <- subset(merge, SEXO != 'DESCONOCIDO')

ggplot(df, aes(x = EDAD, fill = SEXO)) +
  geom_histogram(position = "dodge", binwidth = 5, alpha = 0.7) +
  labs(title = "Distribución de la Edad por Sexo",
       x = "Edad",
       y = "Frecuencia") +
  theme_minimal()
