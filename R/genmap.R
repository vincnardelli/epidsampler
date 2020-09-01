#' Generate map
#'
#' @param n grid dimension
#' @param p uniform distribution of people
#' @param verbose verbose?
#'
#' @return An epidmap object
#' @export
#'
#' @examples genmap(n=5, p=c(10, 50))
#'
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
