# Bivariate analysis: t-test, ANOVA

# ENVIRONMENT SET UP -----------------------------------------------------------

library(readr)
library(rempsyc)
library(flextable)
library(DataExplorer)
library(ggplot2)
library(vtable)
library(PMCMRplus)

# READ DATA --------------------------------------------------------------------

diet <- read_delim("input/diet.tsv", delim = "\t")
diet$gender <-  as.factor(diet$gender)
diet$Diet <- as.factor(diet$Diet)
diet$weightloss <- diet$weight6weeks - diet$pre.weight

# BEFORE YOU TRY ANOVA ---------------------------------------------------------
# Check:
#    I.   Data shape
#    II.  Independence
#    III. Normality
#    IV.  Homoscedasticity
#    V.   Random sampling

#    I. Descriptive statistics

st(diet, group = 'Diet',  group.long = TRUE)

plot_boxplot(
  data    = diet,
  by      = "Diet",
  ncol    = 2,
  title   = "Distribution of continuos variables",
  ggtheme = theme_bw(),
  theme_config = list(
    plot.title = element_text(size = 16, face = "italic"),
    strip.text = element_text(colour = "blue", size = 12, face = 3)
  )
)



#    III. Normality

getPvaluefromShapiro <- function(values){
  return(shapiro.test(values)$p.value)
}

aggregate(diet$weightloss, by = list(diet$Diet), FUN = getPvaluefromShapiro)


#    IV. Homoscedasticity

bartlett.test(weightloss ~ Diet, data = diet)

# ANOVA ------------------------------------------------------------------------

# H0: mu(Diet1) = mu(Diet2) = mu(Diet3)
# Ha: At least one mu is different

anova <- aov(weightloss ~ Diet, data = diet)
summary(anova)

# Post hoc test
TukeyHSD(anova)
plot(TukeyHSD(anova))
pairwise.t.test(diet$weightloss, diet$Diet, "bonferroni")

# Non-parametric option for ANOVA ----------------------------------------------

kruskal <- kruskal.test(weightloss ~ Diet, data = diet)
kruskal

# Post hoc test
kwAllPairsDunnTest(weightloss ~ Diet, data = diet, p.adjust.method = "bon")
