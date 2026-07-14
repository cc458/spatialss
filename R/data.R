#' Get path to package extdata directory
#'
#' Returns the file path to the `inst/extdata` directory where
#' raw data files (shapefiles, rasters, etc.) are stored.
#'
#' @param ... Character vector of path components appended to the base path.
#' @return Character string with the full file path.
#' @export
#'
#' @examples
#' spatialss_data()
#' spatialss_data("sichuan2022.geojson")
spatialss_data <- function(...) {
  system.file("extdata", ..., package = "spatialss", mustWork = TRUE)
}

#' List all available datasets
#'
#' Lists all datasets bundled with the spatialss package,
#' organized by data type.
#'
#' @return Invisibly returns a list of file paths. Prints a summary
#'   to the console.
#' @export
#'
#' @examples
#' spatialss_list_data()
spatialss_list_data <- function() {
  extdata <- spatialss_data()
  all_files <- list.files(extdata, recursive = TRUE, include.dirs = FALSE)
  cat("spatialss package data files (", length(all_files), " total):\n", sep = "")
  cat("Base path:", extdata, "\n\n")

  # Group by directory
  dirs <- unique(dirname(all_files))
  for (d in sort(dirs)) {
    if (d == ".") {
      files <- all_files[dirname(all_files) == "."]
      cat("-- Root extdata (", length(files), " files) --\n", sep = "")
    } else {
      files <- all_files[dirname(all_files) == d]
      cat("-- ", d, " (", length(files), " files) --\n", sep = "")
    }
    for (f in sort(files)) {
      cat("  ", f, "\n", sep = "")
    }
  }

  invisible(all_files)
}

#' Load Sichuan province spatial data (Chapter 2)
#'
#' Loads the Sichuan province administrative boundary data with
#' 2022 export statistics for 21 prefecture-level cities.
#'
#' @return An sf object with 21 rows and columns including
#'   Region, export22, and geometry.
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' sichuan <- load_sichuan()
#' ggplot(sichuan) + geom_sf(aes(fill = export22))
#' }
load_sichuan <- function() {
  sf::read_sf(spatialss_data("sichuan2022.geojson"), quiet = TRUE)
}

#' Load Sichuan city coordinates (Chapter 2)
#'
#' Returns a data frame with city names and longitude/latitude
#' coordinates for 21 prefecture-level cities in Sichuan.
#'
#' @return A data.frame with columns: City, Lon, Lat.
#' @export
load_sichuan_coords <- function() {
  readxl::read_xlsx(spatialss_data("sichuan_coord.xlsx"))
}

#' Load Iraq governorate boundaries (Chapter 2)
#'
#' Returns the Iraq governorate-level administrative boundaries.
#'
#' @return An sf object with 18 governorates.
#' @export
load_iraq_gov <- function() {
  sf::read_sf(spatialss_data("iraq.gpkg"), quiet = TRUE)
}

#' Load nighttime lights raster (Chapters 2-4)
#'
#' Loads the harmonized global nighttime lights dataset for 2015,
#' cropped or full-resolution depending on parameters.
#'
#' @param crop_to Character or NULL. If "sichuan", returns the
#'   Sichuan-cropped version. If NULL, returns the full dataset.
#' @return A RasterLayer object.
#' @export
load_nightlights <- function(crop_to = NULL) {
  if (!is.null(crop_to) && crop_to == "sichuan") {
    raster::raster(spatialss_data("light_sc.tif"))
  } else {
    raster::raster(spatialss_data("Harmonized_DN_NTL_2015_simVIIRS.tif"))
  }
}

#' Load Iraq curfew/no-curfew map data (Chapter 2)
#'
#' Returns point data for ISIS violence incidents before (no curfew)
#' and during (curfew) COVID-19 lockdowns in Iraq.
#'
#' @param type Character. "no_curfew" or "curfew".
#' @return A data.frame with longitude and latitude columns.
#' @export
load_iraq_curfew <- function(type = c("no_curfew", "curfew")) {
  type <- match.arg(type)
  fname <- if (type == "no_curfew") "no.curf.map.Rdata" else "curf.map.Rdata"
  env <- new.env()
  load(spatialss_data(fname), envir = env)
  env[[ls(env)[1]]]
}

#' Load US Georgia election data (Chapter 4)
#'
#' Returns the US Georgia 2012/2014 election spatial datasets.
#'
#' @param dataset Character. One of "vtd", "gred", "hexgrid".
#' @return An sf object.
#' @export
load_georgia <- function(dataset = c("vtd", "gred", "hexgrid")) {
  dataset <- match.arg(dataset)
  fname <- switch(dataset,
    vtd = "VTD_USA_GA_2012_PCT_wgs.geojson",
    gred = "GRED_USA_GA_2014_CST_wgs.geojson",
    hexgrid = "HEXGRID_USA_GA_2014_HEX05_wgs.geojson"
  )
  sf::read_sf(spatialss_data("USA", fname), quiet = TRUE)
}

#' Load Africa boundary/conflict grid data (Chapter 4)
#'
#' Returns the Qiu Africa spatial datasets: land boundary,
#' grid cells, and conflict PCS data.
#'
#' @param dataset Character. One of "boundary", "grid", "pcs".
#' @return An sf object.
#' @export
load_africa_grid <- function(dataset = c("boundary", "grid", "pcs")) {
  dataset <- match.arg(dataset)
  fname <- switch(dataset,
    boundary = "Africa_landboundary.shp",
    grid = "grid_05x05.shp",
    pcs = "PCS.shp"
  )
  sf::read_sf(spatialss_data("qiu_data", fname), quiet = TRUE)
}

#' Load UCDP conflict events data (Chapter 4)
#'
#' Returns the UCDP Georeferenced Event Dataset (GED) version 23.1.
#'
#' @return A data.frame with conflict event records.
#' @export
load_ged <- function() {
  readRDS(spatialss_data("GEDEvent_v23_1.rds"))
}

#' Load UN voting agreement scores (Chapter 5)
#'
#' Returns UN General Assembly voting agreement scores.
#'
#' @return A data.frame.
#' @export
load_un_votes <- function() {
  env <- new.env()
  load(spatialss_data("AgreementScoresAll_Sep2023.Rdata"), envir = env)
  env[[ls(env)[1]]]
}

#' Load military expenditure data (Chapters 6, 9)
#'
#' Returns the monadic military spending SLX dataset.
#'
#' @return A data.frame (tibble).
#' @export
load_military_spending <- function() {
  haven::read_dta(spatialss_data("Military Spending--Monadic--SLX.dta"))
}

#' Load distance-based spatial weights matrix (Chapters 6, 7)
#'
#' Returns a pre-computed distance-based spatial weights matrix.
#'
#' @return A listw object or matrix.
#' @export
load_dist_weights <- function() {
  env <- new.env()
  load(spatialss_data("dist_w.RData"), envir = env)
  env[[ls(env)[1]]]
}

#' Load Chen CJIP panel data (Chapter 7)
#'
#' Returns the spatial panel dataset from Chen's CJIP study.
#'
#' @return A data.frame.
#' @export
load_chen_cjip <- function() {
  env <- new.env()
  load(spatialss_data("chen_CJIP.RData"), envir = env)
  env[[ls(env)[1]]]
}

#' Load Chapter 8 RDD replication data
#'
#' Returns spatial RDD replication datasets.
#'
#' @param dataset Character. One of "luhya" or "palestine".
#' @return Depends on dataset: an sf object (luhya) or data.frame (palestine).
#' @export
load_rdd_data <- function(dataset = c("luhya", "palestine")) {
  dataset <- match.arg(dataset)
  if (dataset == "luhya") {
    env <- new.env()
    load(spatialss_data("ajps_luhya.RData"), envir = env)
    env[[ls(env)[1]]]
  } else {
    readRDS(spatialss_data("palestine_rep_data.rds"))
  }
}

#' Load China spatial datasets (Chapters 2-3)
#'
#' Returns China administrative boundary data at various levels.
#'
#' @param level Character. One of "cities", "counties", "province".
#' @return An sf object.
#' @export
load_china <- function(level = c("cities", "counties", "province")) {
  level <- match.arg(level)
  fname <- switch(level,
    cities = "china_cities.geojson",
    counties = "china_counties.geojson",
    province = "china_province.geojson"
  )
  sf::read_sf(spatialss_data(fname), quiet = TRUE)
}

#' Load world countries dataset (Chapter 3)
#'
#' Returns the world countries GeoPackage dataset.
#'
#' @return An sf object.
#' @export
load_world <- function() {
  sf::read_sf(spatialss_data("world.gpkg"), quiet = TRUE)
}
