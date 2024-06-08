
# Taller de R - Bioestadistica DCIM 2024
# Tema: Correlacion

# 01 Set up enviroment ----
library(readr)
library(ggplot2)

# 02 Load data ----
#Use the "Import Dataset" option

# 03 Plot two numeric variables in a scatterplot
ggplot(data = , aes(x = , y =  )) +
  geom_point() +
  labs(x = "", y = "")

# 04 Check normality
shapiro.test(x = )
shapiro.test(x = )

# 05 Run correlation test
cor.test(x = , y = , method = "")

# 06 Help
?cor.test
