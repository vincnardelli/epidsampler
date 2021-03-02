
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
