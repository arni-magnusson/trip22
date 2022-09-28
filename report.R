library(TAF)
library(rmarkdown)

sourceTAF("report_map.R")
sourceTAF("report_tables.R")
render("report.Rmd")
sourceTAF("report_www.R")
