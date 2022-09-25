## Run analysis, write model results

## Before: cities.csv, flights.csv (data)
## After:  flights.csv (model)

library(TAF)

mkdir("model")

## Read data
cities <- read.taf("data/cities.csv")
flights <- read.taf("data/flights.csv")

## Look up flight start and end points
Nfrom <- cities$Latitude[match(flights$From, cities$Airport)]
Efrom <- cities$Longitude[match(flights$From, cities$Airport)]
Nto <- cities$Latitude[match(flights$To, cities$Airport)]
Eto <- cities$Longitude[match(flights$To, cities$Airport)]

## Calculate flight distance, value, and speed
flights$Distance <- round(geodist(Nfrom, Efrom, Nto, Eto))
flights$Value <- round(flights$Distance / flights$Cost)
flights$Speed <- round(flights$Distance / deg2num(flights$Duration), -1)

## Write results
write.taf(flights, dir="model")
