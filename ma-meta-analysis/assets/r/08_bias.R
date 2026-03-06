library(meta)
library(metafor)

# ---------------------------------------------------------------------------
# Publication bias assessment with funnel plots on log scale + Egger's test
#
# Why log scale? For ratio measures (HR, RR, OR), the funnel plot's confidence
# region is only symmetric on the log scale. On the natural scale, the shading
# is skewed, making visual assessment of asymmetry misleading.
#
# backtransf = FALSE  -> x-axis shows log(HR), log(RR), or log(OR)
# studlab = TRUE      -> label points with study names
# ---------------------------------------------------------------------------

# Upstream validation
if (!exists("cont_model") && !exists("bin_model")) {
  stop("Neither cont_model nor bin_model found. Run 03_models.R first.")
}

if (!dir.exists("figures")) dir.create("figures", recursive = TRUE)

# --- Continuous outcomes (SMD, MD) ---
if (exists("cont_model")) {
  cat("=== Publication Bias Assessment (Continuous) ===\n")

  # Egger's test (requires k >= 10 for meaningful interpretation)
  cont_bias <- tryCatch(
    metabias(cont_model, method.bias = "linreg"),
    error = function(e) {
      cat("Warning: Egger's test failed:", e$message, "\n")
      cat("This typically requires >= 10 studies.\n")
      NULL
    }
  )

  # Funnel plot
  tryCatch({
    png("figures/funnel_continuous_bias.png",
        width = 7, height = 6, units = "in", res = 300)
    funnel(cont_model,
           studlab = TRUE, cex.studlab = 0.8,
           xlab = cont_model$sm,
           col = "navy", pch = 16)
    if (!is.null(cont_bias)) {
      title(sub = sprintf("Egger's test: t = %.2f, p = %.3f",
                           cont_bias$statistic, cont_bias$p.value),
            cex.sub = 0.9, col.sub = "gray40")
    }
    dev.off()
    cat("Funnel plot saved to figures/funnel_continuous_bias.png\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: Continuous funnel plot failed:", e$message, "\n")
  })

  # Contour-enhanced funnel
  tryCatch({
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
    cat("Contour-enhanced funnel saved to figures/funnel_continuous_contour.png\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: Contour funnel plot failed:", e$message, "\n")
  })
}

# --- Binary / ratio outcomes (RR, OR, HR) ---
if (exists("bin_model")) {
  cat("=== Publication Bias Assessment (Binary) ===\n")

  # Peters' test preferred for binary outcomes (lower false-positive rate)
  bin_bias <- tryCatch(
    metabias(bin_model, method.bias = "linreg"),
    error = function(e) {
      cat("Warning: Egger's test failed:", e$message, "\n")
      cat("This typically requires >= 10 studies.\n")
      NULL
    }
  )

  # Funnel plot on LOG scale -> symmetric confidence region
  tryCatch({
    png("figures/funnel_binary_bias.png",
        width = 7, height = 6, units = "in", res = 300)
    funnel(bin_model, backtransf = FALSE,
           studlab = TRUE, cex.studlab = 0.8,
           xlab = paste0("Log ", bin_model$sm),
           col = "navy", pch = 16)
    if (!is.null(bin_bias)) {
      title(sub = sprintf("Egger's test: t = %.2f, p = %.3f",
                           bin_bias$statistic, bin_bias$p.value),
            cex.sub = 0.9, col.sub = "gray40")
    }
    dev.off()
    cat("Funnel plot saved to figures/funnel_binary_bias.png\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: Binary funnel plot failed:", e$message, "\n")
  })

  # Contour-enhanced funnel on log scale
  tryCatch({
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
    cat("Contour-enhanced funnel saved to figures/funnel_binary_contour.png\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: Contour funnel plot failed:", e$message, "\n")
  })
}

# --- metafor models ---
if (exists("cont_rma")) {
  cat("\n=== Regression Test (metafor) ===\n")
  cont_regtest <- tryCatch(
    regtest(cont_rma, model = "rma"),
    error = function(e) {
      cat("Warning: regtest() failed:", e$message, "\n")
      NULL
    }
  )
  if (!is.null(cont_regtest)) print(cont_regtest)
}
