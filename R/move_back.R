#' Move back
#'
#' @description
#' 'move_back' generates the movements to restore the original position of the individuals
#' after some movements
#' @param map an epidmap object
#'
#' @return an epidmap object
#' @export

move_back <- function(map) {
  map$data[map$data$t == map$par$t, ]$x <- map$data[map$data$t == map$par$t - 1, ]$x
  map$data[map$data$t == map$par$t, ]$y <- map$data[map$data$t == map$par$t - 1, ]$y

  if (map$par$save_movements) {
    df_tosave <- map$data[map$data$t == map$par$t, ]
    if (is.null(map$movements)) {
      df_tosave$t_move <- 1
    } else {
      if (dim(map$movements[map$movements$t == map$par$t, ])[1] > 0) {
        df_tosave$t_move <- max(map$movements$t_move[map$movements$t == map$par$t]) + 1
      } else {
        df_tosave$t_move <- 1
      }
    }

    map$movements <- rbind(map$movements, df_tosave)
  }


  return(map)
}
