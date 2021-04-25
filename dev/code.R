library(epidsampler)

# Example polygon ----

set.seed(12345)
map <- generate(n=7, P=200, type="polygon", save_movements = T)
phase1 <- . %>%
  move_uniform(m=0.01, s=2) %>%
  meet(cn=2, cp=3, im=2, parallel = T) %>%
  move_back()

map <- run(map, phase1, days = 5, tE=5, tA=14,
           tI=14, ir=1, cfr=0.15)
print(map)
plot(map)



# Check animation  ----
set.seed(12345)
map <- generate(n=7, P=200, type="polygon", save_movements = T)
phase1 <- . %>%
  move_attraction(m=0.05, a=100) %>%
  move_back()

map <- run(map, phase1, days = 3, tE=5, tA=14,
           tI=14, ir=1, cfr=0.15)



# test attraction ---

map <- generate(n=16, P=200, type="grid", save_movements = T)
phase2 <- . %>%
  move_attraction(m=0.1)

map <- run(map, phase2, days = 5, tE=5, tA=14,
           tI=14, ir=1, cfr=0.15)


animate_map(map)


# Move attraction custom ---
map <- generate(n=7, P=200, type="polygon", save_movements = T)
phase2 <- . %>%
  move_attraction(m=0.1, a=a)

map <- run(map, phase2, days = 5, tE=5, tA=14,
           tI=14, ir=1, cfr=0.15)


print(map)
plot(map)
animate_map(map)


# Example grid ----

set.seed(12345)
map <- generate(n=25, P=1000, type="grid", save_movements = T)
phase1 <- . %>%
  move_uniform(m=0.2, s=5) %>%
  meet(cn=2, cp=5, im=2, parallel = T) %>%
  move_back()

map <- run(map, phase1, days = 7*3, tE=5, tA=14,
           tI=14, ir=1, cfr=0.15)

phase2 <- . %>%
  move_uniform(m=0.05, s=1) %>%
  meet(cn=1, cp=3, im=1, parallel = T) %>%
  move_back()

map <- run(map, phase2, days = 7*3, tE=5, tA=14,
           tI=14, ir=1, cfr=0.15)

plot(map)
