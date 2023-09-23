library(rvest)
library(furrr)
library(sf)
library(ggplot2)
library(svglite)
library(jsonlite, include.only = "fromJSON")

plan(multisession)

# get all the store raw html, read it in, extract & parse json
list.files("output", pattern = "html$", full.names = TRUE) |>
  future_map(
    \(.x) {
      read_html(.x) |>
        html_nodes("script#js-map-config-dir-map") |>
        html_text() |>
        jsonlite::fromJSON() # rite-aid devs conveniently left us some nice JSON to use
    }, .progress = TRUE
  ) -> store_info

do.call(
  rbind.data.frame,
  store_info |>
    lapply(
      getElement, "locs"
    )
) -> xdf

svglite("map.svg")

(xdf |>
  st_as_sf(
    coords = c("longitude", "latitude"),
    crs = "wgs84"
  ) |>
  ggplot() +
  geom_sf(
    size = 0.125,
    alpha = 1 / 2
  ) +
  coord_sf(crs=5070) +
  labs(title = "Rite-Aid Locations") +
  theme_minimal()) 

dev.off()

xdf$altTagText # address
xdf$latitude
xdf$longitude

# direct store info
jsonlite::fromJSON(
  sprintf("https://www.riteaid.com/services/ext/v2/stores/getStores?count=1&radius=50&storeNumbers=%s", xdf$corporateCode[[1]])
)
