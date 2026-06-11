# =============================================================================
# Title:       Archetype Visualisation
# Description: Plotting functions for the dendrogram, elbow curve, silhouette
#              scores, and multi-cluster profile comparison.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# Visualisation ---------------------------------------------------------------

plot_community_dendrogram <- function(hierarchical_model) {
  plot(
    hierarchical_model,
    labels = FALSE,
    main   = "Hierarchical Clustering Dendrogram",
    xlab   = "Communities",
    ylab   = "Distance"
  )
}

plot_cluster_elbow <- function(elbow_wss) {
  plot(
    seq_along(elbow_wss),
    elbow_wss,
    type = "b",
    xlab = "Number of clusters",
    ylab = "Within-cluster sum of squares",
    main = "Elbow Method for K-Means"
  )
}

plot_silhouette_scores <- function(silhouette_scores) {
  plot(
    silhouette_scores$Clusters,
    silhouette_scores$Average_Silhouette,
    type = "b",
    xlab = "Number of clusters",
    ylab = "Average silhouette score",
    main = "Silhouette Validation for K-Means"
  )
  abline(v = 4, lty = 2, col = "gray60")
}

plot_cluster_profile <- function(
    profile_means,
    profile_columns = default_cluster_profile_columns()) {
  missing_columns <- setdiff(c("Cluster", profile_columns), names(profile_means))

  if (length(missing_columns) > 0) {
    stop(
      "Missing required profile columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  scaled_profile <- scale(profile_means[, profile_columns])

  par(mar = c(10, 4.5, 4, 8))
  matplot(
    t(scaled_profile),
    type = "b",
    pch  = seq_len(nrow(profile_means)),
    lty  = 1,
    xaxt = "n",
    xlab = "",
    ylab = "Relative cluster level",
    main = "Cluster Profiles Based on Selected Variables"
  )
  axis_labels <- gsub("_", " ", profile_columns)
  axis_labels <- gsub("Percent", "%", axis_labels)
  axis_labels <- gsub("Avg ", "Avg. ", axis_labels)
  axis_labels <- gsub("Annual ", "", axis_labels)
  axis_labels <- gsub("Online Sales Channel Usage", "Online Sales", axis_labels)
  axis_labels <- gsub("Traditional Methods Adherence Score", "Traditional Methods", axis_labels)
  axis_labels <- gsub("Water Source Reliability Index", "Water Reliability", axis_labels)
  axis(1, at = seq_along(profile_columns), labels = axis_labels, las = 2)
  abline(h = 0, lty = 2, col = "gray60")
  legend(
    x      = par("usr")[2],
    y      = mean(par("usr")[3:4]),
    xpd    = TRUE,
    yjust  = 0.5,
    legend = paste("Cluster", profile_means$Cluster),
    col    = seq_len(nrow(profile_means)),
    pch    = seq_len(nrow(profile_means)),
    lty    = 1,
    bty    = "n"
  )
}
