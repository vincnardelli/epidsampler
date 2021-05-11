#' Print epidmap
#'
#' @param x An epidmap object
#' @param ... others
#'
#' @return print
#'
#' @examples
#' \dontrun{
#' map <- genmap(n = 5, p = c(10, 50))
#' print(map)
#' }
#'
#' @export
print.epidmap <- function(x, ...) {
  cat("Epidmic generated map \n")
  cat(paste0("Dimension ", sqrt(nrow(x$map))), "x", sqrt(nrow(x$map)), "\n")
  cat(paste0("Total ", sum(x$map$p), " people\n"))
}
