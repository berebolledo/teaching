if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
BiocManager::install("airway")

suppressPackageStartupMessages(library(DESeq2))
library(ggplot2)
library(airway)
data(airway)
airway$dex <- relevel(airway$dex, "untrt")

BiocManager::install("clusterprofiler")
BiocManager::install("org.hs.eg.db")