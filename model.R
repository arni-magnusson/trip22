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
flights$Nfrom <- cities$Latitude[match(flights$From, cities$Airport)]
flights$Efrom <- cities$Longitude[match(flights$From, cities$Airport)]
flights$Nto <- cities$Latitude[match(flights$To, cities$Airport)]
flights$Eto <- cities$Longitude[match(flights$To, cities$Airport)]

## Calculate flight distance, value, and speed
flights$Distance <- with(flights, round(geodist(Nfrom, Efrom, Nto, Eto)))
flights$Value <- round(flights$Distance / flights$Cost)
flights$Speed <- round(flights$Distance / deg2num(flights$Duration), -1)

## Move selected cities 360 degrees
return <- c("ICN", "HAN", "SGN", "SYD", "HBA", "BNE")
cities$Longitude[cities$Airport %in% return] <-
  cities$Longitude[cities$Airport %in% return] - 360
flights$Efrom[flights$From %in% return] <-
  flights$Efrom[flights$From %in% return] -360
flights$Eto[flights$To %in% c(return,"NOU")] <-
  flights$Eto[flights$To %in% c(return,"NOU")] -360

## Create a second Noumea to return to
cities <- rbind(cities, cities[cities$City == "Noumea",])
cities$Longitude[nrow(cities)] <- cities$Longitude[nrow(cities)] - 360

## Write results
write.taf(cities, dir="model")
write.taf(flights, dir="model")
