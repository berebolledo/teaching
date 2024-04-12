# R WORKSHOP 05 BIOSTATS DCIM 2023 UDD -----------------------------------------
#
# Sample size

# ENVIRONMENT SET UP -----------------------------------------------------------

library(samplingbook)   # Sample size for mean and proportion
library(pwr)            # Power analysis

# SAMPLE SIZE FOR POPULATION PROPORTION ----------------------------------------

#    P: Expected proportion
#    e: Precision, or half the CI
#    N: Population size or Inf
#    level: Confidence level

     sample.size.prop(P = 0.1, e = 0.02, N = 1000, level = 0.95)

# EXAMPLE
#   Un departamento local de salud quiere calcular la prevalencia de sujetos 
#   con reacciones positivas a la tuberculina entre los 450 menores de 5 años 
#   registrados (existentes) en su circunscripción. Se desea calcular cuántos 
#   de tales niños han de integrar una muestra simple aleatoria para que pueda 
#   estimarse dicha prevalencia con una precisión absoluta, expresada 
#   en porcentaje, entre el 3 y el 5% y un 95% de confianza si se cree, 
#   por estudios previos, que la tasa de prevalencia pudiera ser, 
#   aproximadamente, del 20%.

    P <- 0.2
    e <- 0.03
    N <- 450

    sample.size.prop(P = P, e = e, N = N, level = 0.95)
     
          
# SAMPLE SIZE FOR POPULATION MEAN ----------------------------------------------

#    S: Standard deviation
#    e: Precision, or half the CI
#    N: Population size or Inf
#    level: Confidence level

     sample.size.mean(S = 2, e = 1, N = 1000, level = 0.95)

# EXAMPLE     
#    En un área sanitaria, la distribución del peso al nacer de niños cuyas 
#    madres cumplen su período de gestación de 40 semanas es aproximadamente 
#    normal con una media de mu = 3.500 gramos y una desviación estándar de 
#    sigma = 430 gramos. Un investigador planea llevar a cabo un estudio con 
#    una muestra simple aleatoria de los próximos partos, a lo largo del año 
#    entrante, en un hospital de maternidad. Supongamos que el número esperado 
#    de partos fuera N=3.450. Se quieren, como es usual, estimar diversos 
#    parámetros (algunos de ellos en subconjuntos tales como el de las madres 
#    que fumaron durante el embarazo, o el de las mayores de 38 años), pero a 
#    los efectos de fijar el tamaño muestral, consideremos que se quiere estimar
#    el peso medio al nacer de los niños que llegan al término del embarazo 
#    asumiendo que la desviación estándar es la mencionada (430 gramos). 
#    Si el investigador desea que el error no supere los 50 gramos con una 
#    confianza del 95%, el tamaño de muestra requerido ascendería a 263 sujetos.
    
    sample.size.mean(S = 430, e = 50, N = 3450, level = 0.95)
    
# SAMPLE SIZE TO COMPARE TWO PROPORTIONS ---------------------------------------
    
#    h            : Effect size
#    n            : Sample size
#    sig.level.   : Type I error (alpha)
#    power        : (1 - Type II error)
#    alternative  : alternative hypothesis
#    p1           : proportion 1
#    p2           : proportion 2
        
     p1 <- 0.7    # Eficacia farmaco 1
     p2 <- 0.5    # Eficacia farmaco 2
     power = 0.8
     alt = "two.sided"
     
     h <- ES.h(p1, p2)
     pwr.2p.test(h = h, n = NULL, sig.level = 0.05, power = power, alternative = alt)
     
     
# SAMPLE SIZE TO COMPARE TWO MEANS ---------------------------------------------

#    d            : Cohen's Effect size
#    n            : Sample size
#    sig.level.   : Type I error (alpha)
#    power        : (1 - Type II error)
#    alternative  : alternative hypothesis
#    type         : one- two- or paired-samples

#.   Cohen’s d = (x1 – x2) / sqrt( (s1^2 + s2^2) / 2)
     
     # A value of 0.2 represents a small effect size.
     # A value of 0.5 represents a medium effect size.
     # A value of 0.8 represents a large effect size.
     
     # effect size of 0.5 means the value of the average person in group 1 
     # is 0.5 standard deviations above the average person in group 2
     
     
     d <- cohen.ES(test = "t", size = "large")
     d <- d$effect.size
     pwr.t.test(d = d, n = NULL, sig.level = 0.05, power = 0.8, alternative = "two.sided")
     
     
     # Ensayo clinico sobre presion
     # Diferencia de promedios a cuantificar    = 4 mm Hg
     # Desviacion estandar comun                = 15 mm Hg
     
     d <- 4/15
     pwr.t.test(d = d, n = NULL, sig.level = 0.05, power = 0.8, alternative = "two.sided")
     
     
?pwr