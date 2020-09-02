#' Generate map
#'
#' Generate an epidmap object with population distributed into spatial units laid on a n-by-n regular squared lattice grid.
#'
#' @param n A positive integer. Grid dimension
#' @param p A positive integer. People density for each tile - min/max - uniform distribution
#' @param verbose A logical
#'
#' @return An epidmap object
#' @export
#'
#' @details
#' ##  Map generation
#' For the map generation we considered a population distributed into spatial units laid on a n-by-n regular squared lattice grid. Each square of the grid contains a number of individuals randomly drawn from a uniform distribution ranging between the two values contained in the vector p. This geographical representation is very general in that the map thus generated can represent, e. g., a city divided into blocks or a region divided into smaller spatial union or any other meaningful geographical partition.
#'
#' @examples
#' \dontrun{
#'set.seed(12345)
#'map <- genmap(n=5, p=c(10, 50))
#' print(map)
#' }
genmap <- function(n=5, p=c(10,50), verbose=T){
  # Grid generation
  map <- expand.grid(x=1:n, y=1:n)
  map$p <- round(runif(n*n, min=p[1], max=p[2]), 0)

  if(verbose) cat("1/2: Grid generated\n")

  # Identity generation
  ids <- c()
  x <- c()
  y <- c()
  id <- 1

  for (i in 1:(n*n)){
    for(j in 1:map$p[1]){
      ids <- c(ids, id)
      x <- c(x, map$x[i])
      y <- c(y, map$y[i])
      id = id +1
    }
  }
  data <- data.frame(id=ids, x=x, y=y)
  data$condition <- "S"
  data$condition[sample(nrow(data), 10)] <- "E"
  data$t = 0

  contacts <- list()
  for(j in 1:nrow(data)) contacts[[j]] <- list()

  condition <- data.frame()

  if(verbose) cat("2/2: People generated\n")

  par = list(n=n,
             p=p,
             t=0)

  out <- list(map=map, data=data, contacts=contacts, condition=condition, par=par)
  class(out) <- "epidmap"
  return(out)
}
