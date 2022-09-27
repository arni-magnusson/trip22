## Extract results of interest, write TAF output tables

## Before: cities.csv, flights.csv (model)
## After:  cities.csv, flights.csv (output)

library(TAF)

mkdir("output")

cp("model/cities.csv", "output")
cp("model/flights.csv", "output")
