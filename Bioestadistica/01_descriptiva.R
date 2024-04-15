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

    grd22 <- read_delim("grd10000.txt", delim = "|", 
                    escape_double = FALSE, locale = locale(encoding = "UTF-16"), 
                    trim_ws = TRUE)
    # Ver tabla
    View(grd22)
    
    # Arreglar columna IR_29301_PESO para que sea numerica
    grd22$IR_29301_PESO <- as.numeric(gsub(",", ".", grd22$IR_29301_PESO))
    
    # Ejemplo de seleccion de variables
    grd22 %>% select(SEXO, ETNIA, TIPO_INGRESO, DIAGNOSTICO1, IR_29301_PESO)
    
    # Ejemplo de filtrado por condicion
    grd22 %>% filter(TIPO_INGRESO == "URGENCIA")
    
    # Ejemplo: Solo las filas con CIE10 K35.XX
    grd22 %>% filter(grepl("K35\\.[0-9]*", grd22$DIAGNOSTICO1))
    
    # Selecciona, filtra y guarda en un nuevo archivo
    mydat <- grd22 %>% 
      select(SEXO, ETNIA, TIPO_INGRESO, DIAGNOSTICO1,IR_29301_PESO) %>%
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

    ggplot(data = mydat, aes(x = factor(SEXO))) +
      geom_bar(fill = "steelblue") +
      labs(title = "Frecuencia Absoluta de la variable SEXO",
           x = "Sexo",
           y = "Frecuencia Absoluta")

    
# ESTADISTICA DESCRIPTIVA: Variable numérica ----
    
    # Ejemplo. Crea una tabla con las estimaciones
    
    tbl_summary(mydat, by = "SEXO", 
                type = list(IR_29301_PESO ~ 'continuous'),
                statistic = list(all_continuous() ~ "{mean} ({sd})" ))

    
# PLOTS ------------------------------------------------------------------------
    
    # Histogram        
    ggplot(data = mydat, aes(x = IR_29301_PESO, fill = SEXO)) + 
      geom_histogram(alpha = 0.5, bins = 30, color = "black") +
      scale_fill_manual(values = c("orange", "forestgreen")) +
      labs(title = "", 
           x = "", y = "") +
      annotate(geom= "text", x = 8, y = 175, label="")
    
    # Boxplot
    ggplot(data = mydat, aes(x = IR_29301_PESO, fill = SEXO)) + 
      geom_boxplot(outlier.shape = NA) +
      scale_fill_manual(values = c("orange", "forestgreen")) +
      labs(title = "My title", 
           x = "X label", y = "") +
      theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
      annotate(geom= "text", x = 2.75, y = -0.4, label="") +
      coord_cartesian(xlim=c(0.7, 0.9))
    
    
# INTERVALO DE CONFIANZA ----
    
    ci(mydat$IR_29301_PESO, alpha = 0.05)
    ci(mydat$IR_29301_PESO, alpha = 0.01)
    
    freq.table    
    ci(mydat$SEXO == "MUJER" )    


    
    