#' Generate map
#'
#' Generate an epidmap object with population distributed into spatial units laid on a n-by-n regular squared lattice grid.
#'
#' @param n A positive integer. Grid dimension
#' @param p A positive integer. People density for each tile - min/max - uniform distribution
#' @param verbose A logical
#' @param P Total number of individuals
#' @param rho Spatial autocorrelation parameter
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
#'map <- genspmap(n=5, p=c(10, 50))
#' print(map)
#' }
#' @importFrom spdep cell2nb nb2mat

genspmap <- function(n=5, P=1000, p=1, rho=0, verbose=T){

  # Generate grid
  nb <- cell2nb(n, n)
  map <-  expand.grid(x=1:n, y=1:n)
  w <- nb2mat(nb)
  I<-diag(n*n)


  # Generate people
  map$p <- runif(n*n, 1-p, 1)
  map$p <- solve(I-rho*w)%*%(map$p)

  # Fix round
  map$p <- round(map$p/sum(map$p) * P)
  map$p[1] <- map$p[1] + P - sum(map$p)


  data <- data.frame(id=1:1000,
                     x=rep(map$x, map$p),
                     y=rep(map$y, map$p),
                     condition = "S",
                     t = 0)

  # Init contacts
  contacts <- list()
  for(j in 1:nrow(data)) contacts[[j]] <- list()


  par = list(n=n,
             p=p,
             P=P,
             rho=rho,
             t=0)


  out <- list(map=map, data=data, contacts=contacts, par=par)
  class(out) <- "epidmap"
  return(out)

}
