#' Print epidmap
#'
#' @param x an epidmap object
#' @param ... others
#'
#' @return print
#' @export
print.epidmap <- function(x, ...){
  cat("Epidmic generated map \n")
  cat(paste0("Dimension ", sqrt(nrow(x$map))), "x", sqrt(nrow(x$map)), "\n")
  cat(paste0("Total ", sum(x$map$p), " people"))

}
