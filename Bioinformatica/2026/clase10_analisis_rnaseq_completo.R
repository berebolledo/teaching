# =============================================================================
# Electivo de Bioinformática — Clase 10
# Análisis completo de una tabla de recuentos de RNA-seq en RStudio:
#   recuentos -> filtrado -> DESeq2 -> genes diferenciales -> enriquecimiento
#
# Datos: airway (Himes et al. 2014), células de músculo liso de vía aérea
#        tratadas (trt) o no (untrt) con dexametasona.
#
# Cómo usarlo:
#   1. Abran este archivo en RStudio.
#   2. Session > Set Working Directory > To Source File Location
#      (los resultados quedarán en una carpeta junto a este script).
#   3. Corran línea por línea con Ctrl+Enter (Cmd+Enter en Mac),
#      o todo de una vez con el botón "Source".
# =============================================================================

# -----------------------------------------------------------------------------
# 0. Instalar paquetes (solo la primera vez; luego pueden saltarse este bloque)
# -----------------------------------------------------------------------------
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!requireNamespace("ggplot2", quietly = TRUE))     install.packages("ggplot2")
for (p in c("DESeq2", "airway", "clusterProfiler", "org.Hs.eg.db")) {
  if (!requireNamespace(p, quietly = TRUE)) BiocManager::install(p, update = FALSE, ask = FALSE)
}

# -----------------------------------------------------------------------------
# 1. Parámetros (lo único que habría que cambiar para otro análisis)
# -----------------------------------------------------------------------------
dir_salida  <- "resultados_clase10"         # se crea dentro del directorio de trabajo
diseno      <- ~ cell + dex                 # bloque (línea celular) + tratamiento
contraste   <- c("dex", "trt", "untrt")     # tratadas vs. sin tratar
umbral_padj <- 0.05                         # significancia (FDR)
umbral_lfc  <- 1                            # |log2FC| > 1  (cambio de 2 veces)

# -----------------------------------------------------------------------------
# 2. Paquetes y carpeta de salida
# -----------------------------------------------------------------------------
suppressPackageStartupMessages({
  library(DESeq2)
  library(airway)
  library(ggplot2)
  library(org.Hs.eg.db)
  library(clusterProfiler)
})

dir.create(dir_salida, showWarnings = FALSE)
salida <- function(archivo) file.path(dir_salida, archivo)
cat("Los resultados se guardarán en:", normalizePath(dir_salida), "\n")

# -----------------------------------------------------------------------------
# 3. Cargar la tabla de recuentos y la información de las muestras
# -----------------------------------------------------------------------------
data(airway)
airway$dex <- relevel(airway$dex, "untrt")   # "sin tratar" = referencia

cat("Genes x muestras:", dim(airway), "\n")
print(colData(airway)[, c("cell", "dex")])

# Para usar SU PROPIA tabla (p. ej. salida de featureCounts) en vez de airway:
#   cts  <- as.matrix(read.csv("recuentos.csv", row.names = 1))
#   info <- read.csv("muestras.csv", row.names = 1)   # mismas muestras, mismo orden
#   dds  <- DESeqDataSetFromMatrix(cts, colData = info, design = diseno)

dds <- DESeqDataSet(airway, design = diseno)

# -----------------------------------------------------------------------------
# 4. Filtrar genes con muy pocos recuentos
#    (al menos 10 lecturas en al menos 4 muestras = el tamaño del grupo menor)
# -----------------------------------------------------------------------------
keep <- rowSums(counts(dds) >= 10) >= 4
dds  <- dds[keep, ]
cat("Genes que pasan el filtro:", sum(keep), "\n")

# -----------------------------------------------------------------------------
# 5. Exploración: PCA sobre datos transformados (vst)
# -----------------------------------------------------------------------------
vsd <- vst(dds, blind = TRUE)
pca <- plotPCA(vsd, intgroup = c("dex", "cell"), returnData = TRUE)
pv  <- round(attr(pca, "percentVar") * 100)

g_pca <- ggplot(pca, aes(PC1, PC2, color = dex, shape = cell)) +
  geom_point(size = 4) +
  labs(x = paste0("PC1 (", pv[1], "%)"), y = paste0("PC2 (", pv[2], "%)")) +
  theme_bw()
print(g_pca)                                            # se ve en el panel Plots
ggsave(salida("01_pca.pdf"), g_pca, width = 6, height = 4.5)

# -----------------------------------------------------------------------------
# 6. Expresión diferencial con DESeq2
#    DESeq() = size factors + dispersiones + modelo + prueba de Wald
# -----------------------------------------------------------------------------
dds <- DESeq(dds)
res <- results(dds, contrast = contraste, alpha = umbral_padj)
res$symbol <- rowData(dds)$gene_name
summary(res)

res_ord <- res[order(res$padj), ]
write.csv(as.data.frame(res_ord), salida("deseq2_resultados.csv"))

print(head(as.data.frame(res_ord)[, c("symbol", "baseMean", "log2FoldChange", "padj")], 10))
# Tip RStudio: View(as.data.frame(res_ord)) abre la tabla completa para ordenar/filtrar

# -----------------------------------------------------------------------------
# 7. Listas de genes: suben, bajan y universo (todos los genes probados)
# -----------------------------------------------------------------------------
universo <- rownames(res)[!is.na(res$padj)]
suben <- rownames(res)[which(res$padj < umbral_padj & res$log2FoldChange >  umbral_lfc)]
bajan <- rownames(res)[which(res$padj < umbral_padj & res$log2FoldChange < -umbral_lfc)]
cat("Suben:", length(suben), " | Bajan:", length(bajan),
    " | Universo:", length(universo), "\n")

# -----------------------------------------------------------------------------
# 8. Gráficos de expresión diferencial: MA y volcán
# -----------------------------------------------------------------------------
# Gráfico MA: cada punto es un gen.
#   eje x = expresión promedio (baseMean, en escala log)
#   eje y = cambio (log2FoldChange); azul = padj < umbral_padj
#
# Qué esperar en un análisis sano:
#   - La nube está centrada en y = 0 a lo largo de todo el eje x
#     (la mayoría de los genes no cambia).
#   - Forma de embudo: mucha dispersión a la izquierda (genes poco expresados,
#     más ruido) que se angosta hacia la derecha.
#   - Los genes azules están arriba y abajo, sobre todo en expresión media/alta.
#   - Las "rayas" a la izquierda vienen de los recuentos enteros bajos; son normales.
#   - Triángulos en el borde = genes fuera de ylim; no es un error.
#
# Cuándo es problemático:
#   - La nube NO está centrada en 0, o se curva según la expresión
#     -> falló la normalización (revisar sizeFactors(dds)) o hay un sesgo técnico.
#   - Casi todo sube (o baja) -> sospechar de la normalización antes que de la biología.
#   - Muchos genes azules con log2FC enorme y expresión muy baja
#     -> cambios inflados por pocos recuentos; filtrar más o usar lfcShrink (abajo).
#   - Ningún gen azul -> sin efecto, poca potencia (pocas réplicas)
#     o contraste/diseño mal definido.
#   - Miles de genes azules -> revisar en la PCA si una muestra es atípica
#     o si el tratamiento está confundido con un lote.
plotMA(res, ylim = c(-6, 6), main = "Grafico MA")
dev.copy2pdf(file = salida("02_ma.pdf"), width = 7, height = 5)

# Opcional: el mismo gráfico con log2FC "encogidos" (lfcShrink). Los genes poco
# expresados se acercan a 0 y los cambios grandes de verdad se mantienen.
# res_shr <- lfcShrink(dds, contrast = contraste, res = res, type = "normal")
# plotMA(res_shr, ylim = c(-6, 6), main = "Grafico MA (lfcShrink)")

sig <- rownames(res) %in% c(suben, bajan)
plot(res$log2FoldChange, -log10(res$padj), pch = 20, cex = 0.4,
     col = ifelse(sig, "firebrick", "grey60"),
     xlab = "log2 fold change (trt / untrt)", ylab = "-log10(padj)", main = "Volcan")
abline(v = c(-umbral_lfc, umbral_lfc), h = -log10(umbral_padj), lty = 2)
dev.copy2pdf(file = salida("03_volcan.pdf"), width = 7, height = 5)

# -----------------------------------------------------------------------------
# 9. Enriquecimiento (ORA) en GO Procesos Biológicos
#    ¿Qué términos aparecen más de lo esperado entre los genes que cambian,
#    comparado con el universo de genes probados?
# -----------------------------------------------------------------------------
go_ora <- function(genes) {
  enrichGO(gene = genes, universe = universo, OrgDb = org.Hs.eg.db,
           keyType = "ENSEMBL", ont = "BP", pAdjustMethod = "BH", readable = TRUE)
}
ego_suben <- go_ora(suben)
ego_bajan <- go_ora(bajan)

write.csv(as.data.frame(ego_suben), salida("GO_BP_suben.csv"), row.names = FALSE)
write.csv(as.data.frame(ego_bajan), salida("GO_BP_bajan.csv"), row.names = FALSE)

g_go_suben <- dotplot(ego_suben, showCategory = 15, title = "GO BP - genes que suben")
g_go_bajan <- dotplot(ego_bajan, showCategory = 15, title = "GO BP - genes que bajan")
print(g_go_suben)
print(g_go_bajan)
ggsave(salida("04_GO_BP_suben.pdf"), g_go_suben, width = 8, height = 6)
ggsave(salida("05_GO_BP_bajan.pdf"), g_go_bajan, width = 8, height = 6)

print(head(as.data.frame(ego_suben)[, c("Description", "GeneRatio", "p.adjust")], 10))

# -----------------------------------------------------------------------------
# 10. Enriquecimiento en vías KEGG (requiere internet; usa IDs Entrez)
# -----------------------------------------------------------------------------
a_entrez <- function(ids) {
  unique(bitr(ids, fromType = "ENSEMBL", toType = "ENTREZID",
              OrgDb = org.Hs.eg.db)$ENTREZID)
}
universo_entrez <- a_entrez(universo)

# Corre KEGG para una lista de genes, guarda la tabla y muestra las 10 primeras vías
kegg_ora <- function(genes, nombre) {
  ek <- tryCatch(
    enrichKEGG(gene = a_entrez(genes), universe = universo_entrez, organism = "hsa"),
    error = function(e) { cat("KEGG no disponible (¿sin internet?):", conditionMessage(e), "\n"); NULL }
  )
  if (is.null(ek)) return(NULL)
  ek <- setReadable(ek, OrgDb = org.Hs.eg.db, keyType = "ENTREZID")
  write.csv(as.data.frame(ek), salida(paste0("KEGG_", nombre, ".csv")), row.names = FALSE)
  cat("\nTop vías KEGG -", nombre, ":\n")
  print(head(as.data.frame(ek)[, c("Description", "GeneRatio", "p.adjust")], 10))
  ek
}

kegg_suben <- kegg_ora(suben, "suben")
kegg_bajan <- kegg_ora(bajan, "bajan")

# Comparen: ¿las vías de los que suben y de los que bajan cuentan la misma historia?

# -----------------------------------------------------------------------------
# 11. Guardar el objeto y la sesión (reproducibilidad)
# -----------------------------------------------------------------------------
saveRDS(dds, salida("dds_airway.rds"))
writeLines(capture.output(sessionInfo()), salida("sessionInfo.txt"))

cat("Listo. Todo quedó en", normalizePath(dir_salida), "\n")
