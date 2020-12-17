#' Meet
#'
#' @param map a map object
#' @param cn number of contacts in each cell
#' @param cp number of people in each contact
#' @param im number of infected
#'
#' @return a map object
#' @export
#'
#' @examples
meet <- function(map, cn, cp, im, parallel=F){

  cellmeet <- function(cell, cp){
    #contact in one cell

    #cell to xy
    x <- map$map[cell,]$x
    y <- map$map[cell, ]$y


    cell_data <- map$data[map$data$x == x & map$data$y ==y  & map$data$t == map$par$t & map$data$condition %in% c("S", "E", "A", "R"),]
    n_people_contact <- rpois(1, cp)

    if(nrow(cell_data) > n_people_contact & nrow(cell_data) > 1){
      sampled <- sample(cell_data$id, n_people_contact)

      contact <- expand.grid(t=map$par$t,
                             p1=sampled,
                             p2=sampled)
      contact$c1 <- sapply(contact$p1, function(k) cell_data[cell_data$id == k, ]$condition)
      contact$c2 <- sapply(contact$p2, function(k) cell_data[cell_data$id == k, ]$condition)

      contact <- contact[contact$p1!=contact$p2,]

      if(nrow(contact) > 0){

        # contagion
        contact$new <- FALSE

        condition <- sapply(sampled, function(k) cell_data[cell_data$id == k, ]$condition)
        if(sum(c("E", "A") %in% condition)!=0 & length(sampled[condition == "S"])>0){
          if(length(sampled[condition == "S"])==1){
            new_exposed <- sampled[condition == "S"]
          }else{
            new_exposed <- sample(sampled[condition == "S"], im)
          }

          contact[contact$p1 %in% new_exposed, ]$new <- TRUE

        }
      }
      return(contact)
    }else{
      #warning("Less people than contacts!")
      return(NULL)
    }

  }


  # number of meeting for each cell
  # TODO cn depends on population
  cns <- rep(1:(map$par$n*map$par$n), rpois(map$par$n*map$par$n, cn))
  cns

  possible_meet <- purrr::possibly(cellmeet, otherwise = NULL)

  # TODO parallel integration
  if(parallel){
    # future::plan(future::multisession)
    # list <- furrr::future_map(cns, possible_meet, cp=cp)
    list <- parallel::mclapply(cns, possible_meet, cp=cp)
  }else{
    list <- purrr::map(cns, possible_meet, cp=cp)
  }



  meetdf <- purrr::reduce(list, rbind)
  sum(meetdf$new)
  map$contacts <- rbind(map$contacts, meetdf)
  new_exposed <- unique(meetdf[meetdf$new,]$p1)
  #print(length(new_exposed))
  if(length(new_exposed) > 0) map$data[map$data$t == map$par$t & map$data$id %in% new_exposed,]$condition <- "E"
  return(map)
}
