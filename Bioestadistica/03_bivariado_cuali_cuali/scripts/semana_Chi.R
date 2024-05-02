# R WORKSHOP 08 BIOSTATS DCIM 2023 UDD -----------------------------------------
# 
# ODDS RATIO, RISK RATIO, CORRELATION, CONCORDANCE
#
# ENVIRONMENT SET UP -----------------------------------------------------------

library(readr)
library(epitools)

# READ DATA --------------------------------------------------------------------

# Se estudio un grupo de 441 pacientes que ingresaron al 
# servicio de urgencia de una region durante el año 2014. 
# Al momento del ingreso se lleno  una  ficha  consignando  un  
# conjunto  de  variables  que  daban  cuenta  de  la 
# gravedad  del  paciente  y  se  les  hizo  seguimiento  
# hasta  los  30  dias  de  la hospitalizacion en la cual se 
# investigo la mortalidad del paciente.

    neumonia <- read_csv("input/NEUMONIA_SOBREVIDA.csv")
    comorb <- neumonia[, c("FALLECIDO", "COMORBIL")]
    colnames(comorb) <- c("FALLECIMIENTO", "COMORBILIDADES")

# PREPARE DATA -----------------------------------------------------------------
# Make sure the table has the following configuration
# 
#            OUTCOME/DISEASE
#               | 0 | 1 |
#               ---------                                                      
#             0 |   |   |
#    EXPOSURE   ---------                                                      
#             1 |   |   |
    

#   Disponga los datos de comorb en una matriz de 2x2 (ct = contingency table)
    ct <- xtabs(data = comorb)
    ct
#   Es necesario transponer los datos para que queden en el orden correcto
    t(ct) 
    ct <- t(ct)
    ct

#   Etiquete filas y columnas
    colnames(ct) <- c("No", "Si")
    rownames(ct) <- c("No", "Si")
    ct

#   Incluya los totales de fila y columna (solo para verlos)
    table.margins(ct)

#   Calcule los recuentos esperados para chequear supuestos
    expected(ct)

# TEST DE INDEPENDENCIA --------------------------------------------------------

    tab2by2.test(x = ct, rev = 'neither', correction = TRUE)

#   rev = 'neither' significa que no hay que revertir ni filas ni columnas para 
#                   adaptar la tabla al formato esperado
    
#   correction = TRUE significa que se incluye una correccion para tratar el
#                     el sesgo de tratar valores discretos como continuos
    
    
# INTERPRETATIONS --------------------------------------------------------------    
# A chi-square test of independence showed that there was 
# a significant association between death and comorbidities, 
# X2 (1, N = 441) = 8.9, p = 0.003, in patients who entered
# the ER with a diagnosis of pneumonia.

# Using Fisher's exact test we found a a statistically significant 
# association between death and comorbidities in patients who entered
# the ER with a diagnosis of pneumonia, p-value = 0.0006.

chisq.test(ct)
fisher.test(ct)

# ODDS/RISK RATIO --------------------------------------------------------------

oddsratio(x = ct, rev = 'neither')
riskratio(x = ct, rev = 'neither')

# GRD --------------------------------------------------------------------------

# Lectura de tabla
d <- read_delim("input/calculo_grd22.txt", delim = "|", escape_double = FALSE, trim_ws = TRUE)

# Selección de variables
covariables <- d[, c("SEXO", "TIPO_INGRESO")]

# Filtro para eliminar un nivel de la variable TIPO_INGRESO
filtro <- covariables$TIPO_INGRESO!="OBSTETRICA"
covariables <- covariables[filtro,]

# Creacion de tabla de contingencia (ct)
grd_ct <- xtabs(data = covariables)
grd_ct

# Esta vez no es necesario transponer ¿Por que?
# grd_ct <- t(grd_ct)
# grd_ct

# Incluir totales calcular valores esperados
table.margins(grd_ct)
expected(grd_ct)

#Finalmente, calcular el test de independencia
tab2by2.test(grd_ct, rev = 'neither', correction = TRUE)

chisq.test(grd_ct, correct = TRUE)$p.value
fisher.test(grd_ct)$p.value

