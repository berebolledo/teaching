grd <- read.csv("registros_E10.5_grd2022.csv")
################################################################################  
# ACTIVIDAD 1: Realiza un barplot de la variable TIPO_INGRESO 
# BONUS: personaliza a tu gusto
################################################################################

ggplot(data = grd, aes(x = TIPO_INGRESO)) +
  geom_bar() +
  labs(x = "Tipo de ingreso",
       y = "Frecuencia absoluta",
       title = "Frecuencia del tipo de ingreso, GRD 2022")

################################################################################  
# ACTIVIDAD 2: Realiza un scatterplot de las variables EDAD y DIASHOSP 
# BONUS: Colorea usando el color "coral"
################################################################################

ggplot(data = grd, aes(x = EDAD, y = DIASHOSP)) +
  geom_point(color = "coral")


################################################################################  
# ACTIVIDAD 3: Realiza un boxplot de las variables EDAD y TIPO_INGRESO 
# BONUS: colorea por tipo de ingreso y usa el tema theme_classic()
################################################################################

ggplot(data = grd, aes(x = TIPO_INGRESO, y = EDAD, fill = TIPO_INGRESO)) +
  geom_boxplot() +
  theme_classic()

################################################################################  
# ACTIVIDAD 4: Realiza un histograma de la variable DIASHOSP
# BONUS: Incluye etiquetas de ejes personalizados
################################################################################ 

ggplot(data = grd, aes(x = DIASHOSP)) +
  geom_histogram() +
  labs(x = "Dias de hospitalizacion",
       y = "Frecuencia")
