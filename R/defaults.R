# =============================================================================
# Title:       Shared Defaults
# Description: Named default functions used across multiple pipeline stages.
#              Centralising them here avoids scattered literals and makes
#              overrides explicit at every call site.
# Author:      Gajalakshmi Sasidharan, Rajeswari Paltur
#              Frankfurt University of Applied Sciences
# Date:        2026-06-11
# =============================================================================

# Defaults --------------------------------------------------------------------

default_community_excluded_columns <- function() {
  c("Community_ID", "Region", "Dominant_Spice_Type")
}

default_cluster_profile_columns <- function() {
  c(
    "Altitude_Meters",
    "Avg_Annual_Rainfall_MM",
    "Soil_Organic_Matter_Percent",
    "Water_Source_Reliability_Index",
    "Traditional_Methods_Adherence_Score",
    "Storage_Capacity_Index",
    "Export_Potential_Score",
    "Avg_Literacy_Rate_Percent",
    "Online_Sales_Channel_Usage_Percent"
  )
}

default_archetype_names <- function() {
  c(
    "1" = "Digital Market Connectors",
    "2" = "Lowland Volume Producers",
    "3" = "High-Altitude Artisan Specialists",
    "4" = "Infrastructure-Constrained Traditional Communities"
  )
}
