library(meta)

if (!exists("cont_model") && !exists("bin_model")) {
  stop("Neither cont_model nor bin_model found. Run 03_models.R first.")
}

if (exists("cont_model")) {
  cat("Leave-one-out influence analysis (continuous):\n")
  cont_inf <- metainf(cont_model)
  print(cont_inf)
}

if (exists("bin_model")) {
  cat("Leave-one-out influence analysis (binary):\n")
  bin_inf <- metainf(bin_model)
  print(bin_inf)
}
