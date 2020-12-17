#' Animate map
#'
#' @param map
#' @param height
#' @param width
#' @param res
#' @param fps
#' @param spd
#' @param end_pause
#'
#' @return
#' @export
#'
#' @examples
animate_map <- function(map, height=800, width=800,
                        res = 150, fps = 10, spd = 2,
                        end_pause = 30,
                        renderer = gganimate::gifski_renderer() ){
  # create continuous time with movements during day
  incr <- map$movements %>%
    dplyr::group_by(t) %>%
    dplyr::summarise(incr = max(t_move)) %>%
    dplyr::mutate(incr = 1/(incr+1))

  animation <- map$data %>%
    dplyr::filter(t > 0, condition != "D") %>%
    dplyr::mutate(t_move = 0) %>%
    rbind(map$movements) %>%
    dplyr::left_join(incr, by="t") %>%
    dplyr::mutate(t = t+t_move*incr) %>%
    dplyr::arrange(t) %>%
    dplyr::select(-t_move, -incr)

  plot <- animation %>%
    dplyr::filter(condition != "D") %>%
    ggplot2::ggplot() +
    ggplot2::geom_jitter(data=animation, ggplot2::aes(x, y, color=condition), width = 0.1, height = 0.1) +
    ggplot2:: scale_color_manual(values=c( "S"="blue","D"='black', "I"= 'red4', 'E'="red", 'R'='darkolivegreen4', "A"="orange")) +
    ggplot2::theme_void() +
    gganimate::transition_time(t) +
    ggplot2::labs(title = 'Day: {round(frame_time, 2)}')

  anim_plot <- gganimate::animate(plot,
                                  end_pause = end_pause,
                                  height = height,
                                  width =width,
                                  res = res,
                                  nframes=map$par$t*fps*spd, fps=fps, renderer = renderer)

  return(anim_plot)
}
