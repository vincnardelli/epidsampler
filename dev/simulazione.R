library(epidsampler)

set.seed(12345)


map <- genspmap(5, P=10000, rho=0.8)


map <- map %>%
  addsteps(n=7*3, m=0.05, s=3,
           cn=10, cp=5,
           im=3, tE=5, tA=14,
           tI=14, ir=0.25, cfr=0.15) %>%
  addsteps(n=7*5, m=0.01, s=1,
           cn=1, cp=2,
           im=3, tE=5, tA=14,
           tI=14, ir=0.25, cfr=0.15)


map$data %>%
  group_by(t, condition) %>%
  summarise(count=n()) %>%
  ggplot() +
  geom_line(aes(t, count, color=condition)) +
  theme_minimal() +
  scale_y_continuous(trans='log2') +
  scale_color_manual(values=c( "S"="blue","D"='black', "I"= 'red4', 'E'="red", 'R'='darkolivegreen4', "A"="orange")) +
  ggtitle("SEIRD graph")



# Some animations
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
  ggtitle("SEIRD graph")

p

p <-  p +
  transition_reveal(t)

animate(p, end_pause = 30, height = 800, width =1200, res = 150, nframes=400, fps=10)



t <- map$data %>%
  group_by(t, x, y, condition) %>%
  summarise(n = n()) %>%
  filter(condition== "I") %>%
  ggplot() +
  geom_tile(aes(x, y, fill=n)) +
  # geom_point(data=map$data, aes(x, y)) +
  theme_void() +
  scale_fill_gradient(low = "#D3AA99", high="#912B00")


t <- t +
  transition_states(t, 0) + labs(title = 'Day: {closest_state}') +  enter_fade() + exit_fade()

animate(t, end_pause = 30, height = 800, width =800, res = 150,  nframes=400, fps=10)


t <- map$data %>%
  group_by(t, x, y, condition) %>%
  summarise(n = n()) %>%
  filter(condition== "S", t >3) %>%
  ggplot() +
  geom_tile(aes(x, y, fill=n)) +
  # geom_point(data=map$data, aes(x, y)) +
  theme_void() +
  scale_fill_gradient(low = "#2a9df4", high="#03254c")


t <- t +
  transition_states(t, 0) + labs(title = 'Day: {closest_state}') +  enter_fade() + exit_fade()

animate(t, end_pause = 30, height = 800, width =800, res = 150,  nframes=400, fps=10)

ggplot(map$data) +
  geom_jitter(data=map$data, aes(x, y, color=condition), width = 0.25, height = 0.25, ) +
  scale_color_manual(values=c( "S"="blue","D"='black', "I"= 'red4', 'E'="red", 'R'='darkolivegreen4', "A"="orange")) +
  theme_void()


points <- map$data %>%
  filter(condition != "D") %>%
  ggplot() +
  geom_jitter(data=map$data, aes(x, y, color=condition), width = 0.1, height = 0.1, ) +
  scale_color_manual(values=c( "S"="blue","D"='black', "I"= 'red4', 'E'="red", 'R'='darkolivegreen4', "A"="orange")) +
  theme_void() +
  transition_time(t)
animate(points, end_pause = 30, height = 800, width =800, res = 150, nframes=400, fps=10)

