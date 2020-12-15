#' Move back
#'
#' @param map
#'
#' @return
#' @export
#'
#' @examples
move_back <- function(map){
  map$data[map$data$t == map$par$t, ]$x <- map$data[map$data$t == map$par$t-1, ]$x
  map$data[map$data$t == map$par$t, ]$y <- map$data[map$data$t == map$par$t-1, ]$y

  return(map)
}
