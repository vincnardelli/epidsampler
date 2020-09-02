#' Plot epidmap
#'
#' @param x An epidmap object
#' @param ... others
#'
#' @return plot
#'
#' @examples
#' \dontrun{
#'set.seed(12345)
#'map <- genmap(n=5, p=c(10, 50))
#'map <- map %>%
#'  addsteps(n=7*3, m=0.03, s=2,
#'           cn=4, cp=2,
#'           im=3, tE=5, tA=14,
#'           tI=14, ir=1, cfr=0.15) %>%
#'  addsteps(n=19, m=0.01, s=1,
#'           cn=1, cp=2,
#'           im=3, tE=5, tA=14,
#'           tI=14, ir=1, cfr=0.15)
#' plot(map)
#' }
#'
#'
#' @export
#' @importFrom stats filter runif
#' @importFrom ggplot2 ggplot geom_line geom_text ggtitle scale_color_manual scale_y_continuous theme_minimal aes
#' @importFrom dplyr %>% group_by summarise ungroup n

plot.epidmap <- function(x, ...){
  condition=count=t=NULL
  if(x$par$t < 1) stop ("Not enough data")
  df <- x$data %>%
    group_by(t, condition) %>%
    summarise(count=n())


    p <- ggplot(df) +
    geom_line(aes(t, count, color=condition)) +
    theme_minimal() +
    scale_y_continuous(trans='log2') +
    scale_color_manual(values=c( "S"="blue","D"='black', "I"= 'red4', 'E'="red", 'R'='darkolivegreen4', "A"="orange")) +
    # FIXME add geom text in plot
    # geom_text(data = df %>% ungroup() %>% filter(t == max(t)), aes(label = condition,
    #                                                              x = t + 1,
    #                                                              y = count,
    #                                                              color = condition)) +
    ggtitle("SEIRD graph")

  return(p)
}
