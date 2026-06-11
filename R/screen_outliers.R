# =============================================================================
# Title:       Outlier Screening for Community Data
# Description: Screens numeric variables for outliers using the 1.5 IQR rule
#              and returns a summary table of flagged observations per variable.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# Outlier Screening -----------------------------------------------------------

summarise_numeric_outliers <- function(data) {
  numeric_columns <- names(data)[vapply(data, is.numeric, logical(1))]

  outlier_rows <- lapply(numeric_columns, function(column) {
    values <- data[[column]]
    quartiles <- stats::quantile(values, probs = c(0.25, 0.75), na.rm = TRUE)
    iqr_value <- stats::IQR(values, na.rm = TRUE)
    lower_bound <- quartiles[[1]] - 1.5 * iqr_value
    upper_bound <- quartiles[[2]] + 1.5 * iqr_value
    outlier_count <- sum(values < lower_bound | values > upper_bound, na.rm = TRUE)

    data.frame(
      Variable       = column,
      Minimum        = min(values, na.rm = TRUE),
      Q1             = quartiles[[1]],
      Median         = stats::median(values, na.rm = TRUE),
      Q3             = quartiles[[2]],
      Maximum        = max(values, na.rm = TRUE),
      Lower_Bound    = lower_bound,
      Upper_Bound    = upper_bound,
      Outlier_Count  = outlier_count,
      Outlier_Percent = round(100 * outlier_count / length(values), 2),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, outlier_rows)
}
