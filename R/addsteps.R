#' Add multiple steps in map
#'
#' @param map an epidmap object
#' @param n number of steps
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
addsteps <- function(map=map, n=7, m=NULL, s=NULL,
                     cn=NULL, cp=NULL,
                     im=NULL,
                     tE=NULL, tI=NULL, tA=NULL, ir=NULL,
                     cfr=NULL, verbose=FALSE){
  for(i in 1:n){
    map <- addstep(map, m=m, s=s, cn=cn, cp=cp, im=im,
                   tE=tE, tI=tI, tA=tA, ir=ir, cfr=cfr, verbose=verbose)
  }

  return(map)
}
