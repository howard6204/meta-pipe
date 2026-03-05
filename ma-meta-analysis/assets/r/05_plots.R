library(meta)
library(ggplot2)

if (!exists("cont_model") && !exists("bin_model")) {
  stop("Neither cont_model nor bin_model found. Run 03_models.R first.")
}

if (!dir.exists("figures")) dir.create("figures", recursive = TRUE)

# ---------------------------------------------------------------------------
# Helper: calculate dynamic PNG height for meta::forest()
# ---------------------------------------------------------------------------
forest_height <- function(model, subgroups = FALSE, spacing = 1.0) {
  k <- model$k
  header  <- 1.0
  row_h   <- 0.35 * spacing
  footer  <- 1.5
  n_rows  <- k + 1

  if (subgroups && !is.null(model$bylevs)) {
    n_sg   <- length(model$bylevs)
    n_rows <- n_rows + n_sg * 2
    footer <- footer + 0.4
  }

  height_in <- header + (n_rows * row_h) + footer
  height_in <- max(height_in, 4)
  height_in <- min(height_in, 20)
  return(height_in)
}

FOREST_WIDTH_IN <- 10

if (exists("cont_model")) {
  # Forest plot
  tryCatch({
    h <- forest_height(cont_model)
    png("figures/forest_continuous.png",
        width = FOREST_WIDTH_IN, height = h, units = "in", res = 300)
    par(mar = c(4, 0, 1, 0))
    forest(cont_model, spacing = 1.5)
    dev.off()
    cat("Forest plot saved to figures/forest_continuous.png\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: Continuous forest plot failed:", e$message, "\n")
  })

  # Funnel plot
  tryCatch({
    png("figures/funnel_continuous.png",
        width = 7, height = 6, units = "in", res = 300)
    funnel(cont_model, backtransf = FALSE,
           xlab = paste0("Log ", cont_model$sm),
           studlab = TRUE, cex.studlab = 0.8,
           col = "navy", pch = 16)
    dev.off()
    cat("Funnel plot saved to figures/funnel_continuous.png\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: Continuous funnel plot failed:", e$message, "\n")
  })
}

if (exists("bin_model")) {
  # Forest plot
  tryCatch({
    h <- forest_height(bin_model)
    png("figures/forest_binary.png",
        width = FOREST_WIDTH_IN, height = h, units = "in", res = 300)
    par(mar = c(4, 0, 1, 0))
    forest(bin_model, spacing = 1.5)
    dev.off()
    cat("Forest plot saved to figures/forest_binary.png\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: Binary forest plot failed:", e$message, "\n")
  })

  # Funnel plot
  tryCatch({
    png("figures/funnel_binary.png",
        width = 7, height = 6, units = "in", res = 300)
    funnel(bin_model, backtransf = FALSE,
           xlab = paste0("Log ", bin_model$sm),
           studlab = TRUE, cex.studlab = 0.8,
           col = "navy", pch = 16)
    dev.off()
    cat("Funnel plot saved to figures/funnel_binary.png\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: Binary funnel plot failed:", e$message, "\n")
  })
}
