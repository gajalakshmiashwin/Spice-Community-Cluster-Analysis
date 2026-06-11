# =============================================================================
# Title:       Hierarchical Clustering
# Description: Computes a Euclidean distance matrix and applies Ward's D2
#              linkage to produce a dendrogram for exploratory validation.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# Hierarchical Clustering -----------------------------------------------------

run_hierarchical_clustering <- function(scaled_data) {
  distance_matrix    <- stats::dist(scaled_data)
  hierarchical_model <- stats::hclust(distance_matrix, method = "ward.D2")

  list(
    distance_matrix    = distance_matrix,
    hierarchical_model = hierarchical_model
  )
}
