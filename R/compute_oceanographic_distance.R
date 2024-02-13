oceanographic_proba <- function(pld = NULL, site = NULL, matrix = NULL) {
  
  # Create graph object from list
  graph.back.save <- igraph::graph_from_data_frame(matrix,
                                           directed = TRUE,
                                           vertices = NULL)
  
  matrix$weight <- -log(matrix$weight)
  
  graph.back <- igraph::graph_from_data_frame(matrix,
                                      directed = TRUE,
                                      vertices = NULL)
  
  dist.mean <- matrix(NA, nrow = length(site$Lat), ncol = length(site$Lat))
  
  for (a in 1:length(site$Lat)) {
    for (b in 1:length(site$Lat)) {
      
      if (a != b &
          (sum(matrix$from == site[a,"node"]) * sum(matrix$to == site[b,"node"])) > 0 ) { # add an if condition on precense of the vertice in the graph)
        
        path <- igraph::shortest_paths(
          graph.back,
          from = as.character(site[a,"node"]),
          to = as.character(site[b,"node"]),
          mode = "out",
          weights = NULL,
          algorithm = c("dijkstra"))
        
        path <- as.numeric(path$vpath[[1]])
        
        if (length(path) > 0) { # it means there is a path
          
          EP = rep(path, each=2)[-1]
          EP = EP[-length(EP)]
          
          igraph::E(graph.back.save)[igraph::get.edge.ids(graph.back.save,(EP))] # In grpah.back.save is the probabilities
          dist.mean[a,b] <- prod(igraph::E(graph.back.save)$weight[igraph::get.edge.ids(graph.back.save,(EP))],na.rm = TRUE)
          
        } else {
          
          dist.mean[a,b] <- 0
          
        }
      }
      
    }
  }
  
  dist.mean.ab <- dist.mean.ba <- dist.mean
  
  dist.mean.ab[upper.tri(dist.mean, diag = TRUE)] <- 0
  
  dist.mean.ba[lower.tri(dist.mean, diag = FALSE)] <- 0
  
  dist.mean <- dist.mean.ab + t(dist.mean.ba) - dist.mean.ab*t(dist.mean.ba) # to deal with 1-low proba issues
  
  dist.mean[upper.tri(dist.mean, diag = FALSE)] <- NA
  
  rownames(dist.mean) <- site$Station
  colnames(dist.mean) <- site$Station
  
  utils::write.csv(dist.mean, file = here::here("outputs",paste0("oceanographic_proba_",pld,".csv")), dec = ".")
  
}

matrix_aggregation <- function(site = NULL, pld_all = NULL) {
  
  matrix_aggregated <- matrix(0, nrow = length(site$Lat), ncol = length(site$Lat))
  rownames(matrix_aggregated) <- site$Station
  colnames(matrix_aggregated) <- site$Station
  
  for (i in 1:length(pld_all)) {
    matrix_aggregated <- matrix_aggregated + read.csv(file = here::here("outputs",paste0("oceanographic_proba_",pld_all[i],".csv")), header = TRUE, row.names = 1)
  }
  
  matrix_aggregated <- matrix_aggregated/length(pld_all)
  
  utils::write.csv(matrix_aggregated, file = here::here("outputs","oceanographic_proba_aggregated.csv"))
  
}

oceanographic_proba_to_distance <- function(site = NULL) {
  
  matrix_aggregated <- read.csv(file = here::here("outputs","oceanographic_proba_aggregated.csv"), header = TRUE, row.names = 1)
  
  # Praba to distance with -log transformation
  
  matrix_aggregated_distance <- -log(matrix_aggregated)
  
  utils::write.csv(matrix_aggregated_distance, file = here::here("outputs","oceanographic_distance_aggregated.csv"))
  
}
