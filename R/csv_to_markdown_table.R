format_link <- function(label, url) {
  sprintf("[%s](%s)", label, url)
}

csv_to_markdown_table <- function(csv_path) {
  readr::read_csv(csv_path, show_col_types = FALSE) %>%
    dplyr::mutate(
      Wiki_Link = dplyr::case_when(
        is.na(Wiki_Link) ~ NA,
        .default = format_link("Wikipedia", .data$Wiki_Link)
      ),
      Reference_Link = dplyr::case_when(
        is.na(Reference_Link) ~ NA,
        .default = format_link("Reference", .data$Reference_Link)
      )
    ) %>%
    dplyr::arrange(.data$Abbreviation) %>%
    knitr::kable() %>%
    readr::write_lines("README.md")
}

csv_to_markdown_table("Abbreviations_and_Acronyms.csv")
