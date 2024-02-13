find_node <- function(site = NULL, grid = NULL) {
  
  # Find node 
  site$node <- NA
  site$land_ratio <- NA
  site$habitat <- NA

  
  grid_filter <- grid
  grid_filter$index <- 1:length(grid$Lat)
  grid_filter <- grid_filter[grid$habitat == 1,]
  
  for (i in 1:length(site$Index)) {
    dist <- raster::pointDistance(c(site$Lon[i],site$Lat[i]), cbind(grid_filter$Lon,grid_filter$Lat), lonlat=FALSE)
    site$node[i] <- grid_filter$index[which.min(dist)]
    site$land_ratio[i] <- grid$land_ratio[site$node[i]]
    site$habitat[i] <- grid$habitat[site$node[i]]
  }
  
  # To match C++ (LFN code) identation
  site$node <- site$node-1
  
  return(site)
  
}
# 
# node_size <- 0.25 # should be implemented automatically
# 
# # Compute the four corner's location of each node
# 
# node_coord <- base::matrix(nrow = length(grid$Lat), ncol = 6)
# 
# for (i in 1:length(node_coord[,1])) {
#   node_coord[i,] <- c(grid$Lon[i] - grid$Lon_delta[i]/2,
#                       grid$Lon[i] + grid$Lon_delta[i]/2,
#                       grid$Lat[i] - node_size/2,
#                       grid$Lat[i] + node_size/2,
#                       grid$land_ratio[i],
#                       grid$habitat[i])
# }
# 
# node_coord <- base::as.data.frame(node_coord)
# 
# colnames(node_coord) <- c("lon_min","lon_max","lat_min","lat_max","land_ratio","habitat")
