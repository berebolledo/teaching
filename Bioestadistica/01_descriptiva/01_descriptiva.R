# CARGAR BIBLIOTECAS CON FUNCIONES ESPECIFICAS ----

library(readr)      # Lector de datos
library(xlsx)       # Escritor de datos en formato Excel
library(epiDisplay) # Funciones epidemiologicas
library(ggplot2)    # Graficos
library(tidyverse)  # Manipulacion de tablas
library(gtsummary)  # Creacion de tablas resumen
library(pwr)        # Analisis de potencia y calculo de n para tests
library(summarytools)


# MANIPULACION DE DATOS ----

    # Lectura de tabla

    grd22 <- read_delim("grd22_10000.txt", delim = "|", 
                    escape_double = FALSE, 
                    trim_ws = TRUE)
    # Ver tabla
    View(grd22)
    
    # Arreglar columna IR_29301_PESO para que sea numerica
    grd22$IR_29301_PESO <- gsub(",", ".", grd22$IR_29301_PESO)
    grd22$IR_29301_PESO <- as.numeric(grd22$IR_29301_PESO)
    
    # Calcular edad como la diferencia de fecha de nacimiento e ingreso
    grd22$EDAD <- (as.Date(grd22$FECHA_INGRESO) - as.Date(grd22$FECHA_NACIMIENTO))/365
    grd22$EDAD <- as.numeric(grd22$EDAD)
    grd22$EDAD <- round(grd22$EDAD,1)
    
    # Calculo de dias de hospitalizacion
    grd22$DIASHOSP <- as.Date(grd22$FECHAALTA) - as.Date(grd22$FECHA_INGRESO)
    grd22$DIASHOSP <- as.numeric(grd22$DIASHOSP)
    
    # Ejemplo de seleccion de variables
    dat <- grd22 %>% select(SEXO, EDAD, ETNIA, TIPO_INGRESO, DIAGNOSTICO1, IR_29301_PESO, DIASHOSP)
    View(dat)
    
    # Ejemplo de filtrado por condicion
    dat %>% filter(TIPO_INGRESO == "URGENCIA")
    
    # Ejemplo: Solo las filas con CIE10 K35.XX
    dat %>% filter(grepl("K35\\.[0-9]*", grd22$DIAGNOSTICO1))
    
    # Selecciona, filtra y guarda en un nuevo archivo
    mydat <- dat %>% 
      select(SEXO, EDAD, ETNIA, TIPO_INGRESO, DIAGNOSTICO1,IR_29301_PESO, DIASHOSP) %>%
      filter(grepl("K35\\.[0-9]*", grd22$DIAGNOSTICO1))
    
    write.csv(mydat, "mydat.csv", row.names = FALSE)

    
# ESTADISTICA DESCRIPTIVA: Variable categórica ----

    dfSummary(mydat)
    
    # Contruye una tabla de frecuencias
    freq.table <- tab1(mydat$SEXO, graph = FALSE)
    
    # Revisa la tabla
    freq.table
    
    # Guarda la tabla en Excel
    write.xlsx(freq.table, "freq.table.xlsx")
    
    # Gráfico de barras para frecuencia absoluta
    
    # Grafico de barras basico
    ggplot(data = mydat, aes(x = SEXO)) +
      geom_bar()
    
    # Grafico de barras con opciones de estilo
    ggplot(data = mydat, aes(x = SEXO)) +
      geom_bar(fill = "steelblue") +
      labs(title = "Frecuencia Absoluta de la variable SEXO",
           x = "Sexo",
           y = "Frecuencia Absoluta")

    
# ESTADISTICA DESCRIPTIVA: Variable numérica ----
    
    # Ejemplo. Crea una tabla con las estimaciones
    
    tbl_summary(mydat, by = "SEXO", 
                type = list(IR_29301_PESO ~ 'continuous'),
                statistic = list(all_continuous() ~ "{mean} ({sd})" ))
    
    # Histogram simple
        ggplot(data = mydat, aes(x = EDAD)) + 
          geom_histogram()
    
    # Histograma con mas opciones de estilo
        ggplot(data = mydat, aes(x = EDAD, fill = SEXO)) + 
          geom_histogram(alpha = 0.5, bins = 30, color = "black") +
          labs(title = "", x = "", y = "") +
          annotate(geom= "text", x = 8, y = 40, label="")
    
    # Boxplot Simple
        ggplot(data = mydat, aes(x = EDAD)) + 
          geom_boxplot()
        
    #Boxplot con mas opciones de estilo
        ggplot(data = mydat, aes(x = EDAD, fill = SEXO)) + 
          geom_boxplot(outlier.shape = NA) +
          labs(title = "My title", x = "X label", y = "") +
          theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
          annotate(geom= "text", x = 2.75, y = -0.4, label="") 
    
    
# INTERVALO DE CONFIANZA -------------------------------------------------------
    
    ci(mydat$EDAD, alpha = 0.05)
    ci(mydat$EDAD, alpha = 0.01)
    
    freq.table    
    ci(mydat$SEXO == "MUJER" )    