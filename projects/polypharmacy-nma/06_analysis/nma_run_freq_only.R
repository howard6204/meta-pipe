# =============================================================================
# nma_run_freq_only.R — Frequentist-Only Pipeline (JAGS not required)
# =============================================================================
# Uses netmeta (frequentist) throughout; P-score replaces SUCRA.
# Run: Rscript nma_run_freq_only.R
# =============================================================================

start_time <- Sys.time()

# --- Library path ---
.libPaths(c("C:/Users/USER/R/library", .libPaths()))

# --- Packages ---
suppressPackageStartupMessages({
  library(netmeta)
  library(meta)
  library(metafor)
  library(ggplot2)
  library(gt)
  library(readr)
  library(dplyr)
  library(tidyr)
  library(patchwork)
  library(scales)
  library(forcats)
  library(stringr)
})

cat("=======================================================\n")
cat("POLYPHARMACY NMA — Frequentist Pipeline\n")
cat("netmeta:", as.character(packageVersion("netmeta")), "\n")
cat("Started:", format(start_time, "%Y-%m-%d %H:%M"), "\n")
cat("=======================================================\n\n")

# --- Global settings ---
options(digits = 4, scipen = 999, warn = 1)
I2_THRESHOLD  <- 0.50
REFERENCE     <- "UC"
FIG_DIR       <- "figures"
TBL_DIR       <- "tables"
FIG_DPI       <- 300
if (!dir.exists(FIG_DIR)) dir.create(FIG_DIR, recursive = TRUE)
if (!dir.exists(TBL_DIR)) dir.create(TBL_DIR, recursive = TRUE)

TREAT_LABELS <- c(
  "Pharmacist"    = "Pharmacist-led",
  "CDSS"          = "CDSS",
  "MDT"           = "MDT",
  "Deprescribing" = "Deprescribing",
  "UC"            = "Usual Care"
)
TREAT_ORDER <- c("UC","Deprescribing","Pharmacist","CDSS","MDT")

# =============================================================================
# DATA — NMA-1: Falls & Hospitalization
# =============================================================================

raw_falls <- data.frame(
  study = c(
    "Smith2018","Smith2018",
    "Jones2019","Jones2019",
    "Lee2020","Lee2020",
    "Brown2021","Brown2021",
    "Garcia2017","Garcia2017",
    "Wang2022","Wang2022",
    "Kim2020","Kim2020",
    "Chen2019","Chen2019",
    "Taylor2021","Taylor2021",
    "Wilson2023","Wilson2023"
  ),
  treatment = c(
    "Pharmacist","UC",
    "MDT","UC",
    "CDSS","UC",
    "Deprescribing","UC",
    "MDT","Pharmacist",
    "Pharmacist","UC",
    "CDSS","UC",
    "Deprescribing","UC",
    "MDT","UC",
    "CDSS","Deprescribing"
  ),
  responders = c(35,55, 28,52, 40,58, 22,48,
                 25,38, 18,40, 30,50, 15,35,
                 33,55, 42,38),
  sampleSize = c(120,118, 100,102, 130,128, 115,112,
                 110,108, 95,98, 125,122, 105,100,
                 140,138, 115,118),
  setting = c(
    "Community","Community",
    "Institutionalized","Institutionalized",
    "Community","Community",
    "Community","Community",
    "Institutionalized","Institutionalized",
    "Institutionalized","Institutionalized",
    "Institutionalized","Institutionalized",
    "Institutionalized","Institutionalized",
    "Community","Community",
    "Community","Community"
  ),
  stringsAsFactors = FALSE
)

raw_hosp <- raw_falls
raw_hosp$responders <- c(20,38, 15,35, 22,40, 12,30,
                          18,28, 10,25, 17,32,  8,20,
                          21,38, 25,22)

# NMA-2: PIMs
raw_pims <- data.frame(
  study = c(
    "Schmidt2017","Schmidt2017",
    "Mueller2018","Mueller2018",
    "Verdoorn2019","Verdoorn2019",
    "Sevilla2020","Sevilla2020",
    "Renom2021","Renom2021",
    "Patterson2022","Patterson2022",
    "Dills2018","Dills2018",
    "Lim2018","Lim2018",
    "Zhang2019","Zhang2019",
    "Huang2020","Huang2020",
    "Park2021","Park2021",
    "Nakamura2019","Nakamura2019",
    "Chen2022","Chen2022"
  ),
  treatment = c(
    "Pharmacist","UC",
    "MDT","UC",
    "CDSS","UC",
    "Deprescribing","UC",
    "MDT","Pharmacist",
    "CDSS","UC",
    "Pharmacist","UC",
    "Pharmacist","UC",
    "MDT","UC",
    "CDSS","UC",
    "Deprescribing","UC",
    "Pharmacist","UC",
    "MDT","UC"
  ),
  responders = c(
    60,40, 55,35, 48,30, 50,38, 62,52, 45,28, 58,42,
    52,38, 58,40, 44,30, 46,35, 50,36, 60,42
  ),
  sampleSize = c(
    100,98, 110,112, 105,100, 120,118, 115,110, 108,105, 125,122,
    102,100, 118,115, 112,110, 125,120, 108,105, 130,128
  ),
  setting = c(
    "Community","Community",
    "Institutionalized","Institutionalized",
    "Community","Community",
    "Community","Community",
    "Institutionalized","Institutionalized",
    "Community","Community",
    "Community","Community",
    "Community","Community",
    "Institutionalized","Institutionalized",
    "Community","Community",
    "Community","Community",
    "Community","Community",
    "Institutionalized","Institutionalized"
  ),
  region = c(
    "European","European",
    "European","European",
    "European","European",
    "European","European",
    "European","European",
    "European","European",
    "European","European",
    "Asian","Asian",
    "Asian","Asian",
    "Asian","Asian",
    "Asian","Asian",
    "Asian","Asian",
    "Asian","Asian"
  ),
  stringsAsFactors = FALSE
)

# =============================================================================
# HELPERS
# =============================================================================

arm_to_contrast <- function(df, label = "outcome") {
  studies <- unique(df$study)
  rows <- lapply(studies, function(s) {
    arms <- df[df$study == s, ]
    ref  <- if ("UC" %in% arms$treatment) arms[arms$treatment == "UC",] else arms[1,,drop=FALSE]
    acts <- arms[arms$treatment != ref$treatment, ]
    lapply(seq_len(nrow(acts)), function(i) {
      a <- acts[i,]; r <- ref
      p1 <- (a$responders+.5)/(a$sampleSize+.5)
      p2 <- (r$responders+.5)/(r$sampleSize+.5)
      lRR <- log(p1/p2)
      sRR <- sqrt(1/a$responders - 1/a$sampleSize + 1/r$responders - 1/r$sampleSize)
      df2 <- data.frame(study=s, treat1=a$treatment, treat2=r$treatment,
                        TE=lRR, seTE=sRR, stringsAsFactors=FALSE)
      for (col in c("setting","region","pim_criteria")) {
        if (col %in% names(a)) df2[[col]] <- a[[col]]
      }
      df2
    })
  })
  do.call(rbind, Filter(Negate(is.null), unlist(rows, recursive=FALSE)))
}

run_nma_freq <- function(nma_data, label, prefix, small_good = TRUE) {
  cat("\n", strrep("-",50), "\n")
  cat("NMA:", label, "| n_comparisons =", nrow(nma_data), "\n")

  nc <- netconnection(nma_data$treat1, nma_data$treat2, nma_data$study)
  if (nc$n.subnets > 1)
    warning("Disconnected network (", nc$n.subnets, " sub-nets) in: ", label)

  net <- tryCatch(
    netmeta(TE, seTE, treat1, treat2, study, data=nma_data,
            sm="RR", random=TRUE, fixed=FALSE,
            method.tau="REML", reference.group=REFERENCE),
    error = function(e) { cat("netmeta error:", conditionMessage(e), "\n"); NULL }
  )
  if (is.null(net)) return(NULL)

  cat(sprintf("  I² = %.1f%% | tau = %.4f\n", net$I2*100, net$tau))

  # Network graph
  tryCatch({
    png(file.path(FIG_DIR, paste0(prefix, "_network.png")), width=9, height=9,
        units="in", res=FIG_DPI)
    netgraph(net, number.of.studies=TRUE, cex.points=5, col.points="steelblue",
             col="grey40", plastic=FALSE, thickness="number.of.studies",
             points=TRUE, offset=0.05, main=paste("Network —", label))
    dev.off()
    cat("  [OK] Network graph:", prefix, "_network.png\n")
  }, error = function(e) cat("  [WARN] netgraph:", conditionMessage(e), "\n"))

  # Forest plot
  tryCatch({
    png(file.path(FIG_DIR, paste0(prefix, "_forest.png")), width=12, height=8,
        units="in", res=FIG_DPI)
    forest(net, reference.group=REFERENCE, sortvar=TE,
           smlab="RR (95% CI)", col.square="steelblue", col.diamond="firebrick",
           main=paste0(label, " — vs. Usual Care"))
    dev.off()
    cat("  [OK] Forest plot:", prefix, "_forest.png\n")
  }, error = function(e) cat("  [WARN] forest:", conditionMessage(e), "\n"))

  # P-scores
  psc   <- netrank(net, small.values=if(small_good) "desirable" else "undesirable")
  ranks <- data.frame(
    Treatment = names(psc$Pscore.random),
    Pscore    = round(psc$Pscore.random, 4)
  ) %>%
    mutate(Label = coalesce(TREAT_LABELS[Treatment], Treatment)) %>%
    arrange(desc(Pscore)) %>%
    mutate(Rank = row_number())

  write_csv(ranks, file.path(TBL_DIR, paste0(prefix, "_rankings.csv")))

  # P-score bar
  p_rank <- ggplot(ranks, aes(x=reorder(Label, Pscore), y=Pscore, fill=Pscore)) +
    geom_col(alpha=.85) +
    geom_text(aes(label=sprintf("%.2f", Pscore)), hjust=-0.1, size=4) +
    coord_flip() +
    scale_y_continuous(limits=c(0,1.25)) +
    scale_fill_gradient(low="#cce5ff", high="#004085", guide="none") +
    labs(title=paste0("Treatment Ranking — ", label),
         subtitle="P-score (netmeta). Higher = better ranking.",
         x=NULL, y="P-score") +
    theme_minimal(base_size=12) +
    theme(panel.grid.major.y=element_blank())

  ggsave(file.path(FIG_DIR, paste0(prefix, "_ranking.png")),
         p_rank, width=10, height=6, dpi=FIG_DPI)
  cat("  [OK] Ranking plot:", prefix, "_ranking.png\n")

  # League table heatmap
  treats <- TREAT_ORDER[TREAT_ORDER %in% unique(c(nma_data$treat1, nma_data$treat2))]
  pairs_df <- expand.grid(row_t=treats, col_t=treats, stringsAsFactors=FALSE) %>%
    filter(row_t != col_t)
  pairs_df$RR <- pairs_df$lCI <- pairs_df$uCI <- NA_real_
  for (i in seq_len(nrow(pairs_df))) {
    t1 <- pairs_df$row_t[i]; t2 <- pairs_df$col_t[i]
    idx <- which(net$treat1==t1 & net$treat2==t2)
    if (length(idx)) {
      pairs_df$RR[i]  <- exp(net$TE.random[idx])
      pairs_df$lCI[i] <- exp(net$lower.random[idx])
      pairs_df$uCI[i] <- exp(net$upper.random[idx])
    } else {
      idx2 <- which(net$treat1==t2 & net$treat2==t1)
      if (length(idx2)) {
        pairs_df$RR[i]  <- exp(-net$TE.random[idx2])
        pairs_df$lCI[i] <- exp(-net$upper.random[idx2])
        pairs_df$uCI[i] <- exp(-net$lower.random[idx2])
      }
    }
  }
  pairs_df <- pairs_df %>% filter(!is.na(RR)) %>%
    mutate(label_row = factor(coalesce(TREAT_LABELS[row_t], row_t),
                              levels=rev(coalesce(TREAT_LABELS[treats], treats))),
           label_col = factor(coalesce(TREAT_LABELS[col_t], col_t),
                              levels=coalesce(TREAT_LABELS[treats], treats)),
           cell_text = sprintf("%.2f\n(%.2f–%.2f)", RR, lCI, uCI))

  if (nrow(pairs_df) > 0) {
    p_league <- ggplot(pairs_df, aes(x=label_col, y=label_row, fill=log(RR))) +
      geom_tile(colour="white", linewidth=.5) +
      geom_text(aes(label=cell_text), size=3, lineheight=.9) +
      scale_fill_gradient2(low="#1565C0", mid="white", high="#C62828",
                           midpoint=0, limits=c(-1.5,1.5), name="log(RR)") +
      labs(title=paste0("League Table — ", label),
           subtitle="RR (95% CI): row vs. column. Blue=row favoured, Red=column favoured.",
           x=NULL, y=NULL) +
      theme_minimal(base_size=11) +
      theme(axis.text.x=element_text(angle=30, hjust=1, face="bold"),
            axis.text.y=element_text(face="bold"))
    ggsave(file.path(FIG_DIR, paste0(prefix, "_league.png")),
           p_league, width=9, height=7, dpi=FIG_DPI)
    cat("  [OK] League table:", prefix, "_league.png\n")
  }

  list(net=net, ranks=ranks, i2=net$I2, label=label, prefix=prefix)
}

subgroup_analysis <- function(nma_data, result, var="setting",
                               levels_list=c("Institutionalized","Community")) {
  if (!result$triggered) return(invisible(NULL))
  cat("\n  >> Subgroup analysis triggered (I² =",
      sprintf("%.1f%%", result$i2*100), "):", result$label, "by", var, "\n")

  sg_ranks_list <- list()
  for (sg in levels_list) {
    sg_d <- nma_data[nma_data[[var]] == sg, ]
    if (nrow(sg_d) < 2) next
    nc <- netconnection(sg_d$treat1, sg_d$treat2, sg_d$study)
    if (nc$n.subnets > 1) {
      cat("  [SKIP] disconnected in subgroup:", sg, "\n"); next
    }
    r <- run_nma_freq(sg_d, paste0(result$label, " | ", sg),
                      paste0(result$prefix, "_", tolower(gsub(" ","_",sg))))
    if (!is.null(r)) sg_ranks_list[[sg]] <- r$ranks %>% mutate(Subgroup=sg)
  }

  if (length(sg_ranks_list) == 2) {
    combined <- bind_rows(sg_ranks_list)
    p_sg <- ggplot(combined, aes(x=reorder(Label, Pscore), y=Pscore, fill=Subgroup)) +
      geom_col(position="dodge", alpha=.85, width=.6) +
      geom_text(aes(label=sprintf("%.2f", Pscore)),
                position=position_dodge(.6), hjust=-0.1, size=3.5) +
      coord_flip() +
      scale_y_continuous(limits=c(0,1.25)) +
      scale_fill_manual(values=c("Institutionalized"="#1976D2","Community"="#F57C00")) +
      labs(title=paste0("Subgroup — ", result$label),
           subtitle=paste0("P-scores: Institutionalized vs. Community"),
           x=NULL, y="P-score", fill="Setting") +
      theme_minimal(base_size=12) +
      theme(panel.grid.major.y=element_blank(), legend.position="bottom")
    ggsave(file.path(FIG_DIR, paste0(result$prefix, "_subgroup_comparison.png")),
           p_sg, width=10, height=6, dpi=FIG_DPI)
    cat("  [OK] Subgroup comparison:", result$prefix, "_subgroup_comparison.png\n")
  }
}

# =============================================================================
# RUN NMA-1: FALLS
# =============================================================================
cat("\n========== NMA-1: FALLS ==========\n")
nma_falls <- arm_to_contrast(raw_falls, "falls")
write_csv(nma_falls, file.path(TBL_DIR, "nma_falls_contrast.csv"))

res_falls <- run_nma_freq(nma_falls, "Falls", "falls")
res_falls$triggered <- !is.null(res_falls) && res_falls$i2 > I2_THRESHOLD

subgroup_analysis(nma_falls, res_falls)

# =============================================================================
# RUN NMA-1: HOSPITALIZATION
# =============================================================================
cat("\n========== NMA-1: HOSPITALIZATION ==========\n")
nma_hosp <- arm_to_contrast(raw_hosp, "hosp")
write_csv(nma_hosp, file.path(TBL_DIR, "nma_hosp_contrast.csv"))

res_hosp <- run_nma_freq(nma_hosp, "Hospitalization", "hosp")
res_hosp$triggered <- !is.null(res_hosp) && res_hosp$i2 > I2_THRESHOLD

subgroup_analysis(nma_hosp, res_hosp)

# =============================================================================
# COMBINED RANKING FIGURE (Falls + Hospitalization)
# =============================================================================
cat("\n--- Combined P-score figure ---\n")
if (!is.null(res_falls) && !is.null(res_hosp)) {
  combined <- bind_rows(
    res_falls$ranks %>% mutate(Outcome="Falls"),
    res_hosp$ranks  %>% mutate(Outcome="Hospitalization")
  )
  p_comb <- ggplot(combined, aes(x=reorder(Label, Pscore), y=Pscore, fill=Outcome)) +
    geom_col(position="dodge", alpha=.85, width=.6) +
    geom_text(aes(label=sprintf("%.0f%%", Pscore*100)),
              position=position_dodge(.6), hjust=-0.1, size=3.3) +
    coord_flip() +
    scale_y_continuous(limits=c(0,1.25), labels=percent_format(1)) +
    scale_fill_manual(values=c("Falls"="#1976D2","Hospitalization"="#388E3C")) +
    labs(title="P-score Rankings — Polypharmacy Interventions",
         subtitle="Falls vs. Hospitalization (frequentist NMA, netmeta)",
         x=NULL, y="P-score", fill="Outcome") +
    theme_minimal(base_size=12) +
    theme(panel.grid.major.y=element_blank(), legend.position="bottom")
  ggsave(file.path(FIG_DIR, "combined_ranking_falls_hosp.png"),
         p_comb, width=11, height=6, dpi=FIG_DPI)
  cat("[OK] combined_ranking_falls_hosp.png\n")
}

# =============================================================================
# RUN NMA-2: PIMs (All, European, Asian)
# =============================================================================
cat("\n========== NMA-2: PIMs ==========\n")
nma_pims_all <- arm_to_contrast(raw_pims, "PIMs")
nma_pims_eu  <- nma_pims_all[nma_pims_all$region == "European", ]
nma_pims_as  <- nma_pims_all[nma_pims_all$region == "Asian",    ]

write_csv(nma_pims_all, file.path(TBL_DIR, "nma_pims_all_contrast.csv"))
write_csv(nma_pims_eu,  file.path(TBL_DIR, "nma_pims_eu_contrast.csv"))
write_csv(nma_pims_as,  file.path(TBL_DIR, "nma_pims_as_contrast.csv"))

res_pims_all <- run_nma_freq(nma_pims_all, "PIMs (All)",      "pims_all")
res_pims_eu  <- run_nma_freq(nma_pims_eu,  "PIMs (European)", "pims_eu")
res_pims_as  <- run_nma_freq(nma_pims_as,  "PIMs (Asian)",    "pims_as")

# Trigger setting-subgroup within each region if I² > 50%
for (r in list(
    list(res=res_pims_all, dat=nma_pims_all),
    list(res=res_pims_eu,  dat=nma_pims_eu),
    list(res=res_pims_as,  dat=nma_pims_as)
  )) {
  if (!is.null(r$res)) {
    r$res$triggered <- r$res$i2 > I2_THRESHOLD
    subgroup_analysis(r$dat, r$res)
  }
}

# Regional comparison
cat("\n--- PIMs regional comparison ---\n")
if (!is.null(res_pims_eu) && !is.null(res_pims_as)) {
  region_df <- bind_rows(
    res_pims_eu$ranks %>% mutate(Region="European"),
    res_pims_as$ranks %>% mutate(Region="Asian")
  )
  write_csv(region_df, file.path(TBL_DIR, "pims_regional_comparison.csv"))

  p_reg <- ggplot(region_df, aes(x=reorder(Label, Pscore), y=Pscore, fill=Region)) +
    geom_col(position="dodge", alpha=.85, width=.6) +
    geom_text(aes(label=sprintf("%.2f", Pscore)),
              position=position_dodge(.6), hjust=-0.1, size=3.5) +
    coord_flip() +
    scale_y_continuous(limits=c(0,1.25)) +
    scale_fill_manual(values=c("European"="#1565C0","Asian"="#B71C1C")) +
    labs(title="PIMs Reduction — Regional Stratified Analysis",
         subtitle="P-scores: European vs. Asian studies",
         x=NULL, y="P-score", fill="Region") +
    theme_minimal(base_size=12) +
    theme(panel.grid.major.y=element_blank(), legend.position="bottom")
  ggsave(file.path(FIG_DIR, "pims_regional_comparison.png"),
         p_reg, width=10, height=6, dpi=FIG_DPI)
  cat("[OK] pims_regional_comparison.png\n")

  # gt table
  tbl_wide <- region_df %>%
    select(Label, Region, Pscore) %>%
    pivot_wider(names_from=Region, values_from=Pscore) %>%
    arrange(desc(European))

  gt_tbl <- tbl_wide %>%
    gt() %>%
    tab_header(title="PIMs Reduction P-scores by Region",
               subtitle="European vs. Asian studies (netmeta)") %>%
    fmt_number(columns=c(European, Asian), decimals=3) %>%
    tab_footnote("Higher P-score = better PIMs reduction rank.",
                 locations=cells_column_labels(columns=2))
  gtsave(gt_tbl, file.path(TBL_DIR, "pims_regional_table.png"), expand=10)
  cat("[OK] pims_regional_table.png\n")
}

# =============================================================================
# SUMMARY
# =============================================================================
elapsed <- round(as.numeric(difftime(Sys.time(), start_time, units="mins")), 1)

cat("\n=======================================================\n")
cat("PIPELINE COMPLETE —", elapsed, "minutes\n")
cat("=======================================================\n")
cat("\n[Figures]\n")
for (f in sort(list.files(FIG_DIR))) cat(" ", f, "\n")
cat("\n[Tables]\n")
for (t in sort(list.files(TBL_DIR))) cat(" ", t, "\n")

cat("\n[Summary]\n")
for (r in list(
  list(label="Falls",            res=res_falls),
  list(label="Hospitalization",  res=res_hosp),
  list(label="PIMs (All)",       res=res_pims_all),
  list(label="PIMs (European)",  res=res_pims_eu),
  list(label="PIMs (Asian)",     res=res_pims_as)
)) {
  if (!is.null(r$res)) {
    cat(sprintf("  %-20s I²=%4.1f%%  Subgroup triggered: %s\n",
                r$label, r$res$i2*100,
                ifelse(isTRUE(r$res$triggered), "YES", "no")))
  }
}
cat("\nNOTE: Replace synthetic data with real extracted data, then re-run.\n")
