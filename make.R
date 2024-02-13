#' seamobb: A Research Compendium
#' 
#' @description 
#' A code to compute oceanographic proba or distance between seamobb sampling sites
#' 
#' @author Terence Legrand \email{legrandterence@gmail.com}
#' 
#' @date 2024/02/13



## Install Dependencies (listed in DESCRIPTION) ----

devtools::install_deps(upgrade = "never")


## Load Project Addins (R Functions and Packages) ----

devtools::load_all(here::here())


## Global Variables ----

pld_all <- c(1,10,20,30,45)


## Run Project ----

#  Load site data
site <- load_site()

# Load grid 
grid <- load_grid()

# Find node
site <- find_node(site = site, grid = grid)

# Compute oceanographic proba
for (i in 1:length(pld_all)) {
  matrix <- load_matrix(pld = pld_all[i])
  oceanographic_proba(pld = pld_all[i], site = site, matrix = matrix)
}

# Agregate matrix
matrix_aggregation(site = site, pld_all = pld_all)

# Proba to distance
oceanographic_proba_to_distance()

# List all R scripts in a sequential order and using the following form:
# source(here::here("analyses", "script_X.R"))
