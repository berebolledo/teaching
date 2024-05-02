header <- read_delim("header", delim = "|", 
                     escape_double = FALSE, col_names = FALSE, 
                     trim_ws = TRUE)

d2019 <- read_delim("mateo2019", delim = "|", escape_double = FALSE, trim_ws = TRUE, col_names = F)
colnames(d2019) <- header[1,]
d2019$FECHA_GRD <- rep(2019, nrow(d2019))

d2020 <- read_delim("mateo2020", delim = "|", escape_double = FALSE, trim_ws = TRUE, col_names = F)
colnames(d2020) <- header[1,]
d2020$FECHA_GRD <- rep(2020, nrow(d2020))

d2021 <- read_delim("mateo2021", delim = "|", escape_double = FALSE, trim_ws = TRUE, col_names = F)
colnames(d2021) <- header[1,]
d2021$FECHA_GRD <- rep(2021, nrow(d2021))

d2022 <- read_delim("mateo2022", delim = "|", escape_double = FALSE, trim_ws = TRUE, col_names = F)
colnames(d2022) <- header[1,]
d2022$FECHA_GRD <- rep(2022, nrow(d2022))

mateo <- rbind(d2019,d2020,d2021,d2022)
write.table(mateo, "mateo-2-filtros.txt", sep = "|", row.names = FALSE)
