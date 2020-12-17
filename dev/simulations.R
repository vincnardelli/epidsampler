library(epidsampler)
library(tictoc)

# Simulation 1

set.seed(12345)
map <- genspmap(n=10, P=5000, save_movements=T)
print(map)
phase1 <- . %>%
  move_uniform(m=0.1, s=3) %>%
  meet(cn=4, cp=5, im=2) %>%
  move_back()

map2 <- run(map, phase1, days = 21, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)
plot(map2)

phase2 <- . %>%
  move_uniform(m=0.01, s=1) %>%
  meet(cn=2, cp=3, im=1) %>%
  move_back()

map3 <- run(map2, phase2, days = 14, ir=0.25)

plot(map3) +
  ggplot2::ggtitle("Simulation 1 (5000 in 10x10)")

saveRDS(map3, "simulation1.RDS")



# simulation 2
tic()
set.seed(12345)
map <- genspmap(n=20, P=20000, save_movements=T)
phase1 <- . %>%
  move_uniform(m=0.1, s=10) %>%
  meet(cn=4, cp=5, im=2, parallel = T) %>%
  move_back()

map2 <- run(map, phase1, days = 21, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)

phase2 <- . %>%
  move_uniform(m=0.01, s=2) %>%
  meet(cn=2, cp=3, im=1, parallel = T) %>%
  move_back()

map3 <- run(map2, phase2, days = 21, ir=0.25)
toc()
plot(map3) +
  ggplot2::ggtitle("Simulation 2 (20000 in 20x20)")

saveRDS(map3, "simulation2.RDS")



# simulation 3
tic()
set.seed(12345)
map <- genspmap(n=20, P=20000, save_movements=T)
phase1 <- . %>%
  move_uniform(m=0.05, s=10) %>%
  meet(cn=2, cp=5, im=2, parallel = T) %>%
  move_back()

map2 <- run(map, phase1, days = 21, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)

phase2 <- . %>%
  move_uniform(m=0.01, s=2) %>%
  meet(cn=1, cp=3, im=1, parallel = T) %>%
  move_back()

map3 <- run(map2, phase2, days = 21, ir=0.25)
toc()
plot(map3) +
  ggplot2::ggtitle("Simulation 3 (20000 in 20x20)")

saveRDS(map3, "simulation3.RDS")


# simulation 4
tic()
set.seed(12345)
map <- genspmap(n=20, P=20000, save_movements=T)
phase1 <- . %>%
  move_uniform(m=0.1, s=10) %>%
  meet(cn=4, cp=6, im=2, parallel = T) %>%
  move_back()

map2 <- run(map, phase1, days = 14, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.05)

plot(map2)

phase2 <- . %>%
  move_uniform(m=0.01, s=2) %>%
  meet(cn=2, cp=3, im=1, parallel = T) %>%
  move_back()

map3 <- run(map2, phase2, days = 28, ir=0.25, cfr=0.05)
toc()
plot(map3) +
  ggplot2::ggtitle("Simulation 4 (20000 in 20x20)")

saveRDS(map3, "simulation4.RDS")
