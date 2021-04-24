library(sf)
library(dplyr)
library(ggplot2)


x <- runif(10, 0, 1)
y <- runif(10, 0, 1)

points <- data.frame(id=as.character(1:10), x, y) %>%
  st_as_sf(coords = c("x", "y"))


box = c(xmin = 0, ymin = 0, xmax = 1, ymax = 1)

# compute Voronoi polygons
voronoi_grid <- points %>%
  st_geometry() %>%
  do.call(c, .) %>%
  st_voronoi(bOnlyEdges=FALSE) %>%
  st_collection_extract() %>%
  st_crop(box)


plot(voronoi_grid)

points$pols <- st_intersects(points, voronoi_grid) %>% unlist %>% voronoi_grid[.]


ggplot() +
  geom_sf(data=voronoi_grid) +
  geom_sf(data=points)


