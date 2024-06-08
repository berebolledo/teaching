# R WORKSHOP 08 BIOSTATS DCIM 2023 UDD -----------------------------------------
# 
# CORRELATION, CONCORDANCE
#
# ENVIRONMENT SET UP -----------------------------------------------------------

library(readr)
library(ggplot2)

# READ DATA --------------------------------------------------------------------

    # Use import dataset. Adjust locale
    dataRN <- read_delim("input/PesoRN_IMC MADRE.csv", 
                     delim = ";", escape_double = FALSE, 
                     locale = locale(decimal_mark = ",", 
                                     grouping_mark = "."), trim_ws = TRUE)
    

# CORRELATION TESTS ------------------------------------------------------------

    # We will focus on the variables:
    # PesoRN
    # TallaRN
    
    # Assumptions
    # 1. Continuous or interval quantitative variable
    # 2. Linear relationship
    # 3. Normality
    # 4. Related pairs
    # 5. No outliers
    
    # https://www.statology.org/pearson-correlation-assumptions/
    # http://www.biostathandbook.com/linearregression.html


#   1. CONTINUOS? Yes

#   2. CHECK LINEAR RELATIONSHIP?
 
    ggplot(data = dataRN, aes(x = TallaRN, y = PesoRN)) +
       geom_point() +
       geom_smooth(method = lm, color = "blue")+
       labs(title = "Peso y talla de muestra de recién nacidos en Chile\nFuente: DEIS 2016", 
            x= "Talla (cm)", y = "Peso (g)") +
       theme_bw()

#   3. NORMAL DISTRIBUTION?

    shapiro.test(dataRN$PesoRN)  # Yes
    shapiro.test(dataRN$TallaRN) # No

#   4. RELATED PAIRS? Yes
#   5. OUTLIERS?
    
    # Check for the presence of outliers
    ggplot(data = dataRN, aes(x = TallaRN)) +
      geom_boxplot() +
      theme_bw()
    
    # Identify outliers
    outliers <- boxplot(dataRN$TallaRN, plot = F)$out
    outrows <- which(dataRN$TallaRN %in% outliers)
    
    # Remove outliers?
    cleandata <- dataRN[-outrows,]
    
    # Visualize clean data
    ggplot(data = cleandata, aes(x = TallaRN, y = PesoRN)) +
      geom_point() +
      geom_smooth(method = lm, color = "blue")+
      labs(title = "Peso y talla de muestra de recién nacidos en Chile\nFuente: DEIS 2016", 
           x= "Talla (cm)", y = "Peso (g)") +
      theme_bw()
    

#.   PERFORM CORRELATION TEST
      
     cor.test(x = cleandata$TallaRN, y = cleandata$PesoRN, method = 'pearson')
     cor.test(x = cleandata$TallaRN, y = cleandata$PesoRN, method = 'spearman')
    
# ______________________________________________________________________________    
#    CORRELATE IMC_MATERNO AND PesoRN  
     # 1. Check assumptions
     # 2. Perform test
# ______________________________________________________________________________



