# Bivariate analysis: t-test

# ENVIRONMENT SET UP -----------------------------------------------------------

library(readr)

# READ DATA --------------------------------------------------------------------

# Los datos corresponden a la medicion de peso antes y despues de una
# intervencion de 6 semanas con  dietas 1, 2 o 3. Con las variables "pre.weight"
# y "weight6weeks" se puede calcular el cambio de peso. Ademas, con la variable
# "height" se pudiera calcular el IMC.

# Para ilustrar el t-test, nos enfocaremos en el cambio de peso entre hombres y
# mujeres, es decir, una variable cuanti y una variable cuali de dos categorias,
# sin considerar las diferentes dietas, por ahora.

# 01 Lectura de datos

    diet <- read_delim("input/diet.tsv", delim = "\t")

# 02 Las variables "gender" y "Diet" estan codificadas con numeros a pesar de
# ser categorias. Es necesario ajustar su tipo

    diet$gender <-  as.factor(diet$gender)
    diet$Diet <- as.factor(diet$Diet)

# 03 Calculo de la variable "weight.change" como la diferencia 
# entre antes y 6 semanas

    diet$weight.change <- diet$weight6weeks - diet$pre.weight

# ANTES DE INICIAR UN ANALISIS PARAMETRICO -------------------------------------
# Chequea:
#    I.   La forma de los datos
#    II.  Que cada medicion sea independiente de la otra
#    III. Normalidad
#    IV.  Homoscedasticidad
#    V.   Muestreo aleatorio

# I Forma de los datos (¿Son mas o menos simetricos?)
    
    boxplot(weight.change ~ gender, data = diet)

    # Dividir en dos minitablas por genero y calcular estadistica descriptivas
    women <- subset(diet, gender == 0)
    men <- subset(diet, gender == 1)
    
    summary(women)
    summary(men)
    
# II ¿Es cada medicion independiente de la otra? Si, por diseño

# III Test de normalidad
    
    shapiro.test(women$weight.change)
    shapiro.test(men$weight.change)
    
# IV Test de igualdad de varianzas (homocedasticidad)
    
    var.test(women$weight.change, men$weight.change)
    
# V ¿Fue el muestreo aleatorio? Si, por diseño
    
# TWO SAMPLE T-TEST ------------------------------------------------------------

    # Dado que se cumplen los criterios para realizar un test parametrico
    # de comparacion de medias en dos grupos independientes de varianzas iguales
    # procedemos:
    
    # H0: mu(women$weight.change) = men$weight.change
    # Ha: mu(women$weight.change) != men$weight.change
    
    t.test(x = women$weight.change, y = men$weight.change, 
           alternative = "two.sided", paired = FALSE, var.equal = TRUE)
    
# GRD ----

# Usando datos de grd
    
    grd <- read_delim("input/20240507_olivia.txt", delim = "|")
    
    # Descripcion de datos
    boxplot(DIASHOSP ~ SEXO, data = grd)
    
    mujeres <- subset(grd, SEXO == "MUJER")
    hombres <- subset(grd, SEXO == "HOMBRE")
    
    summary(mujeres$DIASHOSP)
    summary(hombres$DIASHOSP)
    
    # Test de normalidad
    shapiro.test(mujeres$DIASHOSP)
    shapiro.test(hombres$DIASHOSP)
    
    # En este caso, dado que la forma de los datos y el test de normalidad
    # indican desviacion extrema, se utilizara un test no parametrico
    
    #H0: mu(mujeres$DIASHOSP) =  mu(hombres$DIASHOSP)
    #Ha: mu(mujeres$DIASHOSP) != mu(hombres$DIASHOSP)
    
    wilcox.test(x = mujeres$DIASHOSP, y = hombres$DIASHOSP,
                alternative = "two.sided", paired = FALSE,
                conf.int = TRUE)
        
# MAYOR INFORMACION ----
    # Manual
    ?t.test
    ?wilcox.test
    
    # Recurso web
    browseURL("https://www.datacamp.com/tutorial/t-tests-r-tutorial")
    