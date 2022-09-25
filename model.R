## Run analysis, write model results

## Before: cities.csv, flights.csv (data)
## After:  cities.csv, flights.csv (model)

library(TAF)
library(gmt)  # geodist

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

## Move selected cities 360 degrees
return <- cities$Airport %in% c("ICN", "HAN", "SGN", "SYD", "HBA", "BNE")
cities$Longitude[return] <- cities$Longitude[return] - 360

## Create Noumea to return to
cities <- rbind(cities, cities[cities$City == "Noumea",])
cities$Longitude[nrow(cities)] <- cities$Longitude[nrow(cities)] - 360

## Write results
write.taf(cities, dir="model")
write.taf(flights, dir="model")
