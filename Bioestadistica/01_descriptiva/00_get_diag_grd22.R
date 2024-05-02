setwd("/Users/boris/Desktop/bioestadistica")

diag <- "K80\\.0"
output <- "calculo_grd22.txt"

d <- read_delim("~/Desktop/bioestadistica/GRD_PUBLICO_2022-v2.txt", delim = "|", escape_double = FALSE, trim_ws = TRUE)

getDiag <- apply(d[, 54:88], 1, FUN = function(x) as.logical(sum(grepl(diag,x))))
dDiag <- d[getDiag,]

dDiag$IR_29301_PESO <- gsub(",", ".", dDiag$IR_29301_PESO)
dDiag$IR_29301_PESO <- as.numeric(dDiag$IR_29301_PESO)

dDiag$EDAD <- as.Date(dDiag$FECHA_INGRESO) - as.Date(dDiag$FECHA_NACIMIENTO)
dDiag$EDAD <- dDiag$EDAD/365
dDiag$EDAD <- as.numeric(dDiag$EDAD)
dDiag$EDAD <- round(dDiag$EDAD,1)

dDiag$DIASHOSP <- as.Date(dDiag$FECHAALTA) - as.Date(dDiag$FECHA_INGRESO)
dDiag$DIASHOSP <- as.numeric(dDiag$DIASHOSP)

write.table(dDiag, output, sep = "|", row.names = FALSE)
