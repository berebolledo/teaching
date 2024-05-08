library(readr)

# DIAGNOSTICO 1-35 variables 54-88
# PROCEDIMIENTO 1-30 variables 89-118

grd_extract <- function(file, diag, proc1, proc2, date){
  d <- read_delim(file, delim = "|", escape_double = FALSE, trim_ws = TRUE)
  
  getDiag <- apply(d[, 54:88], 1, FUN = function(x) as.logical(sum(grepl(diag,x))))
  dDiag <- d[getDiag,]
  
  getProc1 <- apply(dDiag[,89:118], 1, FUN = function(x) as.logical(sum(grepl(proc1,x))))
  dfProc1 <- dDiag[getProc1,]
  
  getProc2 <- apply(dfProc1[,89:118], 1, FUN = function(x) as.logical(sum(grepl(proc2,x))))
  dfinal <- dfProc1[getProc2,]
  
  dfinal$fecha_grd <- rep(date, nrow(dfinal))
  
  return(dfinal)
}


pat1 <- "I35"
pat2 <- "35\\.2|35\\.96|35\\.0$|35\\.01$"
pat3 <- "*"



grd22 <- grd_extract("GRD_PUBLICO_2022-v2.txt", pat1, pat2, pat3, 2022)
grd21 <- grd_extract("GRD_PUBLICO_2021.txt", pat1, pat2, pat3, 2021)
grd20 <- grd_extract("GRD_PUBLICO_2020.txt", pat1, pat2, pat3, 2020)
grd19 <- grd_extract("GRD_PUBLICO_2019.txt", pat1, pat2, pat3, 2019)

output <- "20240507_olivia.txt"
merge <- rbind(grd19, grd20, grd21, grd22)


merge$IR_29301_PESO <- gsub(",", ".", merge$IR_29301_PESO)
merge$IR_29301_PESO <- as.numeric(merge$IR_29301_PESO)

merge$EDAD <- as.Date(merge$FECHA_INGRESO) - as.Date(merge$FECHA_NACIMIENTO)
merge$EDAD <- as.numeric(merge$EDAD)/365
merge$EDAD <- round(merge$EDAD,0)

merge$DIASHOSP <- as.Date(merge$FECHAALTA) - as.Date(merge$FECHA_INGRESO)
merge$DIASHOSP <- as.numeric(merge$DIASHOSP)

write.table(merge, output, sep = "|", row.names = FALSE)
