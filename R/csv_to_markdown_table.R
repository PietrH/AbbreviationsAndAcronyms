readr::read_csv("Abbreviations_and_Acronyms.csv")

format_link <- function(label,url) {
  sprintf("[%s](%s)",label,url)
}

