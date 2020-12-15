library(epidsampler)

map <- genspmap(n=5)

str(map)


map2 <- move_uniform(map, m=0.05, s=4)


sum(map$data$x == map2$data$x)
