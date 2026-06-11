# =============================================================================
# Title:       K-Means Clustering
# Description: Runs k-means with 25 random starts, calculates within-cluster
#              sum of squares for the elbow method, and computes average
#              silhouette scores to validate the chosen cluster count.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# K-Means Clustering ----------------------------------------------------------

calculate_cluster_elbow_wss <- function(
    scaled_data,
    max_clusters = 10,
    seed = 123,
    nstart = 25) {
  set.seed(seed)

  vapply(seq_len(max_clusters), function(k) {
    stats::kmeans(scaled_data, centers = k, nstart = nstart)$tot.withinss
  }, numeric(1))
}

.calculate_average_silhouette <- function(distance_matrix, clusters) {
  clusters <- as.integer(clusters)
  cluster_levels <- sort(unique(clusters))
  distances <- as.matrix(distance_matrix)

  silhouette_values <- vapply(seq_along(clusters), function(i) {
    own_cluster  <- clusters[i]
    same_cluster <- which(clusters == own_cluster)
    same_cluster <- same_cluster[same_cluster != i]

    a_value <- if (length(same_cluster) == 0) {
      0
    } else {
      mean(distances[i, same_cluster])
    }

    other_cluster_distances <- vapply(
      cluster_levels[cluster_levels != own_cluster],
      function(cluster) mean(distances[i, clusters == cluster]),
      numeric(1)
    )
    b_value     <- min(other_cluster_distances)
    denominator <- max(a_value, b_value)

    if (denominator == 0) 0 else (b_value - a_value) / denominator
  }, numeric(1))

  mean(silhouette_values)
}

calculate_silhouette_scores <- function(
    scaled_data,
    min_clusters = 2,
    max_clusters = 10,
    seed = 123,
    nstart = 25) {
  distance_matrix <- stats::dist(scaled_data)
  cluster_counts  <- min_clusters:max_clusters

  data.frame(
    Clusters = cluster_counts,
    Average_Silhouette = vapply(cluster_counts, function(k) {
      model <- run_k_means_clustering(scaled_data, centers = k, seed = seed, nstart = nstart)
      .calculate_average_silhouette(distance_matrix, model$cluster)
    }, numeric(1))
  )
}

run_k_means_clustering <- function(
    scaled_data,
    centers = 4,
    seed = 123,
    nstart = 25) {
  set.seed(seed)
  stats::kmeans(scaled_data, centers = centers, nstart = nstart)
}
