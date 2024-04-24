library(readr)

# DIAGNOSTICO 1-35 variables 54-88
# PROCEDIMIENTO 1-30 variables 89-118

grd_extract <- function(df, diag, proc, date){
  d <- read_delim(df, delim = "|", escape_double = FALSE, trim_ws = TRUE)
  
  getDiag <- apply(d[, 54:88], 1, FUN = function(x) as.logical(sum(grepl(diag,x))))
  dDiag <- d[getDiag,]
  
  getProc <- apply(dDiag[,89:118], 1, FUN = function(x) as.logical(sum(grepl(proc,x))))
  dfinal <- dDiag[getProc,]
  
  dfinal$fecha_grd <- rep(date, nrow(dfinal))
  
  return(dfinal)
}


pat1 <- "C32"
pat2 <- "30\\.[12349]|31\\.[129]"


grd22_C32_30_31 <- grd_extract("GRD_PUBLICO_2022-v2.txt", pat1, pat2, 2022)
grd21_C32_30_31 <- grd_extract("GRD_PUBLICO_2021.txt", pat1, pat2, 2021)
grd20_C32_30_31 <- grd_extract("GRD_PUBLICO_2020.txt", pat1, pat2, 2020)
grd19_C32_30_31 <- grd_extract("GRD_PUBLICO_2019.txt", pat1, pat2, 2019)

olivia <- rbind(grd19_C32_30_31, grd20_C32_30_31, grd21_C32_30_31, grd22_C32_30_31)
write.table(olivia, "olivia.grd.txt", sep = "|", row.names = FALSE)
