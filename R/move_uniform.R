#' Move uniform
#'
#' @description
#' 'move_uniform' generates the movements of the individuals
#'
#' @details
#' The contagion mechanism is favoured by people mobility.
#' In this simulation, we assumed that in any moment of time a certain
#' percentage **m** of the population can move between the spatial clusters.
#' In this way it is possible to distinguish different epidemic phases
#' such as free-to-move period and lockdown.
#' The commuting during the lockdown period is not only limited
#' by the number of people who move, but also by the extent of their movements.
#'
#' ## Grid map
#' In the case of grid map, the parameter **s** rules the max step size between the
#' tiles of the grid.
#'
#' ## Polygon map
#' In the case of the polygon map, the parameter **s** rules the number
#'  of neighbor clusters in which each individual can move.
#'
#' @param map an epidmap object
#' @param m % of moving individuals
#' @param s max step size (grid map) or number of neighbor clusters (polygon map). See details.
#'
#' @return an epidmap object
#' @export
#' @importFrom methods is

move_uniform <- function(map, m, s){
condition = NULL
  # polygon uniform
  if(is(map, "polygon")){

    move_df <- map$data %>%
      dplyr::filter(t == map$par$t) %>%
      dplyr::mutate(can_move = ifelse(condition %in% c("S", "E", "A"), TRUE, FALSE)) %>%
      dplyr::left_join(map$map, by=c("x", "y"))

    can_move <- move_df$id[move_df$can_move]
    n_can_move <- round(length(can_move)*m, 0)
    move_p <- sample(can_move, n_can_move)

    knn_mat <- spdep::nb2mat(spdep::knn2nb(spdep::knearneigh(cbind(map$map$x, map$map$y), s)), style="B")
    w_std <- t(apply(map$w, 1, function(x) x/sum(x)))
    w <- knn_mat * w_std


    can_move_df <- move_df[move_df$id %in% move_p,]

    can_move_id <- can_move_df$id
    can_move_location <- can_move_df$location_id

    relocate <- function(x) sample(map$par$n, 1, prob=w[x, ])

    new_location <- sapply(can_move_location, relocate)

    map$data[map$data$t == map$par$t, ][move_p,]$x <- sapply(new_location, function(location) map$map$x[map$map$location_id == location])
    map$data[map$data$t == map$par$t, ][move_p,]$y <- sapply(new_location, function(location) map$map$y[map$map$location_id == location])
  }

  #grid - uniform
  if(is(map, "grid")){
    can_move <- map$data[map$data$t == map$par$t, ]$id[map$data[map$data$t == map$par$t, ]$condition %in% c("S", "E", "A")]
    n_can_move <- round(length(can_move)*m, 0)
    move_p <- sample(can_move, n_can_move)

    move_x <- round(runif(n_can_move, min=-s, max=s), 0)
    move_y <- round(runif(n_can_move, min=-s, max=s), 0)

    check_border <- function(list){
      list[list < 1] <- 1 - list[list < 1]
      list[list > sqrt(map$par$n)] <-sqrt(map$par$n) - (list[list >sqrt(map$par$n)] -sqrt(map$par$n))
      list[list < 1] <- 1
      list[list >sqrt(map$par$n)] <-sqrt(map$par$n)

      return(list)
    }

    map$data[map$data$t == map$par$t, ][move_p,]$x <- check_border(map$data[map$data$t == map$par$t, ][move_p, ]$x + move_x)
    map$data[map$data$t == map$par$t, ][move_p,]$y <- check_border(map$data[map$data$t == map$par$t, ][move_p, ]$y + move_y)

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
