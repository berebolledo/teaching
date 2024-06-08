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
#               ---------                                                      #
#             0 |   |   |
#    EXPOSURE   ---------                                                      #
#             1 |   |   |
    

#   Arrange data into a 2x2 matrix (ct, contingency table)
    ct <- xtabs(data = comorb)
    ct
    t(ct)
    ct <- t(ct)
    ct

#   Rename rows and columns
    colnames(ct) <- c("No", "Si")
    rownames(ct) <- c("No", "Si")
    ct

#   Add column and row totals for visualization only
    table.margins(ct)

#   Calculate expected counts
    expected(ct)

# RUN  TEST OF INDEPENDENCE ----------------------------------------------------

    tab2by2.test(x = ct, rev = 'neither', correction = TRUE)
    
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

# ODDS/RISK RATIO ---------------------------------------------------------------------

oddsratio(x = ct, rev = 'neither')
riskratio(x = ct, rev = 'neither')

