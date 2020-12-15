library(epidsampler)
library(magrittr)
# vignette example
# set.seed(12345)
# map <- genmap(n=5, p=c(10,50))
# print(map)
# phase1 <- . %>%
#   move_uniform(m=0.2, s=3) %>%
#   meet(cn=3, cp=4, im=2) %>%
#   move_back()
#
# map2 <- run(map, phase1, days = 21, tE=5, tA=14,
#             tI=14, ir=1, cfr=0.15)
# plot(map2)
#
# phase2 <- . %>%
#   move_uniform(m=0.01, s=1) %>%
#   meet(cn=2, cp=3, im=1) %>%
#   move_back()
#
# map3 <- run(map2, phase2, days = 9, ir=1)
# plot(map3)


set.seed(12345)
map <- genspmap(n=10, P =10000)
print(map)
phase1 <- . %>%
  move_uniform(m=0.2, s=3) %>%
  meet(cn=3, cp=4, im=2) %>%
  move_back()

map2 <- run(map, phase1, days = 21, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)
plot(map2)

phase2 <- . %>%
  move_uniform(m=0.01, s=1) %>%
  meet(cn=2, cp=3, im=1) %>%
  move_back()

map3 <- run(map2, phase2, days = 9, ir=0.25)
plot(map3)
