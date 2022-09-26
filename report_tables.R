## Prepare formatted tables

## Before: airbnb.csv, cities.csv, flights.csv (data) (output)
## After:  airbnb.csv, flights.csv (report)

library(TAF)

mkdir("report")

## Read tables
airbnb <- read.taf("output/airbnb.csv")
cities <- read.taf("output/cities.csv")
flights <- read.taf("output/flights.csv")

## Format airbnb
airbnb$Arrive <- format(as.Date(airbnb$Arrive), "%a %d %b")
airbnb$Stay <- paste(airbnb$Stay, "nights")

## Format flights
flights$Notes <- ifelse(flights$Date == flights$ArriveDate, "", "+1 day")
flights$Date <- format(as.Date(flights$Date), "%a %d %b")
flights$From <- cities$City[match(flights$From, cities$Airport)]
flights$To <- cities$City[match(flights$To, cities$Airport)]
flights <- flights[c("Date","From","To","TakeOff","Landing","Notes","Layover")]
names(flights)[names(flights)=="TakeOff"] <- "Departure"
names(flights)[names(flights)=="Landing"] <- "Arrival"

## Save as TAF tables
write.taf(airbnb, dir="report")
write.taf(flights, dir="report")
