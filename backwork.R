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
