library(meta)
library(metafor)

# ---------------------------------------------------------------------------
# Publication bias assessment with funnel plots + asymmetry tests
#
# Why log scale? For ratio measures (HR, RR, OR), the funnel plot's confidence
# region is only symmetric on the log scale. On the natural scale, the shading
# is skewed, making visual assessment of asymmetry misleading.
#
# backtransf = FALSE  -> x-axis shows log(HR), log(RR), or log(OR)
# studlab = TRUE      -> label points with study names
#
# Test selection:
#   - Continuous outcomes: Egger's test (linreg) — standard for SMD/MD
#   - Binary outcomes: Peters' test preferred over Egger's, which is biased
#     when effect size and precision are both functions of sample size
#     (Sterne et al. 2000, PMID: 10693471; Peters et al. 2006, PMID: 16461356)
#   - Both tests have limited power with <10 studies
#     (Cochrane Handbook §13.3.5.2; Sterne et al. 2011, PMID: 21952616)
# ---------------------------------------------------------------------------

# Helper: build subtitle with low-power caveat when applicable
.bias_subtitle <- function(test_label, test_result, n_studies) {
  base <- sprintf("%s: t = %.2f, p = %.3f",
                  test_label, test_result$statistic, test_result$p.value)
  if (n_studies < 10) {
    base <- paste0(base, sprintf(
      "\nNote: limited power with %d studies (<10; Cochrane Handbook §13.3.5.2)",
      n_studies))
  }
  base
}

# --- Continuous outcomes (SMD, MD) ---
if (exists("cont_model")) {
  cont_bias <- metabias(cont_model, method.bias = "linreg")
  n_cont <- cont_model$k

  # Funnel plot (continuous outcomes are already on linear scale, no log needed)
  png("figures/funnel_continuous_bias.png",
      width = 7, height = 6, units = "in", res = 300)
  funnel(cont_model,
         studlab = TRUE, cex.studlab = 0.8,
         xlab = cont_model$sm,
         col = "navy", pch = 16)
  title(sub = .bias_subtitle("Egger's test", cont_bias, n_cont),
        cex.sub = 0.9, col.sub = "gray40")
  dev.off()

  # Contour-enhanced funnel
  png("figures/funnel_continuous_contour.png",
      width = 7, height = 6, units = "in", res = 300)
  funnel(cont_model,
         contour.levels = c(0.90, 0.95, 0.99),
         col.contour = c("gray90", "gray75", "gray60"),
         studlab = TRUE, cex.studlab = 0.8,
         xlab = cont_model$sm,
         col = "navy", pch = 16)
  legend("topright",
         c("p > 0.10", "0.05 < p < 0.10", "0.01 < p < 0.05", "p < 0.01"),
         fill = c("white", "gray90", "gray75", "gray60"),
         bty = "n", cex = 0.7)
  dev.off()
}

# --- Binary / ratio outcomes (RR, OR, HR) ---
if (exists("bin_model")) {
  n_bin <- bin_model$k

  # Egger's test (retained for comparability, but see caveat below)
  bin_egger <- metabias(bin_model, method.bias = "linreg")

  # Peters' test — recommended for binary outcomes (lower false-positive rate;
  # Peters et al. 2006, PMID: 16461356)
  bin_peters <- metabias(bin_model, method.bias = "peters")

  # Funnel plot on LOG scale -> symmetric confidence region
  # Subtitle shows Peters' test (primary) with Egger's for reference
  sub_text <- sprintf(
    "Peters' test: t = %.2f, p = %.3f  |  Egger's test: t = %.2f, p = %.3f",
    bin_peters$statistic, bin_peters$p.value,
    bin_egger$statistic, bin_egger$p.value)
  if (n_bin < 10) {
    sub_text <- paste0(sub_text, sprintf(
      "\nNote: limited power with %d studies (<10; Cochrane Handbook §13.3.5.2)",
      n_bin))
  }

  png("figures/funnel_binary_bias.png",
      width = 7, height = 6, units = "in", res = 300)
  funnel(bin_model, backtransf = FALSE,
         studlab = TRUE, cex.studlab = 0.8,
         xlab = paste0("Log ", bin_model$sm),
         col = "navy", pch = 16)
  title(sub = sub_text, cex.sub = 0.9, col.sub = "gray40")
  dev.off()

  # Contour-enhanced funnel on log scale
  png("figures/funnel_binary_contour.png",
      width = 7, height = 6, units = "in", res = 300)
  funnel(bin_model, backtransf = FALSE,
         contour.levels = c(0.90, 0.95, 0.99),
         col.contour = c("gray90", "gray75", "gray60"),
         studlab = TRUE, cex.studlab = 0.8,
         xlab = paste0("Log ", bin_model$sm),
         col = "navy", pch = 16)
  legend("topright",
         c("p > 0.10", "0.05 < p < 0.10", "0.01 < p < 0.05", "p < 0.01"),
         fill = c("white", "gray90", "gray75", "gray60"),
         bty = "n", cex = 0.7)
  dev.off()
}

# --- metafor models ---
if (exists("cont_rma")) {
  cont_regtest <- regtest(cont_rma, model = "rma")
}
