readr::read_csv("Abbreviations_and_Acronyms.csv", show_col_types = FALSE)

format_link <- function(label,url) {
  sprintf("[%s](%s)",label,url)
}

