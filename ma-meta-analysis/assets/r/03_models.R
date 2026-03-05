library(meta)
library(metafor)

# Expect objects cont_es or bin_es from 02_effect_sizes.R
#
# Defaults: REML + Hartung-Knapp (Cochrane mandate, July 2025)
#   method.tau = "REML"  -> replaces DerSimonian-Laird for tau² estimation
#   hakn = TRUE          -> Hartung-Knapp-Sidik-Jonkman adjustment for CIs/p-values
#   test = "knha"        -> metafor equivalent of hakn = TRUE

if (!exists("cont_es") && !exists("bin_es")) {
  stop("Neither cont_es nor bin_es found. Run 02_effect_sizes.R first.")
}

if (exists("cont_es")) {
  stopifnot("cont_es has no rows" = nrow(cont_es) > 0)
  cat("Fitting continuous model (SMD):", nrow(cont_es), "studies\n")
  cont_model <- metagen(
    TE = cont_es$yi,
    seTE = sqrt(cont_es$vi),
    studlab = cont_es$slab,
    sm = "SMD",
    method.tau = "REML",
    hakn = TRUE
  )
}

if (exists("bin_es")) {
  stopifnot("bin_es has no rows" = nrow(bin_es) > 0)
  cat("Fitting binary model (RR):", nrow(bin_es), "studies\n")
  bin_model <- metagen(
    TE = bin_es$yi,
    seTE = sqrt(bin_es$vi),
    studlab = bin_es$slab,
    sm = "RR",
    method.tau = "REML",
    hakn = TRUE
  )
}

# metafor model (for meta-regression in 04_subgroups)
if (exists("cont_es")) {
  cont_rma <- rma(yi = cont_es$yi, vi = cont_es$vi, method = "REML", test = "knha")
}
