lib_dir <- "C:/Users/USER/R/library"
.libPaths(c(lib_dir, .libPaths()))
options(repos = c(CRAN = "https://cloud.r-project.org"))

missing_deps <- c("reformulas", "pbapply", "numDeriv", "Rdpack", "rbibutils")
for (p in missing_deps) {
  if (!requireNamespace(p, quietly = TRUE)) {
    cat("Installing:", p, "\n")
    install.packages(p, lib = lib_dir, type = "binary")
    cat("  Done:", p, "\n")
  } else {
    cat("Already installed:", p, "\n")
  }
}

cat("\nCheck:\n")
for (p in c("reformulas", "meta", "netmeta", "lme4")) {
  cat(sprintf("  %-12s : %s\n", p,
              if (requireNamespace(p, quietly = TRUE)) "OK" else "MISSING"))
}
