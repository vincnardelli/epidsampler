library(epidsampler)
library(magrittr)
set.seed(12345)
map <- genmap(n=5, p=c(10,50))
print(map)
phase1 <- . %>%
  move_uniform(m=0.1, s=2) %>%
  meet(cn=6, cp=5, im=3)

map2 <- run(map, phase1, days = 21, tE=5, tA=14,
            tI=14, ir=1, cfr=0.15)
plot(map2)

phase2 <- . %>%
  move_uniform(m=0.01, s=1) %>%
  meet(cn=1, cp=2, im=3)
map3 <- run(map2, phase2, days = 9, ir=1)
plot(map3)
