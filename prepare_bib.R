library(RefManageR)
library(lubridate)
library(rmarkdown)

getwd()
file.remove(list.files("_publications/"))

bib_db <- ReadBib("bibliography/callaghan-publications.bib")

entries <- bibentry(bib_db)

entries <- entries[grepl("\\w", entries$Title), ]

dates <- ymd(paste(entries$Year, entries$Month, "01", sep = "-"))

print(dates)

n <- 0
for (i in order(dates, decreasing = TRUE)) {
  n <- n + 1
  e <- entries[i, ]
  print(e)
  e$Title <- gsub("[{}]", "", e$Title)
  fname <- sprintf("_publications/%03d.md", n)
  authors <- strsplit(e$Author, " and ")[[1]]
  authors <- ifelse(grepl("Callaghan", authors), paste0("<b>", authors, "</b>"), authors)
  e$Author <- paste(authors, collapse = ", ")
  e$Journal <- gsub("\\\\", "", e$Journal)
  e$Author <- latex_to_text(e$Author)
  cat("\\nocite{", e$ID, "}\n", file = "_cv/nocite.tex", append = TRUE)
  
  rendered_template <- render(template, e = e, i = n)
  writeLines(rendered_template, fname)
}