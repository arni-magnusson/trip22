## Prepare formatted tables

## Before: cities.csv, flights.csv (data) (output)
## After:  cities.csv, flights.csv (report)

library(TAF)

mkdir("report")

## Read tables
cities <- read.taf("output/cities.csv")
flights <- read.taf("output/flights.csv")

## Format flights
flights$Notes <- ifelse(flights$Date == flights$ArriveDate, "", "+1 day")
flights$Date <- format(as.Date(flights$Date), "%a %d %b")
flights$From <- cities$City[match(flights$From, cities$Airport)]
flights$To <- cities$City[match(flights$To, cities$Airport)]
flights <- flights[c("Date","From","To","TakeOff","Landing","Notes","Layover")]
names(flights)[names(flights)=="TakeOff"] <- "Depart"
names(flights)[names(flights)=="Landing"] <- "Arrive"

## Format cities
cities <- cities[cities$Stay > 0,]
cities <- cities[c("Arrive", "City", "Stay")]
cities$Arrive <- format(as.Date(cities$Arrive), "%a %d %b")
cities$Stay <- paste(cities$Stay, "nights")

## Save as TAF tables
write.taf(cities, dir="report")
write.taf(flights, dir="report")
