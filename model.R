## Run analysis, write model results

## Before: cities.csv, flights.csv (data)
## After:  cities.csv, flights.csv (model)

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
homebound <- tail(cities$Airport, -which(cities$Airport=="SEA"))
cities$Longitude[cities$Airport %in% homebound] <-
  cities$Longitude[cities$Airport %in% homebound] - 360
flights$Efrom[flights$From %in% homebound] <-
  flights$Efrom[flights$From %in% homebound] - 360
flights$Eto[flights$To %in% c(homebound,"NOU")] <-
  flights$Eto[flights$To %in% c(homebound,"NOU")] - 360

## Create a second Noumea to return to
cities <- rbind(cities, cities[cities$City == "Noumea",])
cities$Longitude[nrow(cities)] <- cities$Longitude[nrow(cities)] - 360

# Calculate nights in each city
cities$Arrive <- flights$ArriveDate[match(cities$Airport, flights$To)]
cities$Depart <- flights$Date[match(cities$Airport, flights$From)]
cities$Arrive[1] <- min(cities$Arrive)             # Noumea start
cities$Depart[nrow(cities)] <- max(cities$Depart)  # Noumea end
cities$Depart[cities$City=="Athens"] <- "2022-12-18"  # Athens
cities$Depart[cities$City=="Hanoi"] <- "2023-01-12"   # Hanoi
cities$Stay <- as.integer(as.Date(cities$Depart) - as.Date(cities$Arrive))

## Calculate flight layover
connecting <- c(flights$Date[-1] == flights$ArriveDate[-nrow(flights)], FALSE)
layover <- num2deg(c(deg2num(flights$TakeOff[-1]) -
                     deg2num(flights$Landing[-nrow(flights)]), 0), zero=TRUE)
layover <- sub(":00$", "", layover)
flights$Layover <- ifelse(connecting, layover, "")

## Write results
write.taf(cities, dir="model")
write.taf(flights, dir="model")
