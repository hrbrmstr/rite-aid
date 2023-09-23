library(rvest)
library(stringi)

# ur structure of a region collection page: "https://www.riteaid.com/locations/ca.html"

# get all the rite aid states
pg <- read_html("https://www.riteaid.com/locations/index.html")

# find the links to states or direct stores
html_nodes(pg, xpath = ".//a[contains(@class, 'c-directory-list-content-item-link')]") |> 
  map_chr(html_attr, "href") -> top_hrefs

# some will be states
state_hrefs <- grep("^[[:alpha:]]{2}\\.html", top_hrefs, value = TRUE)

# some will be direct links to stores so save them out
store_direct_hrefs <- grep("^[[:alpha:]]{2}\\.html", top_hrefs, invert = TRUE, value = TRUE)

# get state page listings
sprintf("https://www.riteaid.com/locations/%s", state_hrefs) |> 
  map(read_html) -> state_pgs

# extract the links from the state page listings
state_pgs |> 
  map(
    \(.x) {
      html_nodes(.x, xpath = ".//a[contains(@class, 'c-directory-list-content-item-link')]") |> 
        map_chr(html_attr, "href")
    }
  ) |> 
  unlist() -> region_hrefs

# any path with more than one `/` is a direct store href
path_cts <- stri_count_fixed(region_hrefs, "/")

store_direct_hrefs <- c(store_direct_hrefs, region_hrefs[path_cts > 1])

# get the regional listings hrefs
region_hrefs <- sprintf("https://www.riteaid.com/locations/%s", region_hrefs[path_cts == 1])

# get the regional listings
region_hrefs |> 
  map(read_html) -> region_pgs
  
# get the stores from the regional listings
region_pgs |> 
  map(
    \(.x) {
      html_nodes(.x, xpath = ".//a[contains(@itemprop, 'url')]") |> 
        map_chr(html_attr, "href")
    }
  ) |> 
  unlist() -> tree_1_hrefs # did not know if there'd be a sub-tree/next pages/etc

# many of the region pages have address info but we're going to run
# a batch process and save off all the HTML pages for posterity, so
# we won't be using them.

# save out all the urls so we can run curl in the background
sprintf("https://www.riteaid.com/locations/%s", c(store_direct_hrefs, sub("../", "", tree_1_hrefs))) |> 
  writeLines("input-urls.txt")
