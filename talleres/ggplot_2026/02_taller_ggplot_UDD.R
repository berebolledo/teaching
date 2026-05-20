# Taller de Visualización de Datos con ggplot2

# Instalar paquetes (solo la primera vez)
install.packages(c("ggplot2", "dplyr", "tidyr", "scales",
                   "medicaldata", "ggpubr", "patchwork"))

library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)
library(medicaldata)
library(ggpubr)
library(patchwork)

theme_set(theme_bw(base_size = 13))
cat("Paquetes cargados correctamente.\n")

# Cargar dataset principal
indo <- medicaldata::indo_rct

cat("=== indo_rct: RCT de Indometacina (NEJM 2012) ===\n")
cat("Filas:", nrow(indo), "| Columnas:", ncol(indo), "\n\n")
glimpse(indo)

# Explorar las variables clave
# NOTA: las variables categóricas son factores con etiquetas como "0_no" / "1_yes"

cat("── Tratamiento (rx):\n")
print(table(indo$rx))

cat("\n── Desenlace primario (outcome):\n")
print(table(indo$outcome))

cat("\n── Sexo (gender):\n")
print(table(indo$gender))

cat("\n── Pancreatitis previa (pep):\n")
print(table(indo$pep))

cat("\n── Resumen variables numéricas:\n")
indo %>% select(age, risk) %>% summary() %>% print()

cat("\n📖 Diccionario de variables clave:\n")
cat("  rx      : 0_placebo = Placebo | 1_indomethacin = Indometacina\n")
cat("  outcome : 0_no = Sin pancreatitis | 1_yes = Pancreatitis post-CPRE\n")
cat("  gender  : 1_female = Femenino | 2_male = Masculino\n")
cat("  age     : Edad del paciente (años)\n")
cat("  risk    : Puntaje de riesgo compuesto (suma de factores de riesgo)\n")
cat("  pep     : Pancreatitis post-CPRE previa (0_no / 1_yes)\n")
cat("  sod     : Disfunción del esfínter de Oddi (0_no / 1_yes)\n")
cat("  site    : Centro clínico (1_UM, 2_IU, 3_UC, 4_Case)\n")

# Crear versión con etiquetas legibles en español
# Los niveles del factor se mapean explícitamente

indo_clean <- indo %>%
  mutate(
    tratamiento  = recode(as.character(rx),
                          "0_placebo"      = "Placebo",
                          "1_indomethacin" = "Indometacina"),
    pancreatitis = recode(as.character(outcome),
                          "0_no"  = "No",
                          "1_yes" = "Sí"),
    sexo         = recode(as.character(gender),
                          "1_female" = "Femenino",
                          "2_male"   = "Masculino"),
    pep_prev     = recode(as.character(pep),
                          "0_no"  = "No",
                          "1_yes" = "Sí"),
    sod_dx       = recode(as.character(sod),
                          "0_no"  = "No",
                          "1_yes" = "Sí"),
    tratamiento  = factor(tratamiento, levels = c("Placebo", "Indometacina")),
    pancreatitis = factor(pancreatitis, levels = c("No", "Sí")),
    sexo         = factor(sexo, levels = c("Femenino", "Masculino"))
  )

cat("Dataset indo_clean preparado:\n")
head(indo_clean %>% select(tratamiento, pancreatitis, sexo, pep_prev, age, risk))

# Bloque 1 · Fundamentos de ggplot2

# Ejercicio 1.1: Histograma de edad
# Pregunta clínica: ¿Cómo se distribuye la edad en este ensayo?

ggplot(data = indo_clean, aes(x = age)) +
  geom_histogram(bins = 25, fill = "steelblue", color = "white") +
  labs(
    title   = "Distribución de edad en el ensayo clínico",
    subtitle = "Indometacina para prevención de pancreatitis post-CPRE (NEJM 2012)",
    x = "Edad (años)",
    y = "Número de pacientes",
    caption = "Fuente: Elmunzer et al., NEJM 2012 | N = 602"
  )

# Ejercicio 1.2: ¿Están los grupos balanceados en edad?
# Mapear 'fill' al tratamiento superpone las distribuciones

ggplot(indo_clean, aes(x = age, fill = tratamiento)) +
  geom_histogram(bins = 25, alpha = 0.65, position = "identity", color = "white") +
  scale_fill_manual(values = c("Placebo" = "#7B9EC1", "Indometacina" = "#E07B5A")) +
  labs(
    title    = "Balance de edad entre grupos de tratamiento",
    subtitle = "Un buen balance es evidencia de aleatorización exitosa",
    x = "Edad (años)", y = "Número de pacientes", fill = "Tratamiento"
  )

# Verificar numéricamente
indo_clean %>%
  group_by(tratamiento) %>%
  summarise(n = n(),
            media_edad = round(mean(age), 1),
            de_edad    = round(sd(age), 1))

# Ejercicio 1.3: ¿Redujo la indometacina la incidencia de pancreatitis?

prop_pep <- indo_clean %>%
  count(tratamiento, pancreatitis) %>%
  group_by(tratamiento) %>%
  mutate(proporcion = n / sum(n),
         etiqueta   = paste0(round(proporcion * 100, 1), "%"))

ggplot(prop_pep, aes(x = tratamiento, y = proporcion, fill = pancreatitis)) +
  geom_col(position = "fill", width = 0.6) +
  geom_text(aes(label = etiqueta),
            position = position_fill(vjust = 0.5),
            color = "white", fontface = "bold", size = 4.5) +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_manual(values = c("No" = "#2A9D8F", "Sí" = "#E76F51")) +
  labs(
    title    = "Incidencia de pancreatitis post-CPRE por grupo",
    subtitle = "Desenlace primario del RCT (Elmunzer et al., NEJM 2012)",
    x = "Tratamiento", y = "Proporción de pacientes", fill = "Pancreatitis"
  )

# Ejercicio 2.1: Boxplot + jitter
# Pregunta: ¿Está el riesgo basal balanceado entre grupos?

ggplot(indo_clean, aes(x = tratamiento, y = risk, fill = tratamiento)) +
  geom_boxplot(alpha = 0.7, outlier.color = "red", outlier.size = 2) +
  geom_jitter(width = 0.2, alpha = 0.25, size = 1) +
  scale_fill_manual(values = c("Placebo" = "#7B9EC1", "Indometacina" = "#E07B5A")) +
  labs(
    title   = "Puntaje de riesgo basal por grupo de tratamiento",
    subtitle = "Balance esperado por aleatorización",
    x = "Tratamiento", y = "Puntaje de riesgo compuesto"
  ) +
  theme(legend.position = "none")

# Ejercicio 2.2: Gráfico de barras facetado por sexo
# Pregunta: ¿El efecto de la indometacina difiere entre hombres y mujeres?

conteo <- indo_clean %>%
  count(tratamiento, sexo, pancreatitis) %>%
  group_by(tratamiento, sexo) %>%
  mutate(prop = n / sum(n))

ggplot(conteo, aes(x = pancreatitis, y = prop, fill = tratamiento)) +
  geom_col(position = position_dodge(0.8), width = 0.7) +
  facet_wrap(~ sexo) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  scale_fill_manual(values = c("Placebo" = "#7B9EC1", "Indometacina" = "#E07B5A")) +
  labs(
    title    = "Incidencia de pancreatitis por tratamiento y sexo",
    subtitle = "Análisis de subgrupos: ¿el efecto es homogéneo?",
    x = "Pancreatitis post-CPRE", y = "Proporción de pacientes", fill = "Tratamiento"
  )

# Ejercicio 2.3: Dispersión edad vs. riesgo coloreado por desenlace
# Pregunta: ¿Los pacientes que desarrollaron pancreatitis tenían mayor riesgo basal?

ggplot(indo_clean, aes(x = age, y = risk, color = pancreatitis)) +
  geom_point(alpha = 0.55, size = 2) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1.1) +
  scale_color_manual(
    values = c("No" = "#2A9D8F", "Sí" = "#E76F51"),
    labels = c("No" = "Sin pancreatitis", "Sí" = "Con pancreatitis")
  ) +
  labs(
    title    = "Relación entre edad y puntaje de riesgo según desenlace",
    subtitle = "Regresión lineal con intervalo de confianza 95%",
    x = "Edad (años)", y = "Puntaje de riesgo compuesto", color = "Pancreatitis"
  )

# Ejercicio 2.4: Edad media ± error estándar
# Pregunta: ¿Difiere la edad según si el paciente tenía PEP previa y el grupo de tratamiento?

resumen <- indo_clean %>%
  group_by(tratamiento, pep_prev) %>%
  summarise(
    n     = n(),
    media = mean(age, na.rm = TRUE),
    se    = sd(age, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  )

print(resumen)

ggplot(resumen, aes(x = tratamiento, y = media, fill = pep_prev)) +
  geom_col(position = position_dodge(0.8), width = 0.65, alpha = 0.85) +
  geom_errorbar(
    aes(ymin = media - se, ymax = media + se),
    position = position_dodge(0.8), width = 0.25, linewidth = 0.8
  ) +
  scale_fill_manual(values = c("No" = "#4E8098", "Sí" = "#C7522B")) +
  labs(
    title    = "Edad media por tratamiento y antecedente de PEP",
    subtitle = "Barras de error: ±1 error estándar",
    x = "Tratamiento", y = "Edad media (años)", fill = "PEP previa"
  )

# Bloque 3 · Gráficos avanzados para publicación

# Ejercicio 3.1: Violin + boxplot interior + Mann-Whitney
# Pregunta: ¿Tenían mayor puntaje de riesgo los pacientes que desarrollaron pancreatitis?

p_violin <- ggplot(indo_clean, aes(x = pancreatitis, y = risk, fill = pancreatitis)) +
  geom_violin(trim = FALSE, alpha = 0.6) +
  geom_boxplot(width = 0.12, fill = "white", outlier.size = 1.5) +
  scale_fill_manual(values = c("No" = "#2A9D8F", "Sí" = "#E76F51")) +
  labs(
    title    = "Puntaje de riesgo basal según desenlace",
    subtitle = "Mayor riesgo basal → mayor probabilidad de pancreatitis post-CPRE",
    x = "Pancreatitis post-CPRE", y = "Puntaje de riesgo compuesto"
  ) +
  theme(legend.position = "none")

# Agregar comparación estadística (Mann-Whitney U)
p_violin +
  ggpubr::stat_compare_means(
    method  = "wilcox.test",
    label   = "p.format",
    label.x = 1.4,
    label.y = max(indo_clean$risk, na.rm = TRUE) * 1.04
  )

# Ejercicio 3.2: Heatmap de correlación de Spearman
# Convertimos variables factor a numérico (0/1) para calcular correlaciones

vars_bin <- indo %>%
  select(pep, sod, psphinc, precut, difcan, pneudil, amp, paninj, acinar, brush) %>%
  mutate(across(everything(), ~ as.integer(.) - 1)) %>%
  na.omit()

cor_mat <- cor(vars_bin, method = "spearman") %>% round(2)

etiquetas <- c(
  pep     = "PEP previa",
  sod     = "Disf. esfínter",
  psphinc = "Esfinterotomía",
  precut  = "Precut",
  difcan  = "Can. difícil",
  pneudil = "Dilat. neumática",
  amp     = "Ampulectomía",
  paninj  = "Inj. pancreática",
  acinar  = "Acinarización",
  brush   = "Cepillado"
)

cor_long <- as.data.frame(cor_mat) %>%
  tibble::rownames_to_column("var1") %>%
  pivot_longer(-var1, names_to = "var2", values_to = "r") %>%
  mutate(var1 = etiquetas[var1], var2 = etiquetas[var2])

ggplot(cor_long, aes(x = var1, y = var2, fill = r)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = r), size = 3,
            color = ifelse(abs(cor_long$r) > 0.35, "white", "black")) +
  scale_fill_gradient2(
    low = "#2166AC", mid = "white", high = "#D6604D",
    midpoint = 0, limits = c(-1, 1), name = "r de\nSpearman"
  ) +
  coord_fixed() +
  labs(
    title    = "Correlaciones entre factores de riesgo clínicos",
    subtitle = "Coeficiente de Spearman — indo_rct (NEJM 2012)",
    x = NULL, y = NULL
  ) +
  theme(axis.text.x = element_text(angle = 40, hjust = 1, size = 9),
        axis.text.y = element_text(size = 9))

# Ejercicio 3.3 · Panel multipanel para publicación
# Panel A: Densidad de edad por grupo
p_A <- ggplot(indo_clean, aes(x = age, fill = tratamiento)) +
  geom_density(alpha = 0.55) +
  scale_fill_manual(values = c("Placebo" = "#7B9EC1", "Indometacina" = "#E07B5A")) +
  labs(x = "Edad (años)", y = "Densidad", fill = "Tratamiento") +
  theme_classic()

# Panel B: Boxplot de riesgo
p_B <- ggplot(indo_clean, aes(x = tratamiento, y = risk, fill = tratamiento)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.2, size = 0.7) +
  scale_fill_manual(values = c("Placebo" = "#7B9EC1", "Indometacina" = "#E07B5A")) +
  labs(x = "Tratamiento", y = "Puntaje de riesgo") +
  theme_classic() + theme(legend.position = "none")

# Panel C: Incidencia del desenlace primario
prop2 <- indo_clean %>%
  group_by(tratamiento) %>%
  summarise(n_pep = sum(pancreatitis == "Sí"), n = n(),
            prop  = n_pep / n, se = sqrt(prop * (1 - prop) / n), .groups = "drop")

p_C <- ggplot(prop2, aes(x = tratamiento, y = prop, fill = tratamiento)) +
  geom_col(width = 0.5, alpha = 0.85) +
  geom_errorbar(aes(ymin = prop - se, ymax = prop + se), width = 0.2) +
  geom_text(aes(label = paste0(round(prop * 100, 1), "%")),
            vjust = -0.9, fontface = "bold", size = 4) +
  scale_y_continuous(labels = percent_format(), limits = c(0, 0.25)) +
  scale_fill_manual(values = c("Placebo" = "#7B9EC1", "Indometacina" = "#E07B5A")) +
  labs(x = "Tratamiento", y = "Incidencia de PEP") +
  theme_classic() + theme(legend.position = "none")

# Panel D: Desenlace por pancreatitis previa
p_D <- indo_clean %>%
  count(pep_prev, pancreatitis) %>%
  group_by(pep_prev) %>% mutate(prop = n / sum(n)) %>%
  ggplot(aes(x = pep_prev, y = prop, fill = pancreatitis)) +
  geom_col(position = "fill", width = 0.6) +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_manual(values = c("No" = "#2A9D8F", "Sí" = "#E76F51")) +
  labs(x = "PEP previa", y = "Proporción", fill = "Pancreatitis") +
  theme_classic()

# Ensamblar
(p_A | p_B) / (p_C | p_D) +
  plot_annotation(
    title    = "Ensayo de Indometacina para Prevención de Pancreatitis Post-CPRE",
    subtitle = "Elmunzer et al., New England Journal of Medicine, 2012 (N = 602)",
    caption  = "PEP: pancreatitis post-CPRE. Barras de error: ±1 SE.",
    tag_levels = "A"
  ) & theme(plot.tag = element_text(face = "bold", size = 13))

# Guardar el último gráfico generado:
ggsave("figura1.pdf",  width = 10, height = 8, dpi = 300)  # vectorial
ggsave("figura1.tiff", width = 10, height = 8, dpi = 300)  # alta resolución
ggsave("figura1.png",  width = 10, height = 8, dpi = 300)  # web/presentaciones

# Guardar un gráfico específico:
ggsave("figura_A.pdf", plot = p_A, width = 6, height = 4, dpi = 300)

cat("Formatos recomendados para revistas biomédicas:\n")
cat("  PDF / SVG  → vectorial (Nature, NEJM, Lancet)\n")
cat("  TIFF 300+ → estándar en revistas clínicas\n")
cat("  PNG 300   → web y presentaciones\n")
