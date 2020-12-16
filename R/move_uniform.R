#' Move uniform
#'
#' @param map map object
#' @param m % of moving people
#' @param s max step
#'
#' @return map
#' @export
#'
#' @examples
move_uniform <- function(map, m, s){

  can_move <- map$data[map$data$t == map$par$t, ]$id[map$data[map$data$t == map$par$t, ]$condition %in% c("S", "E", "A")]
  n_can_move <- round(length(can_move)*m, 0)


  move_p <- sample(can_move, n_can_move)

  move_x <- round(runif(n_can_move, min=-s, max=s), 0)
  move_y <- round(runif(n_can_move, min=-s, max=s), 0)

  check_border <- function(list){
    list[list < 1] <- 1 - list[list < 1]
    list[list > map$par$n] <- map$par$n - (list[list > map$par$n] - map$par$n)
    list[list < 1] <- 1
    list[list > map$par$n] <- map$par$n

    return(list)
  }

  map$data[map$data$t == map$par$t, ][move_p,]$x <- check_border(map$data[map$data$t == map$par$t, ][move_p, ]$x + move_x)
  map$data[map$data$t == map$par$t, ][move_p,]$y <- check_border(map$data[map$data$t == map$par$t, ][move_p, ]$y + move_y)

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
