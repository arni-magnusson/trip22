## Produce index.html and supporting files

## Before: template.html, trip.css (boot/software),
#          cities.csv, flights.csv, map.svg (report)
## After:  index.html (root), map.svg, trip.css (www)

library(TAF)

mkdir("www")

## Read tables
cities <- read.taf("report/cities.csv")
flights <- read.taf("report/flights.csv")

## Copy files
cp("boot/software/trip.css", "www")
cp("boot/software/template.html", "index.html")
cp("report/map.svg", "www")

## Add tables and link
tab.flights <- taf2html(flights, file="index.html", append=TRUE,
                        align=c("R","R","L","L","L","L","R"))
tab.cities <- taf2html(cities, file="index.html", append=TRUE,
                       align=c("R","L","L"))
bottom <- '<p><a href="https://github.com/arni-magnusson/trip">source</a>\n'
cat(bottom, file="index.html", append=TRUE)
dos2unix("index.html")
