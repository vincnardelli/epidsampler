library(epidsampler)
library(bench)
library(tictoc)

set.seed(12345)
map <- genspmap(n=20, P=20000, save_movements=T)

tic()
meet(map, cn=4, cp=3, im=2, parallel=F)
toc()


tic()
meet(map, cn=4, cp=3, im=2, parallel=T)
toc()

bench::mark(meet(map, cn=4, cp=3, im=2, parallel=F),
            meet(map, cn=4, cp=3, im=2, parallel=T),
            check=F,
            memory=F)


phase1 <- . %>%
  move_uniform(m=0.1, s=3) %>%
  meet(cn=4, cp=5, im=2) %>%
  move_back()

map2 <- run(map, phase1, days = 1, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)

