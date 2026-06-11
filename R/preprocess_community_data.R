# =============================================================================
# Title:       Community Data Preprocessing
# Description: Imputes missing numeric values with column medians, selects the
#              numeric clustering variables, and z-score scales them.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# Cleaning and Preparation ----------------------------------------------------

clean_community_data <- function(data) {
  numeric_columns <- names(data)[vapply(data, is.numeric, logical(1))]

  for (column in numeric_columns) {
    missing_rows <- is.na(data[[column]])

    if (any(missing_rows)) {
      data[[column]][missing_rows] <- stats::median(data[[column]], na.rm = TRUE)
    }
  }

  data
}

prepare_community_cluster_data <- function(
    data,
    excluded_columns = default_community_excluded_columns()) {
  available_excluded_columns <- intersect(excluded_columns, names(data))
  cluster_data <- data[, !(names(data) %in% available_excluded_columns), drop = FALSE]
  numeric_columns <- vapply(cluster_data, is.numeric, logical(1))
  numeric_data <- cluster_data[, numeric_columns, drop = FALSE]

  if (ncol(numeric_data) == 0) {
    stop("No numeric variables are available for clustering.", call. = FALSE)
  }

  numeric_data
}

scale_community_cluster_data <- function(data) {
  scale(data)
}
