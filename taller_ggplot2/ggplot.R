# BIENVENIDA -------------------------------------------------------------------

# Taller: Visualizacion de datos con ggplot2
# Autor: Boris Rebolledo
# Afiliacion: Instituto de Ciencias e Innovacion en Medicina, UDD

# SET UP -----------------------------------------------------------------------

# Verificar si ggplot2 está instalado; si no, instalarlo

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
  }

# Activar paquete

library(ggplot2)

# LECTURA DE BASE DE DATOS -----------------------------------------------------

# Primero, setear working directory
# Luego, leer datos

grd <- read.csv("registros_E10.5_grd2022.csv")

# BARPLOT ----------------------------------------------------------------------

 # Bar plot minimo
  ggplot(data = grd, aes(x=SEXO)) +
    geom_bar() 

 # Bar plot con colores y legenda por defecto
  ggplot(data = grd, aes(x=SEXO, fill = SEXO)) +
    geom_bar()

 # Barplot con colores propios
  ggplot(data = grd, aes(x=SEXO, fill = SEXO)) +
    geom_bar() +
    scale_fill_manual(values = c("HOMBRE"="tomato", "MUJER"="cornflowerblue"))
  
 # Barplot con títulos
  ggplot(data = grd, aes(x=SEXO, fill = SEXO)) +
    geom_bar() +
    scale_fill_manual(values = c("HOMBRE"="tomato", "MUJER"="cornflowerblue")) +
    labs(title = "Frecuencia de sexo, registros E10.5, GRD 2022",
           x = "",y = "Frecuencia absoluta")

 # Barplot con titulo, pero sin leyenda 
  ggplot(data = grd, aes(x=SEXO, fill = SEXO)) +
    geom_bar() +
    scale_fill_manual(values = c("HOMBRE"="tomato", "MUJER"="cornflowerblue")) +
    labs(title = "Frecuencia de sexo, registros E10.5, GRD 2022",
         x = "", y = "Frecuencia absoluta") +
    theme(legend.position = "None")

 # Barplot con etiquetas rotadas
  ggplot(data = grd, aes(x=SEXO, fill = SEXO)) +
    geom_bar() +
    scale_fill_manual(values = c("HOMBRE"="tomato", "MUJER"="cornflowerblue")) +
    labs(title = "Frecuencia de sexo, registros E10.5, GRD 2022",
         x = "", y = "Frecuencia absoluta") +
    theme(legend.position = "None", 
      axis.text.x = element_text(angle = 45, hjust = 1))

  
################################################################################  
  # ACTIVIDAD 1: Realiza un barplot de la variable TIPO_INGRESO 
  # BONUS: personaliza las etiquetas de los ejes y titulo
################################################################################

# SCATTER PLOT -----------------------------------------------------------------

  # Scatter plot minimo
  ggplot(data = grd, aes(x=COMORB, y = DIASHOSP )) +
    geom_point()

   # Scatter plot con colores propios
  ggplot(data = grd, aes(x=COMORB, y = DIASHOSP )) +
    geom_point(color = "forestgreen" )

  # Scatter plot con colores y tamaño de punto
  ggplot(data = grd, aes(x=COMORB, y = DIASHOSP )) +
    geom_point(color = "forestgreen" , size = 2.5, alpha = 0.5)

  # Scatter plot completo
  ggplot(data = grd, aes(x=COMORB, y = DIASHOSP )) +
    geom_point(color = "forestgreen" , size = 2.5) +
    labs(title = "Relación entre comorbilidades y días de hospitalizacion, \nregistros E10.5, GRD, 2022",
         x = "Cantidad de diagnósticos", y = "Días de hospitalizacion") +
    theme_classic()

################################################################################  
  # ACTIVIDAD 2: Realiza un scatterplot de las variables EDAD y DIASHOSP 
  # BONUS: Colorea usando el color "coral"
################################################################################
  
# BOXPLOT ---------------------------------------------------------------------- 
  
  # Boxplot mínimo
  ggplot(data = grd, aes(x = SEXO, y = EDAD)) +
    geom_boxplot()

  # Boxplot sin leyenda y tema clasico
  ggplot(data = grd, aes(x = SEXO, y = EDAD, fill = SEXO)) +
    geom_boxplot() +
    theme_classic() +
    theme(legend.position = "None") 
  
  # Boxplot con puntos
  ggplot(data = grd, aes(x = SEXO, y = EDAD, fill = SEXO)) +
    geom_boxplot() +
    geom_jitter(size = 0.5, alpha = 0.5, width = 0.25) +
    theme_classic() +
    theme(legend.position = "None")
  
  # Boxplot completo
  ggplot(data = grd, aes(x = SEXO, y = EDAD, fill = SEXO)) +
    geom_boxplot() +
    geom_jitter(size = 0.5, alpha = 0.5, width = 0.25) +
    scale_fill_manual(values = c("HOMBRE"="tomato", "MUJER"="cornflowerblue")) +
    theme_classic() +
    theme(legend.position = "None") +
    labs(title = "Distribución de edad, registros E10.5, GRD, 2022")

################################################################################  
  # ACTIVIDAD 3: Realiza un boxplot de las variables EDAD y TIPO_INGRESO 
  # BONUS: colorea por tipo de ingreso
################################################################################
  
# HISTOGRAMA -------------------------------------------------------------------  
    
  # Histograma simple
  ggplot(data = grd, aes(x = EDAD)) +
    geom_histogram()

  # Histograma color
  ggplot(data = grd, aes(x = EDAD)) +
    geom_histogram(color = "orange", fill = "gold" )
  
  # Histograma tamaño de bin
  ggplot(data = grd, aes(x = EDAD)) +
    geom_histogram(binwidth = 5, color = "orange", fill = "gold" )
  
  # Histograma completo
  ggplot(data = grd, aes(x = EDAD)) +
    geom_histogram(aes(y=..density..),binwidth = 5, color = "orange", fill = "gold" ) +
    geom_density(color = "red", size = 1) +
    theme_classic() +
    labs(title = "Distribución de edad.\nRegistros 10.5, GRD 2022",
         x = "Edad",
         y = "Frecuencia")
  
################################################################################  
  # ACTIVIDAD 4: Realiza un histograma de la variable DIASHOSP
  # BONUS: Incluye etiquetas personalizadas
################################################################################  
  
# MULTIPLES GRAFICOS -----------------------------------------------------------

  # Scatter plots por variable
  ggplot(data = grd, aes(x=COMORB, y = DIASHOSP )) +
    geom_point(color = "forestgreen" , size = 2.5, alpha = 0.5) +
    labs(title = "Relación entre comorbilidades y días de hospitalizacion, \nregistros E10.5, GRD, 2022",
         x = "Cantidad de diagnósticos", y = "Días de hospitalizacion") +
    facet_wrap(~SEXO)

  # Scatter plots por variable
  ggplot(data = grd, aes(x=COMORB, y = DIASHOSP )) +
    geom_point(color = "forestgreen" , size = 2.5, alpha = 0.5) +
    labs(title = "Relación entre comorbilidades y días de hospitalizacion, \nregistros E10.5, GRD, 2022",
         x = "Cantidad de diagnósticos", y = "Días de hospitalizacion") +
    facet_grid(SEXO ~ NACIONALIDAD)

  