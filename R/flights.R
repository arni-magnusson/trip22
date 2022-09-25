library(gmt)  # deg2num, geodist

cities <- read.table("../data/cities.dat", header=TRUE)
flights <- read.table("../data/flights.dat", header=TRUE)

Nfrom <- deg2num(cities$Latitude[match(flights$From, cities$Airport)])
Efrom <- deg2num(cities$Longitude[match(flights$From, cities$Airport)])
Nto <- deg2num(cities$Latitude[match(flights$To, cities$Airport)])
Eto <- deg2num(cities$Longitude[match(flights$To, cities$Airport)])

flights$Distance <- round(geodist(Nfrom, Efrom, Nto, Eto))
flights$Value <- round(flights$Distance / flights$Cost)
flights$Speed <- round(flights$Distance / deg2num(flights$Duration), -1)
