lib_dir <- "C:/Users/USER/R/library"
if (!dir.exists(lib_dir)) dir.create(lib_dir, recursive = TRUE)
.libPaths(c(lib_dir, .libPaths()))

options(repos = c(CRAN = "https://cloud.r-project.org"))

pkgs <- c("netmeta", "meta", "metafor", "ggplot2", "gt", "readr",
          "dplyr", "tidyr", "patchwork", "scales", "forcats", "stringr")

for (p in pkgs) {
  if (!requireNamespace(p, quietly = TRUE)) {
    cat("Installing:", p, "\n")
    install.packages(p, lib = lib_dir, dependencies = TRUE)
    cat("  Done:", p, "\n")
  } else {
    cat("Already installed:", p, "\n")
  }
}

# Try gemtc (needs JAGS)
if (!requireNamespace("gemtc", quietly = TRUE)) {
  cat("Installing: gemtc\n")
  tryCatch(
    install.packages("gemtc", lib = lib_dir),
    error = function(e) cat("gemtc install failed:", conditionMessage(e), "\n")
  )
}

cat("\n=== Installation complete ===\n")
for (p in c(pkgs, "gemtc")) {
  ok <- requireNamespace(p, quietly = TRUE)
  cat(sprintf("  %-12s : %s\n", p, if(ok) "OK" else "MISSING"))
}
