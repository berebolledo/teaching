# R WORKSHOP 08 BIOSTATS DCIM 2023 UDD -----------------------------------------
# 
# CONCORDANCE/DISCORDANCE
#
# ENVIRONMENT SET UP -----------------------------------------------------------

library(readr)
library(vcd)

# READ DATA --------------------------------------------------------------------

    radio <- read_delim("input/test_de_kappa.csv", 
                    delim = ";", escape_double = FALSE, trim_ws = TRUE)

# PREPARE DATA -----------------------------------------------------------------

#   Arrange data into a 2x2 matrix (ct, contingency table)
    ct <- xtabs(data = radio[, c("Radiografia", "Pantalla")])
    ct
    colnames(ct) <- c("+", "-")
    rownames(ct) <- c("+", "-")
    ct

#   Add column and row totals for visualization only
    addmargins(ct)


# KAPPA (CONCORDANCE) ----------------------------------------------------------

    #      H0: kappa == 0 (rating are independent)
    #      Ha: kappa != 0
    
    Kappa(ct)
    
    # The kappa value is 0.57 (p=5.2*10e-6). Thus, we conclude that there was
    # good concordance between interpreting x-rays directly or remotely.
    
# MCNEMAR (DISCORDANCE) --------------------------------------------------------    

    #     H0: concordance
    #     Ha: discordance
    
    mcnemar.test(ct)
    

    # An exact McNemar's test determined that 
    # there was not a statistically significant difference in the proportion of 
    # pathology,regardless of the method used to evaluate it. p = 0.18.
    

