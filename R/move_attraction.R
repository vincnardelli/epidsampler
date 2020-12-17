#' Move to attraction
#'
#' @param map
#' @param a
#' @param m
#'
#' @return
#' @export
#'
#' @examples
move_attraction <- function(map, a, m){
  can_move <- map$data[map$data$t == map$par$t, ]$id[map$data[map$data$t == map$par$t, ]$condition %in% c("S", "E", "A")]
  n_can_move <- round(length(can_move)*m, 0)

  move_p <- sample(can_move, n_can_move)

  as.vector(attraction)
  new_points <- sample(map$par$n*map$par$n, n_can_move, prob=as.vector(attraction), replace = T)

  map$data[map$data$t == map$par$t, ][move_p,]$x <- map$map[new_points, ]$x
  map$data[map$data$t == map$par$t, ][move_p,]$y <-  map$map[new_points, ]$y


  if(map$par$save_movements){
    df_tosave <- map$data[map$data$t == map$par$t, ]
    if(is.null(map$movements)){
      df_tosave$t_move <- 1
    }else{
      if(dim(map$movements[map$movements$t == map$par$t, ])[1]>0){
        df_tosave$t_move <- max(map$movements$t_move[map$movements$t == map$par$t]) + 1
      }else{
        df_tosave$t_move <- 1
      }
    }

    map$movements <- rbind(map$movements, df_tosave)
  }


  return(map)
}
