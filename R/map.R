library(ggplot2)  # map_data
library(maps)     # world
library(gmt)      # deg2num

# Read world coordinates from 'maps' package, using ggplot2 tools
world <- map_data("world")
world$group <- as.integer(world$group)
rownames(world) <- NULL

# Combine two world maps, side by side
world2 <- rbind(world, transform(world, long=long-360, group=group+10000L))

# Plot (no projection)
dir.create("../pdf", showWarnings=FALSE)
pdf("../pdf/map.pdf", width=12, height=6)
plot(NA, xlim=c(-250,165), ylim=c(-50,68), xlab="Lon", ylab="Lat")
map <- lapply(split(world2, world2$group), polygon)
dev.off()
