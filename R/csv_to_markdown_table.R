format_link <- function(label, url) {
  sprintf("[%s](%s)", label, url)
}

#' Convert a csv file to a markdown table
#'
#' Also convert two columns to markdown links
#'
#' @param csv_path Character. Path to csv file.
#'
#' @export
#'
csv_to_markdown_table <- function(csv_path) {
  readr::read_csv(csv_path, show_col_types = FALSE) %>%
    dplyr::mutate(
      Wiki_Link = dplyr::case_when(
        is.na(Wiki_Link) ~ "",
        .default = format_link("Wikipedia", Wiki_Link)
      ),
      Reference_Link = dplyr::case_when(
        is.na(Reference_Link) ~ "",
        .default = format_link("Reference", Reference_Link)
      )
    ) %>%
    dplyr::arrange(Abbreviation) %>%
    knitr::kable() %>%
    readr::write_lines("README.md")
}
