# =============================================================================
# nma_03_network_graph.R — Network Geometry Visualization
# =============================================================================
# Generates network plots for both Falls and Hospitalization outcomes.
# =============================================================================

source("nma_02_data_prep.R")

plot_network <- function(nma_data, outcome_label, filename_prefix,
                         reference = REFERENCE_NODE) {
  cat("\n=== Network graph:", outcome_label, "===\n")

  # Check connectivity
  nc <- netconnection(nma_data$treat1, nma_data$treat2, nma_data$study)
  cat("Sub-networks:", nc$n.subnets, "\n")

  if (nc$n.subnets > 1) {
    warning("DISCONNECTED NETWORK for ", outcome_label,
            " — ", nc$n.subnets, " sub-networks. Check data.")
  }

  # Fit for graph geometry (frequentist — fast)
  net_g <- netmeta(TE, seTE, treat1, treat2, study,
                   data      = nma_data,
                   sm        = "RR",
                   random    = TRUE,
                   fixed     = FALSE,
                   method.tau= "REML",
                   reference.group = reference)

  # --- Network plot ---
  png(file.path(FIG_DIR, paste0(filename_prefix, "_network_graph.png")),
      width = 10, height = 10, units = "in", res = FIG_DPI)

  netgraph(net_g,
           seq              = "optimal",
           number.of.studies= TRUE,
           cex.points       = 5,
           col.points       = "steelblue",
           col              = "grey40",
           plastic          = FALSE,
           thickness        = "number.of.studies",
           multiarm         = FALSE,
           points           = TRUE,
           cex.number       = 1.2,
           offset           = 0.05,
           main             = paste("Network of Polypharmacy Interventions —",
                                    outcome_label))
  dev.off()
  cat("Network graph saved:", file.path(FIG_DIR,
      paste0(filename_prefix, "_network_graph.png")), "\n")

  # --- Edge summary ---
  cat("\n--- Edge Summary ---\n")
  edge_counts <- nma_data %>%
    group_by(treat1, treat2) %>%
    summarise(n_studies = n(), .groups = "drop")
  print(as.data.frame(edge_counts))

  # Node degree
  cat("\n--- Node Degree (number of direct comparisons) ---\n")
  node_degree <- table(c(nma_data$treat1, nma_data$treat2))
  print(sort(node_degree, decreasing = TRUE))

  invisible(net_g)
}

# --- Falls ---
net_falls <- plot_network(nma_falls, "Falls", "falls")

# --- Hospitalization ---
net_hosp  <- plot_network(nma_hosp,  "Hospitalization", "hosp")

cat("\nNetwork graph generation complete.\n")
