# Use the Wikipedia API to convert wikipedia urls to wikidata ids

# The eventual goal is to use wikidata to query for a number of other
# interesting terms, such as pages in other languages, or perpaps some sort of
# categorisation for filtering in the terms list
library(dplyr)

get_pageprops <- function(title, domain) {
  httr2::request(glue::glue("https://{domain}.wikipedia.org/w/api.php")) |>
    httr2::req_url_query(
      action = "query",
      prop = "pageprops",
      titles = title,
      format = "json"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("query", "pages") |>
    purrr::map_dfr(\(x) purrr::pluck(x, "pageprops")) |>
    dplyr::mutate(Wiki_Link = paste0("https://en.wikipedia.org/wiki/", title))

}

wikidata_ids <-
  readr::read_csv("Abbreviations_and_Acronyms.csv",
                show_col_types = FALSE) |>
  dplyr::filter(stringr::str_detect(Wiki_Link, "wikipedia")) |>
  dplyr::pull(Wiki_Link) |>
  # basename() |>
  unique() |>
  na.omit() |>
  purrr::map_dfr(\(x) get_pageprops(basename(x), stringr::str_extract(
    x, "[a-z]{2}(?=\\.)"
  )))

wikidata_ids |>
  dplyr::mutate(wikidata_obj = dplyr::case_when(
    !is.na(wikibase_item) ~ purrr::map(WikidataR::get_item(wikibase_item)),
    .default = NA))

