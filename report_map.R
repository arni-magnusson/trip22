## Prepare map

## Before: cities.csv, flights.csv (output)
## After:  map.pdf (report)

library(TAF)

mkdir("report")

library(ggplot2)  # map_data
library(maps)     # world

## Read city data
cities <- read.taf("output/cities.csv")
flights <- read.taf("output/flights.csv")

## Read world coordinates from 'maps' package, using ggplot2 tools
world <- map_data("world")
world$group <- as.integer(world$group)

## Combine two world maps, side by side
rownames(world) <- NULL
world2 <- rbind(world, transform(world, long=long-360, group=group+10000L))

## Plot (no projection)
pdf("report/map.pdf", width=12, height=6)
plot(NA, xlim=c(-255,165), ylim=c(-50,68), xlab="Lon", ylab="Lat")
map <- lapply(split(world2, world2$group), polygon)
points(Latitude~Longitude, cities, pch=16, cex=2, col="red")
with(flights, segments(Efrom, Nfrom, Eto, Nto))
dev.off()
