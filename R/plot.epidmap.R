#' Plot epidmap
#'
#' @param x An epidmap object
#' @param ... others
#'
#' @return plot
#'
#' @export
#' @importFrom stats filter runif
#' @importFrom ggplot2 ggplot geom_line geom_text ggtitle scale_color_manual scale_y_continuous theme_minimal aes
#' @importFrom dplyr %>% group_by summarise ungroup n

plot.epidmap <- function(x, ...) {
  condition <- count <- t <- NULL
  if (x$par$t < 1) stop("Not enough data")
  df <- x$data %>%
    group_by(t, condition) %>%
    summarise(count = n())


  p <- ggplot2::ggplot(df) +
    ggplot2::geom_line(aes(t, count, color = condition)) +
    ggplot2::theme_minimal() +
    ggplot2::scale_y_continuous(trans = "log2") +
    ggplot2::scale_color_manual(values = c("S" = "blue", "D" = "black", "I" = "red4", "E" = "red", "R" = "darkolivegreen4", "A" = "orange")) +
    # FIXME add geom text in plot
    # geom_text(data = df %>% ungroup() %>% filter(t == max(t)), aes(label = condition,
    #                                                              x = t + 1,
    #                                                              y = count,
    #                                                              color = condition)) +
    ggplot2::ggtitle("SEIRD graph")

  return(p)
}
