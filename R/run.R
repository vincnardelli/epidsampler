#' Run simulation
#'
#' @param map
#' @param daily
#' @param days
#' @param tE
#' @param tA
#' @param tI
#' @param ir
#' @param cfr
#' @param verbose
#'
#' @return
#' @export
#'
#' @examples
run <- function(map, daily, days=1, tE=5, tA=14, tI=14, ir=1, cfr=0.15, verbose = F){


  pb <- progress::progress_bar$new(
    format = "  simulation [:bar] :percent eta: :elapsedfull - :eta",
    total = days, clear = TRUE)


  for(day in 1:days){
    pb$tick()

    # 1 aggiungo un giorno
    duplicate <- map$data[map$data$t == map$par$t, ]
    duplicate$t <- map$par$t + 1
    map$par$t <- map$par$t+1
    map$data <- rbind(map$data, duplicate)

    # 2 eseguo le funzioni
    map <- daily(map)
    # 3 aggiorno i casi

    check_stationary_status <- function(vector, t){
      if(length(vector)< t) return(FALSE)
      vector <- vector[(length(vector)-t+1):length(vector)]
      if(verbose) print(vector)
      last_element <- vector[length(vector)]
      return(mean(vector == rep(last_element, length(vector))) == 1)
    }

    # change status
    # if E
    ids <- map$data$id[map$data$t == map$par$t & map$data$condition == "E"]

    for(idx in ids){
      if (check_stationary_status(map$data$condition[map$data$id == idx], tE)){
        map$data$condition[map$data$t == map$par$t & map$data$id == idx] <- sample(c("I", "A"), 1, prob=c(ir, 1-ir))
        if(verbose) print(map$data$condition[map$data$t == map$par$t & map$data$id == idx])
      }
    }

    # if A

    ids <- map$data$id[map$data$t == map$par$t & map$data$condition == "A"]

    for(idx in ids){
      if (check_stationary_status(map$data$condition[map$data$id == idx], tA)){
        map$data$condition[map$data$t == map$par$t & map$data$id == idx] <- "R"
        if(verbose) print(map$data$condition[map$data$t == map$par$t & map$data$id == idx])
      }
    }

    # if I
    ids <- map$data$id[map$data$t == map$par$t & map$data$condition == "I"]

    for(idx in ids){
      if (check_stationary_status(map$data$condition[map$data$id == idx], tI)){
        map$data$condition[map$data$t == map$par$t & map$data$id == idx] <- sample(c("D", "R"), 1, prob=c(cfr, 1-cfr))
        if(verbose) print(map$data$condition[map$data$t == map$par$t & map$data$id == idx])
      }
    }
    # finish I
  }
  cat("Simulation done! \n")
  return(map)
}
