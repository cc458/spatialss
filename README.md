# spatialss: Spatial Analysis for Social Sciences

Companion R package for the textbook **《社会科学的空间分析》** (Spatial Analysis for Social Sciences) by Chong Chen.

## Installation

```r
library(remotes)
install_github("cc458/spatialss")
library(spatialss)
```

## Data Overview

The package includes all datasets needed to reproduce the book's analyses:

| Chapter | Topic | Key Datasets |
|---------|-------|-------------|
| Ch 2 | Spatial Visualization | Sichuan admin boundaries, Iraq governorates, nighttime lights, curfew maps |
| Ch 3 | Coordinate Systems | World countries, Sichuan cities, raster examples |
| Ch 4 | Spatial Operations | US Georgia election data, Africa conflict grids, UCDP GED events |
| Ch 5 | Spatial Weights | UN voting agreement scores |
| Ch 6 | Spatial Models | Military spending (monadic), distance weights matrix |
| Ch 7 | Spatial Panel | Chen CJIP panel data, distance weights |
| Ch 8 | Spatial Causal | Kenya Luhya RDD data, Palestine RDD data |
| Ch 9 | Other Models | Military spending, distance weights |

## Usage

```r
library(spatialss)

# List all available data
spatialss_list_data()

# Get path to data directory
spatialss_data()

# Load specific datasets
sichuan <- load_sichuan()
nightlights <- load_nightlights()
ged <- load_ged()

# Load data for a specific chapter
coords <- load_sichuan_coords()
```

## License

MIT License. See [LICENSE](LICENSE) for details.
