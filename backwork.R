library(rnaturalearth)
library(tmap)

ne_countries <- ne_download(scale = 50, type = "countries", category = "cultural")
ne_grat_30 <- ne_download(scale = 50, type = "graticules_30", category = "physical")
ne_bbox <- ne_download(scale = 50, type = "wgs84_bounding_box", category = "physical")

st_write(ne_bbox, "ne_bbox.shp")

tm_shape(ne_countries) + tm_polygons() +
  tm_shape(ne_grat_30) + tm_lines() +
  tm_shape(ne_bbox) + tm_borders() +
  tm_layout(frame = FALSE)

library(viridis)

data(world)
world <- st_as_sf(world)
wpp_2022 <- read_rds("wpp_2022.rds")
my_wpp <- wpp_2022 |> 
  filter(year == 2024)
world_data <- world |>
  left_join(my_wpp, join_by(iso_a2 == ISO2))

tm_shape(world_data, projection = "+proj=robin") +
  tm_graticules(labels.show = FALSE) + tm_layout(frame = FALSE) +
  tm_polygons(col = "TFR", style = "cont", palette = "viridis")


sido_shp <- st_read("sido.shp", options = "ENCODING=CP949")
sigungu_shp <- st_read("sigungu.shp", options = "ENCODING=CP949")
data_sigungu <- read_rds("data_sigungu.rds")
sigungu_data <- sigungu_shp |> 
  left_join(
    data_sigungu, join_by(SGG1_CD == C1)
  )

class_color <- c("#d7191c", "#fdae61", "#ffffbf", "#a6d96a", "#1a9641")

tm_shape(sigungu_data) + 
  tm_polygons(
    col = "index", style = "fixed", palette = class_color, 
    breaks = c(0, 0.2, 0.5, 1.0, 1.5, Inf), 
    labels = c("< 0.2", "0.2 ~ 0.5", "0.5 ~ 1.0", 
               "1.0 ~ 1.5", ">= 1.5"), 
    title = "Classes"
  ) +
  tm_shape(sido_shp) + tm_borders(lwd = 2) +
  tm_legend(
    legend.position = c(0.7, 0.1)
  ) +
  tm_scale_bar(breaks = seq(0, 200, 50), position = c(0.6, 0.01)) 

