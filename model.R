## Run analysis, write model results

## Before: cities.csv, flights.csv (data)
## After:  airbnb.csv, cities.csv, flights.csv (model)

library(TAF)
library(gmt)  # deg2num, geodist

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
  flights$Efrom[flights$From %in% return] - 360
flights$Eto[flights$To %in% c(return,"NOU")] <-
  flights$Eto[flights$To %in% c(return,"NOU")] - 360

## Create a second Noumea to return to
cities <- rbind(cities, cities[cities$City == "Noumea",])
cities$Longitude[nrow(cities)] <- cities$Longitude[nrow(cities)] - 360

## Calculate flight layover
connecting <- c(flights$Date[-1] == flights$ArriveDate[-nrow(flights)], FALSE)
layover <- num2deg(c(deg2num(flights$TakeOff[-1]) -
                     deg2num(flights$Landing[-nrow(flights)]), 0), zero=TRUE)
layover <- sub(":00$", "", layover)
flights$Layover <- ifelse(connecting, layover, "")

## Airbnb table (based on flights)
airbnb <- data.frame(
  Arrive=head(flights$ArriveDate, -1),
  City=head(cities$City[match(flights$To, cities$Airport)], -1),
  Depart=flights$Date[-1])
airbnb <- airbnb[airbnb$Arrive != airbnb$Depart,]
## One Athens booking rather than two
airbnb$Arrive[airbnb$City=="Athens"] <-
  min(airbnb$Arrive[airbnb$City=="Athens"])
airbnb$Depart[airbnb$City=="Athens"] <-
  max(airbnb$Depart[airbnb$City=="Athens"])
airbnb <- unique(airbnb)
airbnb$Stay <- as.integer(as.Date(airbnb$Depart) - as.Date(airbnb$Arrive))
airbnb <- airbnb[c("Arrive", "City", "Stay")]

## Indicate whether we overnight in a city
cities$Overnight <- cities$City %in% airbnb$City
cities$Overnight[cities$City == "Noumea"] <- TRUE

## Write results
write.taf(airbnb, dir="model")
write.taf(cities, dir="model")
write.taf(flights, dir="model")
