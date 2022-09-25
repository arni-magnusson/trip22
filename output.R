## Extract results of interest, write TAF output tables

## Before: flights.csv (model)
## After:  flights.csv (output)

library(TAF)

mkdir("output")

cp("model/flights.csv", "output")
