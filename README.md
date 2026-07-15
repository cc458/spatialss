# spatialss: Spatial Analysis for Social Sciences

Companion R package for the textbook **《社会科学的空间分析》** (Spatial Analysis for Social Sciences) by Chong Chen.

## Installation

### 方法一：从 GitHub 安装（推荐）

```r
library(remotes)
install_github("cc458/spatialss", build_vignettes = TRUE)
library(spatialss)
```

### 方法二：从源文件安装

如果 GitHub 下载遇到网络问题，可以从 [Releases 页面](https://github.com/cc458/spatialss/releases) 下载 `.tar.gz` 源文件，然后在 R 中安装：

```r
# 安装下载的 tar.gz 文件（替换为实际路径）
install.packages("spatialss_0.1.0.tar.gz", repos = NULL, type = "source")
library(spatialss)
```

### 方法三：使用 Git 克隆后本地安装

```bash
git clone https://github.com/cc458/spatialss.git
cd spatialss
R CMD build .
R CMD INSTALL spatialss_0.1.0.tar.gz
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

## Chapter Vignettes

Each book chapter has a corresponding vignette with executable R code:

```r
# List all vignettes
vignette(package = "spatialss")

# Open a specific chapter vignette
vignette("chapter01_introduction", package = "spatialss")
vignette("chapter02_visualization", package = "spatialss")
vignette("chapter05_spatial_weight", package = "spatialss")
```

Vignettes use package functions (`load_sichuan()`, `load_nightlights()`, etc.) instead of direct file paths, making the code portable and self-contained.

## License

MIT License. See [LICENSE](LICENSE) for details.
