.libPaths(c("C:/Users/USER/R/library", .libPaths()))
pkgs <- c("netmeta","meta","metafor","ggplot2","gt","readr",
          "dplyr","tidyr","patchwork","scales","forcats","stringr",
          "gemtc","rjags","coda")
for (p in pkgs) {
  ok <- requireNamespace(p, quietly = TRUE)
  cat(sprintf("%-12s : %s\n", p, if(ok) "OK" else "MISSING"))
}
