# R WORKSHOP BIOSTATS DCIM 2024 UDD -----------------------------------------
#
# Bivariate analysis: ANOVA

# ENVIRONMENT SET UP -----------------------------------------------------------

library(readr)
library(ggplot2)
library(PMCMRplus)

# READ DATA --------------------------------------------------------------------

diet <- read_delim("input/diet.tsv", delim = "\t")
diet$gender <-  as.factor(diet$gender)
diet$Diet <- as.factor(diet$Diet)
diet$weightchange <- diet$weight6weeks - diet$pre.weight

# BEFORE YOU TRY ANOVA ---------------------------------------------------------
# Check:
#    I.   Data shape
#    II.  Independence
#    III. Normality
#    IV.  Homoscedasticity
#    V.   Random sampling

#    I. Descriptive statistics

summary(diet)

ggplot(data = diet, aes(x = Diet, y = weightchange, fill = Diet)) +
  geom_boxplot()


#    III. Normality

aggregate(x = diet$weightchange, by = list(diet$Diet), FUN = function(x) shapiro.test(x)$p.value )


#    IV. Homoscedasticity

bartlett.test(weightchange ~ Diet, data = diet)

# ANOVA ------------------------------------------------------------------------

# H0: mu(Diet1) = mu(Diet2) = mu(Diet3)
# Ha: At least one mu is different

anova <- aov(weightchange ~ Diet, data = diet)
summary(anova)

# Post hoc test
TukeyHSD(anova)
pairwise.t.test(diet$weightchange, diet$Diet, "bonferroni")

# Non-parametric option for ANOVA ----------------------------------------------

kruskal <- kruskal.test(weightchange ~ Diet, data = diet)
kruskal

# Post hoc test
kwAllPairsDunnTest(weightchange ~ Diet, data = diet, p.adjust.method = "bon")

################################################################################
# GRD
################################################################################

# Lectura de datos
grd <- read.csv("input/registros_E10.5_grd2022.csv")

# Reduccion de tabla a solo aquellos registros afiliados a FONASA
grd <- subset(grd, grepl("FONASA", grd$PREVISION,))

# Transformacion de la variable PREVISION en factor
grd$PREVISION <- as.factor(grd$PREVISION)

# Estadística descriptiva
aggregate(grd$EDAD, by = , FUN = summary)
ggplot(data = grd, aes(x = PREVISION, y = EDAD, fill = PREVISION)) +
  geom_boxplot()

# Test de normalidad
aggregate(x = grd$EDAD, by = list(grd$PREVISION), FUN = function(x) shapiro.test(x)$p.value )

# ANOVA no parametrica
kruskal <- kruskal.test(EDAD ~ PREVISION, data = grd)
kruskal

# Post hoc test
kwAllPairsDunnTest(EDAD ~ PREVISION, data = grd, p.adjust.method = "bonferroni")
