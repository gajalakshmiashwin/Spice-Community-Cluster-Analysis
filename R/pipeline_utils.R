# =============================================================================
# Title:       Pipeline Utility Functions
# Description: Thin assembly and I/O helpers that connect pipeline stages:
#              assigns cluster labels, builds summary tables, constructs output
#              paths, and writes figures and CSVs to disk.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# Pipeline Utilities ----------------------------------------------------------

assign_clusters <- function(data, kmeans_model) {
  data$Cluster <- kmeans_model$cluster
  data
}

build_missing_values_summary <- function(missing_before, missing_after) {
  data.frame(
    Variable       = names(missing_before),
    Missing_Before = as.integer(missing_before),
    Missing_After  = as.integer(missing_after),
    stringsAsFactors = FALSE
  )
}

build_cluster_summary <- function(clustered_data) {
  sizes      <- calculate_cluster_sizes(clustered_data)
  profile    <- calculate_full_cluster_profile(clustered_data)
  categories <- calculate_dominant_cluster_categories(clustered_data)

  summary <- Reduce(
    function(left, right) merge(left, right, by = "Cluster", all.x = TRUE),
    list(sizes, profile, categories)
  )
  summary <- add_cluster_archetype_names(summary)
  summary[c(
    "Cluster", "Archetype", "Community_Count",
    setdiff(names(summary), c("Cluster", "Archetype", "Community_Count"))
  )]
}

build_output_paths <- function(root_dir) {
  output_dir  <- file.path(root_dir, "outputs")
  figures_dir <- file.path(output_dir, "figures")
  tables_dir  <- file.path(output_dir, "tables")
  dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(tables_dir,  recursive = TRUE, showWarnings = FALSE)

  list(
    figures_dir          = figures_dir,
    tables_dir           = tables_dir,
    combined_plots       = file.path(figures_dir, "community_cluster_analysis_plots.pdf"),
    dendrogram           = file.path(figures_dir, "hierarchical_dendrogram.pdf"),
    elbow_plot           = file.path(figures_dir, "kmeans_elbow_plot.pdf"),
    cluster_profile      = file.path(figures_dir, "cluster_profile_plot.pdf"),
    silhouette_plot      = file.path(figures_dir, "kmeans_silhouette_plot.pdf"),
    cluster_summary      = file.path(tables_dir,  "cluster_summary.csv"),
    full_cluster_profile = file.path(tables_dir,  "full_cluster_profile.csv"),
    dominant_categories  = file.path(tables_dir,  "cluster_dominant_categories.csv"),
    missing_values       = file.path(tables_dir,  "missing_values_summary.csv"),
    outlier_summary      = file.path(tables_dir,  "outlier_summary.csv"),
    silhouette_scores    = file.path(tables_dir,  "silhouette_scores.csv")
  )
}

write_pdf <- function(path, plot_code, width = 7.2, height = 5.2) {
  pdf(path, width = width, height = height)
  on.exit(dev.off(), add = TRUE)
  force(plot_code)
}

export_figures <- function(paths, hierarchical, elbow_wss, silhouette_scores, profile_means) {
  write_pdf(
    paths$combined_plots,
    {
      plot_community_dendrogram(hierarchical$hierarchical_model)
      plot_cluster_elbow(elbow_wss)
      plot_silhouette_scores(silhouette_scores)
      plot_cluster_profile(profile_means)
    }
  )
  write_pdf(paths$dendrogram,      plot_community_dendrogram(hierarchical$hierarchical_model), width = 6.5, height = 4.6)
  write_pdf(paths$elbow_plot,      plot_cluster_elbow(elbow_wss),                              width = 6.5, height = 4.6)
  write_pdf(paths$cluster_profile, plot_cluster_profile(profile_means),                        width = 8.5, height = 7.2)
  write_pdf(paths$silhouette_plot, plot_silhouette_scores(silhouette_scores),                  width = 6.5, height = 4.6)
}

export_tables <- function(paths, cluster_summary, full_profile, dominant_cats,
                          missing_summary, outlier_summary, silhouette_scores) {
  utils::write.csv(cluster_summary,   paths$cluster_summary,      row.names = FALSE)
  utils::write.csv(full_profile,      paths$full_cluster_profile, row.names = FALSE)
  utils::write.csv(dominant_cats,     paths$dominant_categories,  row.names = FALSE)
  utils::write.csv(missing_summary,   paths$missing_values,       row.names = FALSE)
  utils::write.csv(outlier_summary,   paths$outlier_summary,      row.names = FALSE)
  utils::write.csv(silhouette_scores, paths$silhouette_scores,    row.names = FALSE)
}
