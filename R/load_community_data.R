# =============================================================================
# Title:       Community Data Loading and Understanding
# Description: Reads the community CSV from disk, prints a structural summary,
#              and counts missing values per column.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# Data Loading and Understanding ----------------------------------------------

load_community_data <- function(
    data_path = file.path("data", "silk_route_spice_data.csv")) {
  if (!file.exists(data_path)) {
    stop(
      "Could not find the community dataset at: ",
      normalizePath(data_path, mustWork = FALSE),
      call. = FALSE
    )
  }

  utils::read.csv(data_path, stringsAsFactors = FALSE)
}

understand_community_data <- function(data) {
  structure_output <- capture.output(str(data))
  summary_output <- summary(data)

  cat(paste(structure_output, collapse = "\n"), "\n")
  print(summary_output)

  invisible(list(
    structure = structure_output,
    summary = summary_output
  ))
}

count_missing_values <- function(data) {
  colSums(is.na(data))
}
