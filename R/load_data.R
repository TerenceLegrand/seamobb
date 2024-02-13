load_site <- function() {
  
  site <- openxlsx::read.xlsx(here::here("data","raw-data","Coordinates_SEAMoBB_All.xlsx"))
  
  return(site)
}

load_grid <- function() {
  
  grid <- utils::read.table(here::here("data","raw-data","vfield1_ndom1_depth3_node0250_plat002500.grid"))
  habitat <- utils::read.table(here::here("data","raw-data","infralittoral_habitat_filter.txt"))
  grid[,5] <- habitat
  colnames(grid) <- c("Lat","Lon","Lon_delta","land_ratio","habitat")
  
  return(grid)
  
}

load_matrix <- function(pld = NULL) {
  
  matrix_name <- base::paste0("transpose_back_infra_all_2000_2010_back_vfield1_ndom1_depth3_node0250_plat002500_tau",pld,"_rk003.matrix")
  
  matrix <- utils::read.table(here::here("data","raw-data",matrix_name))
  colnames(matrix) <- c("from","to","weight")
  
  return(matrix)
}