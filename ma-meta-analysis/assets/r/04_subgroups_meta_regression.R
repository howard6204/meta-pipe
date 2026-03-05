library(meta)
library(metafor)

# Upstream validation: require at least one model and effect-size object
if (!exists("cont_model") && !exists("bin_model")) {
  stop("Neither cont_model nor bin_model found. Run 03_models.R first.")
}
if (!exists("cont_es") && !exists("bin_es")) {
  stop("Neither cont_es nor bin_es found. Run 02_effect_sizes.R first.")
}

# Subgroup analysis by study design (continuous outcomes)
# Note: subgroup model inherits method.tau and hakn from cont_model (03_models.R)
if (exists("cont_es") && exists("cont_model") && "design" %in% names(cont_es)) {
  cat("Running subgroup analysis by design (continuous)...\n")
  cont_subgroup <- update.meta(cont_model, byvar = cont_es$design, comb.random = TRUE)
  print(cont_subgroup)
}

# Meta-regression using metafor (continuous outcomes)
# Replace "moderator" with your actual numeric variable name
# test = "knha" applies Hartung-Knapp adjustment (Cochrane 2025 default)
if (exists("cont_es") && "moderator" %in% names(cont_es)) {
  cat("Running meta-regression on moderator (continuous)...\n")
  cont_reg <- rma(yi = cont_es$yi, vi = cont_es$vi,
                  mods = ~ moderator, method = "REML", test = "knha")
  print(cont_reg)
}

# Subgroup analysis by study design (binary outcomes)
if (exists("bin_es") && exists("bin_model") && "design" %in% names(bin_es)) {
  cat("Running subgroup analysis by design (binary)...\n")
  bin_subgroup <- update.meta(bin_model, byvar = bin_es$design, comb.random = TRUE)
  print(bin_subgroup)
}
