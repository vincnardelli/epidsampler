library(epidsampler)
library(dplyr)
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
map <- genspmap(n=10, P=5000, save_movements=T)
print(map)
phase1 <- . %>%
  move_uniform(m=0.1, s=3) %>%
  meet(cn=4, cp=5, im=2) %>%
  move_back()

map2 <- run(map, phase1, days = 21, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)
plot(map2)




map <- map3




map <- genspmap(n=5, P=1000, save_movements=T)
phase1 <- . %>%
  move_uniform(m=0.1, s=3) %>%
  meet(cn=4, cp=5, im=2) %>%
  move_back()

map <- run(map, phase1, days = 7, tE=5, tA=14,
            tI=14, ir=0.25, cfr=0.15)

animate_map(map, height=400, width=400)



library(ggplot2)
library(gganimate)




df <- map$data %>%
  group_by(t, condition) %>%
  summarise(count=n())

p <- ggplot(df) +
  geom_line(aes(t, count, color=condition)) +
  theme_minimal() +
  scale_y_continuous(trans='log2') +
  scale_color_manual(values=c( "S"="blue","D"='black', "I"= 'red4', 'E'="red", 'R'='darkolivegreen4', "A"="orange")) +
  #geom_text(data = df %>% ungroup() %>% filter(t == max(t)), aes(label = condition,x = t + 1,y = count,color = condition)) +
  ggtitle("SEIRD graph") +
  transition_reveal(t)

graph <- animate(p, end_pause = 30, height = 800, width =800, res = 150, nframes=21*10*2, fps=10, renderer = gifski_renderer())

map <- animate(points, end_pause = 30, height = 800, width =800, res = 150, nframes=21*10*2, fps=10, renderer = gifski_renderer())

library(magick)

a <- image_read(graph[[1]])
b <- image_read(map[[1]])
# combine the two images into a single image
combined <- image_append(c(a,b))
new_gif <- c(combined)
for(i in 2:100){ # combine images frame by frame
  a <- image_read(graph[[i]])
  b <- image_read(map[[i]])
  combined <- image_append(c(a,b))
  new_gif <- c(new_gif,combined)
}

# make an animation of the combined images
combined_gif <- image_animate(new_gif)
# save as gif
image_write(combined_gif, "predictor_disr_and_ROC.gif")
