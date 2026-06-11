# =============================================================================
# Title:       Archetype Characterisation
# Description: Computes per-cluster means, sizes, dominant categories, and
#              archetype labels from a clustered community dataset.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# Cluster Interpretation ------------------------------------------------------

calculate_full_cluster_profile <- function(clean_data) {
  if (!("Cluster" %in% names(clean_data))) {
    stop("The data must contain a Cluster column.", call. = FALSE)
  }

  numeric_columns <- names(clean_data)[vapply(clean_data, is.numeric, logical(1))]
  numeric_columns <- setdiff(numeric_columns, "Cluster")

  stats::aggregate(
    clean_data[, numeric_columns],
    by = list(Cluster = clean_data$Cluster),
    mean
  )
}

calculate_cluster_sizes <- function(clean_data) {
  cluster_table <- table(clean_data$Cluster)

  data.frame(
    Cluster         = as.integer(names(cluster_table)),
    Community_Count = as.integer(cluster_table),
    stringsAsFactors = FALSE
  )
}

calculate_dominant_cluster_categories <- function(
    clean_data,
    categorical_columns = c("Region", "Dominant_Spice_Type")) {
  missing_columns <- setdiff(c("Cluster", categorical_columns), names(clean_data))

  if (length(missing_columns) > 0) {
    stop(
      "Missing required categorical columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  clusters <- sort(unique(clean_data$Cluster))
  category_rows <- lapply(clusters, function(cluster) {
    cluster_data <- clean_data[clean_data$Cluster == cluster, , drop = FALSE]
    result <- data.frame(Cluster = cluster)

    for (column in categorical_columns) {
      counts <- sort(table(cluster_data[[column]]), decreasing = TRUE)
      result[[paste0("Dominant_", column)]]        <- names(counts)[1]
      result[[paste0("Dominant_", column, "_Count")]] <- as.integer(counts[[1]])
    }

    result
  })

  do.call(rbind, category_rows)
}

add_cluster_archetype_names <- function(
    data,
    archetype_names = default_archetype_names()) {
  if (!("Cluster" %in% names(data))) {
    stop("The data must contain a Cluster column.", call. = FALSE)
  }

  cluster_key   <- as.character(data$Cluster)
  data$Archetype <- unname(archetype_names[cluster_key])
  data
}

calculate_cluster_profile_means <- function(
    clean_data,
    profile_columns = default_cluster_profile_columns()) {
  missing_columns <- setdiff(c("Cluster", profile_columns), names(clean_data))

  if (length(missing_columns) > 0) {
    stop(
      "Missing required profile columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  stats::aggregate(
    clean_data[, profile_columns],
    by = list(Cluster = clean_data$Cluster),
    mean
  )
}
