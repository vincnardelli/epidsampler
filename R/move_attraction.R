#' Move to attraction
#'
#' @param map a map object
#' @param a a matrix
#' @param m % of moving people
#'
#' @return map object
#' @export

move_attraction <- function(map, m, a=NULL){
  if(is(map, "polygon")){

    move_df <- map$data %>%
      dplyr::filter(t == map$par$t) %>%
      dplyr::mutate(can_move = ifelse(condition %in% c("S", "E", "A"), TRUE, FALSE)) %>%
      dplyr::left_join(map$map, by=c("x", "y"))

    can_move <- move_df$id[move_df$can_move]
    n_can_move <- round(length(can_move)*m, 0)
    move_p <- sample(can_move, n_can_move)

    can_move_df <- move_df[move_df$id %in% move_p,]
    can_move_id <- can_move_df$id
    can_move_location <- can_move_df$location_id

    if(is.null(a)){
      new_location <- which.min(((map$map$x - 0.5)^2) + ((map$map$y - 0.5)^2))
    }else{
      relocate <- function(x) sample(map$par$n, 1, prob=a[x, ])
      new_location <- sapply(can_move_location, relocate)
    }

    map$data[map$data$t == map$par$t, ][move_p,]$x <- sapply(new_location, function(location) map$map$x[map$map$location_id == location])
    map$data[map$data$t == map$par$t, ][move_p,]$y <- sapply(new_location, function(location) map$map$y[map$map$location_id == location])


    }

  if(is(map, "grid")){
  condition = t_move = x = y = NULL
  can_move <- map$data[map$data$t == map$par$t, ]$id[map$data[map$data$t == map$par$t, ]$condition %in% c("S", "E", "A")]
  n_can_move <- round(length(can_move)*m, 0)

  move_p <- sample(can_move, n_can_move)


if(is.null(a)){
  a <- matrix(0, nrow = sqrt(map$par$n), ncol=sqrt(map$par$n))
  if(sqrt(map$par$n) %% 2 == 0){
    a[sqrt(map$par$n)/2, sqrt(map$par$n)/2+1] <- 0.25
    a[sqrt(map$par$n)/2, sqrt(map$par$n)/2] <- 0.25
    a[sqrt(map$par$n)/2+1, sqrt(map$par$n)/2] <- 0.25
    a[sqrt(map$par$n)/2+1, sqrt(map$par$n)/2+1] <- 0.25
  } else{
    a[round(sqrt(map$par$n)/2, 0)+1, round(sqrt(map$par$n)/2, 0)+1] <- 1
  }
}

  new_points <- sample(map$par$n, n_can_move, prob=as.vector(a), replace = T)

  map$data[map$data$t == map$par$t, ][move_p,]$x <- map$map[new_points, ]$x
  map$data[map$data$t == map$par$t, ][move_p,]$y <-  map$map[new_points, ]$y
  }




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
