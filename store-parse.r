library(rvest)
library(jsonlite, include.only = "fromJSON")

# get all the store raw html, read it in, extract & parse json
list.files("output", pattern = "html$", full.names = TRUE) |>
  lapply(read_html) |>
  lapply(html_nodes, "script#js-map-config-dir-map") |>
  lapply(html_text) |>
  lapply(
    jsonlite::fromJSON # rite-aid devs conveniently left us some nice JSON to use
  ) -> store_info

do.call(
  rbind.data.frame,
  store_info |>
  lapply(
    getElement, "locs"
  )
) -> xdf

xdf$altTagText # address
xdf$latitude
xdf$longitude

# direct store info
jsonlite::fromJSON(
  sprintf("https://www.riteaid.com/services/ext/v2/stores/getStores?count=1&radius=50&storeNumbers=%s", xdf$corporateCode[[1]])
)
