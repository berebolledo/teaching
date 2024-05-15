library(ggplot2)

file <- "GRD_PUBLICO_2022-v2.txt"

df <- read_delim(file, delim = "|", escape_double = FALSE, trim_ws = TRUE)
df <- subset(df, SEXO != "DESCONOCIDO")

df$IR_29301_PESO <- gsub(",", ".", df$IR_29301_PESO)
df$IR_29301_PESO <- as.numeric(df$IR_29301_PESO)

df$EDAD <- as.Date(df$FECHA_INGRESO) - as.Date(df$FECHA_NACIMIENTO)
df$EDAD <- as.numeric(df$EDAD)/365
df$EDAD <- round(df$EDAD,0)

df$DIASHOSP <- as.Date(df$FECHAALTA) - as.Date(df$FECHA_INGRESO)
df$DIASHOSP <- as.numeric(df$DIASHOSP)

# Crear intervalos de cinco años
df$GRUPO_EDAD <- cut(df$EDAD, breaks = seq(0, 105, by = 5), right = FALSE, include.lowest = TRUE)

# Contar las frecuencias por grupo de edad y sexo
library(dplyr)

df_freq <- df %>%
  group_by(GRUPO_EDAD, SEXO) %>%
  summarise(FRECUENCIA = n()) %>%
  ungroup()

# Separar por sexo
df_hombres <- df_freq %>% filter(SEXO == "HOMBRE")
df_mujeres <- df_freq %>% filter(SEXO == "MUJER")

# Hacer los valores negativos para los hombres
df_hombres$FRECUENCIA <- -df_hombres$FRECUENCIA

# Combinar los DataFrames
df_combined <- full_join(df_hombres, df_mujeres, by = "GRUPO_EDAD", suffix = c("_HOMBRES", "_MUJERES"))

# Rellenar NAs con 0
df_combined <- df_combined[complete.cases(df_combined),]

# Crear el gráfico
ggplot(df_combined) +
  geom_bar(aes(x = GRUPO_EDAD, y = FRECUENCIA_HOMBRES), stat = "identity", fill = "blue", alpha = 0.7) +
  geom_bar(aes(x = GRUPO_EDAD, y = FRECUENCIA_MUJERES), stat = "identity", fill = "red", alpha = 0.7) +
  coord_flip() +
  labs(title = "Pirámide de Edad por Sexo",
       x = "Grupo de Edad",
       y = "Frecuencia") +
  theme_minimal() +
  scale_y_continuous(labels = abs) 


