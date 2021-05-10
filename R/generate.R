#' Generate map
#'
#' Generate an epidmap object with population distributed into spatial units laid on a n-by-n regular squared lattice grid.
#'
#' @param n A positive integer. Grid dimension
#' @param p A positive integer. People density for each tile - min/max - uniform distribution
#' @param verbose A logical
#' @param P Total number of individuals
#' @param rho Spatial autocorrelation parameter
#' @param save_movements save movements in memory
#' @param type select type
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
#' set.seed(12345)
#' map <- genspmap(n = 5, p = c(10, 50))
#' print(map)
#' }
#' @importFrom spdep cell2nb nb2mat
#' @importFrom stats dist

generate <- function(n = 25, P = 1000, type = "polygon", p = 1, rho = 0, verbose = T, save_movements = F) {


  # Generate polygon
  if (type == "polygon") {
    map <- data.frame(
      x = round(runif(n, 0.05, 0.95), 2),
      y = round(runif(n, 0.05, 0.95), 2)
    )
    w <- as.matrix(1 / stats::dist(cbind(map$x, map$y), upper = T, diag = T))
  }


  # Generate grid
  if (type == "grid") {
    sqrt(n) == round(sqrt(n), 0) # check if is squared

    map <- expand.grid(x = 1:sqrt(n), y = 1:sqrt(n))
    nb <- spdep::cell2nb(sqrt(n), sqrt(n))
    w <- spdep::nb2mat(nb)
  }

  I <- diag(n)
  map$p <- runif(n, 1 - p, 1)
  map$p <- solve(I - rho * w) %*% (map$p)

  # Fix round
  map$p <- round(map$p / sum(map$p) * P)
  map$p[1] <- map$p[1] + P - sum(map$p)
  map$location_id <- 1:nrow(map)

  data <- data.frame(
    id = 1:P,
    x = rep(map$x, map$p),
    y = rep(map$y, map$p),
    condition = "S",
    t = 0
  )
  data$condition <- as.character(data$condition)
  data$condition[sample(nrow(data), 10)] <- "E"

  # Init contacts
  contacts <- list()
  for (j in 1:nrow(data)) contacts[[j]] <- list()


  par <- list(
    n = n,
    p = p,
    P = P,
    rho = rho,
    t = 0,
    save_movements = save_movements
  )

  out <- list(map = map, data = data, contacts = contacts, movements = NULL, par = par)
  if (type == "polygon") out$w <- w

  if (type == "polygon") class(out) <- c("epidmap", "polygon")
  if (type == "grid") class(out) <- c("epidmap", "grid")

  return(out)
}
