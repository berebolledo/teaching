# Ambiente de trabajo
library(ggplot2)
library(dplyr)

# Lectura de datos
file <- "GRD_PUBLICO_2019.txt"
d <- read_delim(file, delim = "|", escape_double = FALSE, trim_ws = TRUE)

# Eliminacion de registros de sexo desconocido
d <- subset(d, SEXO != "DESCONOCIDO")

# Ajuste del valor de peso grd
d$IR_29301_PESO <- gsub(",", ".", d$IR_29301_PESO)
d$IR_29301_PESO <- as.numeric(d$IR_29301_PESO)

# Creacion de la variable EDAD
d$EDAD <- as.Date(d$FECHA_INGRESO) - as.Date(d$FECHA_NACIMIENTO)
d$EDAD <- as.numeric(d$EDAD)/365
d$EDAD <- round(d$EDAD,0)

# Creacion de la variable DIAS DE HOSPITALIZACION
d$DIASHOSP <- as.Date(d$FECHAALTA) - as.Date(d$FECHA_INGRESO)
d$DIASHOSP <- as.numeric(d$DIASHOSP)

# Crear intervalos de cinco años
d$GRUPO_EDAD <- cut(d$EDAD, breaks = seq(0, 105, by = 5), right = FALSE, include.lowest = TRUE)

# Contar las frecuencias por grupo de edad y sexo
d_freq <- d %>%
  group_by(GRUPO_EDAD, SEXO) %>%
  summarise(FRECUENCIA = n()) %>%
  ungroup()

# Eliminar celdas sin informacion
d_freq <- d_freq[complete.cases(d_freq),]

# Crear el gráfico
ggplot(d_freq) +
  geom_bar(aes(GRUPO_EDAD,FRECUENCIA,group=SEXO,fill=SEXO),stat = "identity", subset(d_freq, d_freq$SEXO=="MUJER")) +
  geom_bar(aes(GRUPO_EDAD,-FRECUENCIA,group=SEXO,fill=SEXO),stat = "identity", subset(d_freq, d_freq$SEXO=="HOMBRE")) +
  coord_flip() +
  labs(title = "Pirámide de Edad por Sexo GRD 2019",
       x = "Grupo de Edad",
       y = "Frecuencia") +
  theme_minimal() +
  scale_y_continuous(labels = abs) 
