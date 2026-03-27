lib_dir <- "C:/Users/USER/R/library"
.libPaths(c(lib_dir, .libPaths()))
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Install netmeta (and meta as dependency)
for (p in c("meta", "netmeta")) {
  if (!requireNamespace(p, quietly = TRUE)) {
    cat("Installing:", p, "\n")
    install.packages(p, lib = lib_dir, type = "binary")
    cat("Done:", p, "\n")
  } else {
    cat("Already installed:", p, "\n")
  }
}

# Check rjags (requires JAGS system library)
rjags_ok <- tryCatch({
  library(rjags)
  TRUE
}, error = function(e) {
  cat("rjags not available:", conditionMessage(e), "\n")
  cat("=> Bayesian NMA (gemtc) will be skipped. Using frequentist netmeta only.\n")
  FALSE
})

cat("\nFinal check:\n")
for (p in c("meta", "netmeta", "rjags", "gemtc")) {
  cat(sprintf("  %-10s : %s\n", p, if(requireNamespace(p, quietly=TRUE)) "OK" else "MISSING"))
}
cat("rjags loadable:", rjags_ok, "\n")
