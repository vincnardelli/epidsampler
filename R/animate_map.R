#' Animate map
#'
#' @param map map object
#' @param height height of the map
#' @param width width of the map
#' @param res resolution
#' @param fps frame per second
#' @param spd spd
#' @param end_pause end_pause
#' @param renderer gganimate renderer
#'
#' @return animation
#' @export
animate_map <- function(map, height=800, width=800,
                        res = 150, fps = 10, spd = 2,
                        end_pause = 30,
                        renderer = gganimate::gifski_renderer() ){

  . = NULL
  t_move = condition = x = y = NULL
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


  if(methods::is(map, "grid")){
  plot <- animation %>%
    dplyr::filter(condition != "D") %>%
    ggplot2::ggplot()
  }

  if(methods::is(map, "polygon")){
  voronoi_grid <- map$map %>%
    sf::st_as_sf(coords = c("x", "y")) %>%
    sf::st_geometry() %>%
    do.call(c, .) %>%
    sf::st_voronoi(bOnlyEdges=FALSE) %>%
    sf::st_collection_extract() %>%
    sf::st_crop(c(xmin = 0, ymin = 0, xmax = 1, ymax = 1))


  plot <- animation %>%
    dplyr::filter(condition != "D") %>%
    ggplot2::ggplot() +
    ggplot2::geom_sf(data=voronoi_grid, fill=NA)

  }

  plot <- plot +
    ggplot2::geom_jitter(data=animation, ggplot2::aes(x, y, color=condition), width = 0.03, height = 0.03, size=0.5) +
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
