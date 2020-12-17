library(epidsampler)
library(tictoc)

# Simulation 1

phase1 <- . %>%
  move_uniform(m=0.05, s=15) %>%
  meet(cn=5, cp=5, im=2, parallel = T) %>%
  move_back()

phase2 <- . %>%
  move_uniform(m=0.01, s=2) %>%
  meet(cn=2, cp=3, im=1, parallel = T) %>%
  move_back()


set.seed(12345)
tic()
map <- genspmap(n=20, P=20000, save_movements=T, rho=0)
map2 <- run(map, phase1, days = 4*7, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)
map3 <- run(map2, phase2, days = 6*7, ir=0.25)
toc()
plot(map3) +
  ggplot2::ggtitle("Simulation 1 (20000 in 20x20)")

saveRDS(map3, "simulation1_00.RDS")

set.seed(12345)
tic()
map <- genspmap(n=20, P=20000, save_movements=T, rho=0.3)
map2 <- run(map, phase1, days = 4*7, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)
map3 <- run(map2, phase2, days = 6*7, ir=0.25)
toc()
plot(map3) +
  ggplot2::ggtitle("Simulation 1 (20000 in 20x20)")

saveRDS(map3, "simulation1_03.RDS")

set.seed(12345)
tic()
map <- genspmap(n=20, P=20000, save_movements=T, rho=0.5)
map2 <- run(map, phase1, days = 4*7, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)
map3 <- run(map2, phase2, days = 6*7, ir=0.25)
toc()
plot(map3) +
  ggplot2::ggtitle("Simulation 1 (20000 in 20x20)")

saveRDS(map3, "simulation1_05.RDS")

set.seed(12345)
tic()
map <- genspmap(n=20, P=20000, save_movements=T, rho=0.7)
map2 <- run(map, phase1, days = 4*7, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)
map3 <- run(map2, phase2, days = 6*7, ir=0.25)
toc()
plot(map3) +
  ggplot2::ggtitle("Simulation 1 (20000 in 20x20)")

saveRDS(map3, "simulation1_07.RDS")
