#' Add step in map
#'
#' @param map an epidmap object
#' @param m moving %
#' @param s stepsize
#' @param cn mean of contacts inside a tile
#' @param cp mean of number of people for each contact
#' @param im mean of number of people infected
#' @param tE number of days of E condition
#' @param tI number of days of I condition
#' @param tA number of days of A condition
#' @param ir infected rate I/(A+I)
#' @param cfr case fatality rate
#' @param verbose verbose
#'
#' @return an epidmap object
#' @export
#'
#' @importFrom stats rpois
addstep <- function(map=map, m=NULL, s=NULL,
                    cn=NULL, cp=NULL,
                    im=NULL,
                    tE=NULL, tI=NULL, tA=NULL, ir=NULL,
                    cfr=NULL, verbose=FALSE){
  n <- map$par$n
  if(!is.null(map$par$m) & is.null(m)) m <- map$par$m
  if(!is.null(map$par$s) & is.null(s)) s <- map$par$s
  if(!is.null(map$par$cn) & is.null(cn)) cn <- map$par$cn
  if(!is.null(map$par$cp) & is.null(cp)) cp <- map$par$cp
  if(!is.null(map$par$im) & is.null(im)) im <- map$par$im
  if(!is.null(map$par$tE) & is.null(tE)) tE <- map$par$tE
  if(!is.null(map$par$tI) & is.null(tI)) tI <- map$par$tI
  if(!is.null(map$par$tA) & is.null(tA)) tA <- map$par$tA
  if(!is.null(map$par$ir) & is.null(ir)) ir <- map$par$ir
  if(!is.null(map$par$cfr) & is.null(cfr)) cfr <- map$par$cfr

  cat("Starting simulation in step ", map$par$t, "\n")
  lastmap <- map$data[map$data$t == map$par$t,]

  # move section

  can_move <- lastmap$id[lastmap$condition %in% c("S", "E", "A")]
  n_can_move <- round(length(can_move)*m, 0)



  move_p <- sample(can_move, n_can_move)

  move_x <- round(runif(n_can_move, min=-s, max=s), 0)
  move_y <- round(runif(n_can_move, min=-s, max=s), 0)

  check_border <- function(list){
    list[list < 1] <- 1 - list[list < 1]
    list[list > n] <- n - (list[list > n] - n)
    list[list < 1] <- 1
    list[list > n] <- n

    return(list)
  }

  new_x <- check_border(lastmap[move_p, ]$x + move_x)
  new_y <- check_border(lastmap[move_p, ]$y + move_y)

  data_new <- lastmap
  t <- map$par$t+1
  data_new$t <- t
  data_new[move_p,]$x <- new_x
  data_new[move_p,]$y <- new_y
  map$data <- rbind(map$data, data_new)

  #end move section

  check_stationary_status <- function(vector, t){
    if(length(vector)< t) return(FALSE)
    vector <- vector[(length(vector)-t+1):length(vector)]
    if(verbose) print(vector)
    last_element <- vector[length(vector)]
    return(mean(vector == rep(last_element, length(vector))) == 1)
  }

  # change status
  # if E
  ids <- map$data$id[map$data$t == max(map$data$t) & map$data$condition == "E"]

  for(idx in ids){
    if (check_stationary_status(map$data$condition[map$data$id == idx], tE)){
      map$data$condition[map$data$t == max(map$data$t) & map$data$id == idx] <- sample(c("I", "A"), 1, prob=c(ir, 1-ir))
      if(verbose) print(map$data$condition[map$data$t == max(map$data$t) & map$data$id == idx])
    }
  }

  # if A

  ids <- map$data$id[map$data$t == max(map$data$t) & map$data$condition == "A"]

  for(idx in ids){
    if (check_stationary_status(map$data$condition[map$data$id == idx], tA)){
      map$data$condition[map$data$t == max(map$data$t) & map$data$id == idx] <- "R"
      if(verbose) print(map$data$condition[map$data$t == max(map$data$t) & map$data$id == idx])
    }
  }

  # if I
  ids <- map$data$id[map$data$t == max(map$data$t) & map$data$condition == "I"]

  for(idx in ids){
    if (check_stationary_status(map$data$condition[map$data$id == idx], tI)){
      map$data$condition[map$data$t == max(map$data$t) & map$data$id == idx] <- sample(c("D", "R"), 1, prob=c(cfr, 1-cfr))
      if(verbose) print(map$data$condition[map$data$t == max(map$data$t) & map$data$id == idx])
    }
  }
  # finish I



  # contact section
  active_cat <- c("S", "E", "A")
  # cat("Contacts\n")

  for(i_map in 1:nrow(map$map)){
    candidates <- data_new$id[data_new$x == map$map$x[i_map] & data_new$y ==map$map$y[i_map] & data_new$condition %in% active_cat]

    number_contacts <- rpois(1, cn)

    if(number_contacts > 0){
      #  cat("  Tile ", i_map, "- generated", number_contacts, "contacts \n")

      for(c in 1:number_contacts){

        n_people_contact <- rpois(1, cp)

        # FIXME add error in contacts
        #if(n_people_contact >= candidates) stop("Number of contacts higher than people in tile. Please reduce the parameter np or use a new map with more people!")

        sample <- sample(candidates, n_people_contact)

        #infection

        infected <- map$data[map$data$id %in% sample & map$data$condition %in% c("E", "A", "I") & map$data$t == max(map$data$t), ]$id

        if(length(infected)>0){
          if(verbose) cat("Infected found ", infected, "\n")
          if(verbose) cat("Sample ", sample, "\n")
          not_infected <- sample[!(sample %in% infected)]
          if(verbose) cat("not_infected ", not_infected, "\n")

          number_new_infected <- rpois(1, im)
          number_new_infected <- ifelse(number_new_infected < length(not_infected), number_new_infected, length(not_infected))

          if(number_new_infected > 0){
            new_infected <- sample(not_infected, number_new_infected)
            if(verbose) cat("new_infected ", new_infected, "\n")
            map$data[map$data$id %in% new_infected & map$data$t == t, ]$condition <- "E"
          }

        }

        if(length(sample > 1)){
          for(i in sample){
            to_add <- sample[-which(sample == i)]

            if(length(map$contacts[[i]]) == t){
              map$contacts[[i]][[t]] <- append(map$contacts[[i]][[t]], setdiff(to_add, map$contacts[[i]][[t]]))
            }else{
              map$contacts[[i]][[t]] <- c(to_add)
            }
          }
        }
      }
    }
  }

  #end contact section


  map$par$m <- m
  map$par$s <- s
  map$par$t <- t
  map$par$cn <- cn
  map$par$cp <- cp
  map$par$im <- im
  map$par$tE <- tE
  map$par$tI <- tI
  map$par$tA <- tA
  map$par$ir <- ir
  map$par$cfr <- cfr
  return(map)
}
