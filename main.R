# =============================================================================
# Title:       Silk Route Spice Community Cluster Analysis
# Description: Orchestrates the full analysis pipeline: load, clean, cluster,
#              interpret, and export all figures and tables.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# Usage:       Run from the project root:
#                Rscript main.R
# =============================================================================

library(stats)
library(utils)

source(file.path("R", "defaults.R"))
source(file.path("R", "load_community_data.R"))
source(file.path("R", "screen_outliers.R"))
source(file.path("R", "preprocess_community_data.R"))
source(file.path("R", "cluster_hierarchical.R"))
source(file.path("R", "cluster_kmeans.R"))
source(file.path("R", "characterise_archetypes.R"))
source(file.path("R", "pipeline_utils.R"))
source(file.path("R", "visualise_archetypes.R"))

# Output Paths ----------------------------------------------------------------

paths <- build_output_paths(getwd())

# Load and Understand ---------------------------------------------------------

raw_data <- load_community_data()
understand_community_data(raw_data)

# Data Cleaning ---------------------------------------------------------------

cleaned_data    <- clean_community_data(raw_data)
missing_summary <- build_missing_values_summary(
  count_missing_values(raw_data),
  count_missing_values(cleaned_data)
)

# Outlier Screening -----------------------------------------------------------

outlier_summary <- summarise_numeric_outliers(cleaned_data)

# Data Preparation ------------------------------------------------------------

scaled_data <- scale_community_cluster_data(
  prepare_community_cluster_data(cleaned_data)
)

# Hierarchical Clustering -----------------------------------------------------

hierarchical <- run_hierarchical_clustering(scaled_data)

# K-Means Clustering ----------------------------------------------------------

elbow_wss         <- calculate_cluster_elbow_wss(scaled_data)
silhouette_scores <- calculate_silhouette_scores(scaled_data)
k_means_model     <- run_k_means_clustering(scaled_data, centers = 4)

# Cluster Interpretation ------------------------------------------------------

clustered_data  <- assign_clusters(cleaned_data, k_means_model)
cluster_summary <- build_cluster_summary(clustered_data)
profile_means   <- calculate_cluster_profile_means(clustered_data)
full_profile    <- calculate_full_cluster_profile(clustered_data)
dominant_cats   <- calculate_dominant_cluster_categories(clustered_data)

# Export Figures --------------------------------------------------------------

export_figures(paths, hierarchical, elbow_wss, silhouette_scores, profile_means)

# Export Tables ---------------------------------------------------------------

export_tables(paths, cluster_summary, full_profile, dominant_cats,
              missing_summary, outlier_summary, silhouette_scores)

message("Figures written to: ", paths$figures_dir)
message("Tables written to:  ", paths$tables_dir)
