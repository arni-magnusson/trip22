## Extract results of interest, write TAF output tables

## Before: airbnb.csv, cities.csv, flights.csv (model)
## After:  airbnb.csv, cities.csv, flights.csv (output)

library(TAF)

mkdir("output")

cp("model/airbnb.csv", "output")
cp("model/cities.csv", "output")
cp("model/flights.csv", "output")
