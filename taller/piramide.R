# SET UP -----------------------------------------------------------------------
# Verificar si ggplot2 está instalado; si no, instalarlo

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

library(ggplot2)


# LECTURA DE BASE DE DATOS -----------------------------------------------------

grd <- read.csv("registros_E10.5_grd2022.csv")

# Eliminacion de registros de sexo desconocido
grd <- subset(grd, SEXO != "DESCONOCIDO")

# Crear intervalos de cinco años
grd$GRUPO_EDAD <- cut(grd$EDAD, breaks = seq(0, 105, by = 5), right = FALSE, include.lowest = TRUE)

# Contar las frecuencias por grupo de edad y sexo

grd_freq <- data.frame(xtabs(~ GRUPO_EDAD + SEXO, data = grd, drop.unused.levels = TRUE))


# Eliminar celdas sin informacion
grd_freq <- grd_freq[complete.cases(grd_freq),]

# Crear el gráfico
ggplot(grd_freq) +
  geom_bar(aes(GRUPO_EDAD,Freq,group=SEXO,fill=SEXO),stat = "identity", subset(grd_freq, grd_freq$SEXO=="MUJER")) +
  geom_bar(aes(GRUPO_EDAD,-Freq,group=SEXO,fill=SEXO),stat = "identity", subset(grd_freq, grd_freq$SEXO=="HOMBRE")) +
  coord_flip() +
  labs(title = "Pirámide de Edad por Sexo",
       x = "Grupo de Edad",
       y = "Frecuencia") +
  theme_minimal() +
  scale_y_continuous(labels = abs) 
