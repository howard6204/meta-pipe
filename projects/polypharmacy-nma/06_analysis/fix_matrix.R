lib_dir <- "C:/Users/USER/R/library"
.libPaths(c(lib_dir, .libPaths()))
options(repos = c(CRAN = "https://cloud.r-project.org"))
# Reinstall Matrix and lme4 as binary
for (p in c("Matrix", "lme4")) {
  cat("Reinstalling:", p, "\n")
  install.packages(p, lib = lib_dir, type = "binary")
  cat("  Done:", p, "\n")
}
cat("Matrix:", as.character(packageVersion("Matrix")), "\n")
