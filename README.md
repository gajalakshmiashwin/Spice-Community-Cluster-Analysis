# Silk Route Community Cluster Analysis

Spice Community Archetype Report — Operation Spice Route Compass.
Frankfurt University of Applied Sciences, 2026.

Loads the Silk Route spice community dataset, cleans missing values, screens
outliers, scales variables, runs hierarchical clustering and k-means, validates
the cluster count with elbow and silhouette checks, and summarises four targeted
community archetypes for addressing "Aroma Drift."

## Prerequisites

- R ≥ 4.2 (base packages only: `stats`, `utils`)

## Project Structure

```
spice-cluster-analysis/
├── data/
│   └── silk_route_spice_data.csv      # raw input — read-only
├── R/
│   ├── defaults.R                     # shared default constant functions
│   ├── load_community_data.R          # data loading, structure summary, missing-value count
│   ├── screen_outliers.R              # 1.5 IQR outlier screening
│   ├── preprocess_community_data.R    # median imputation, variable selection, z-score scaling
│   ├── cluster_hierarchical.R         # Ward's D2 hierarchical clustering
│   ├── cluster_kmeans.R               # elbow WSS, silhouette scores, k-means run
│   ├── characterise_archetypes.R      # cluster means, sizes, categories, archetype labels
│   ├── pipeline_utils.R               # assembly helpers, output paths, export wrappers
│   └── visualise_archetypes.R         # dendrogram, elbow, silhouette, profile plots
├── outputs/
│   ├── figures/                       # generated plot PDFs
│   └── tables/                        # generated CSV tables
├── reports/
│   └── Community_Cluster_Report.pdf   # compiled final report
├── main.R                             # single entry point — runs full pipeline
└── README.md
```

## How to Run

From the project root:

```sh
Rscript main.R
```

## Outputs

All outputs are written by `main.R`. Figures go to `outputs/figures/`;
tables go to `outputs/tables/`.

**Figures (`outputs/figures/`)**

| File | Description |
|------|-------------|
| `community_cluster_analysis_plots.pdf` | Combined multi-page analysis plots |
| `hierarchical_dendrogram.pdf` | Hierarchical clustering dendrogram |
| `kmeans_elbow_plot.pdf` | K-means elbow plot |
| `kmeans_silhouette_plot.pdf` | K-means silhouette validation |
| `cluster_profile_plot.pdf` | Selected-variable cluster profile |

**Tables (`outputs/tables/`)**

| File | Description |
|------|-------------|
| `cluster_summary.csv` | Cluster overview with archetype names and dominant categories |
| `full_cluster_profile.csv` | All 20 numeric variable means per cluster |
| `cluster_dominant_categories.csv` | Dominant region and spice type per cluster |
| `missing_values_summary.csv` | Missing-value counts before and after cleaning |
| `outlier_summary.csv` | IQR-based outlier screening per variable |
| `silhouette_scores.csv` | Average silhouette score for each tested cluster count |

## Report

The compiled report is committed at `reports/Community_Cluster_Report.pdf`.
