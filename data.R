## Preprocess data, write TAF data tables

## Before: cities.dat, flights.dat (bootstrap/data)
## After:  cities.csv, flights.csv (data)

library(TAF)
library(gmt)  # deg2num

mkdir("data")

## Read tables
cities <- read.table("bootstrap/data/cities.dat", header=TRUE)
flights <- read.table("bootstrap/data/flights.dat", header=TRUE)

## Convert degrees to numbers
cities$Latitude <- deg2num(cities$Latitude)
cities$Longitude <- deg2num(cities$Longitude)

## Save as TAF tables
write.taf(cities, dir="data")
write.taf(flights, dir="data")
