library(epidsampler)
# vignette example
set.seed(12345)
map <- generate(n=25, P=1000, type="grid")
print(map)
phase1 <- . %>%
  move_uniform(m=0.2, s=3) %>%
  meet(cn=3, cp=4, im=2) %>%
  move_back()

map <- run(map, phase1, days = 21, tE=5, tA=14,
            tI=14, ir=1, cfr=0.15)

phase2 <- . %>%
  move_uniform(m=0.01, s=1) %>%
  meet(cn=2, cp=3, im=1) %>%
  move_back()

map <- run(map, phase2, days = 21, ir=1)
plot(map)
