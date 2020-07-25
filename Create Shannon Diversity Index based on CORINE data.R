# https://gis.stackexchange.com/questions/151962/calculating-shannons-diversity-using-moving-window-in-r

library(raster)
library(vegan)

setwd("C:/Users/woute/Desktop/Bsal-connectivity/Raw data/CORINE")
CLC2018 <- raster("CLC_clip2.img")  

# Among the most popular of metrics used to quantify landscape composition are Shannon's index, believed to emphasize the richness component of diversity, and Simpson's index, emphasizing the evenness component. There is a need for caution when choosing an index of landscape diversity. Rare cover types provide habitats for sensitive species and facilitate critical ecological processes. The Shannon index, sensitive to their presence, is therefore recommended for landscape management within an ecological framework. Simpson's index, more responsive to the dominant cover type, can be used for specific situations where the dominant cover type is of interest, such as single-species reserve design.

# Calculate focal ("moving window") weight matrix, and reset elements to 0s and 1s rather than true weights. The number indicates the radius of the circle of the moving window, in the units of the coordinate system (dec deg in our case). The here used 0.0416666665 is aprox. 5 km.
fw <- focalWeight(CLC2018, 0.0416666665, 'circle')
fw <- ifelse(fw == 0, NA, 1)

# Create a custom version of vegan::diversity that can be applied to a raster;
shannonVegan <- function(x, ...) {
  diversity(table(x), index="shannon")
}
shanVegOut <- focal(CLC2018, fw, fun=shannonVegan, pad=T)  

writeRaster(shanVegOut, filename = "shannoncorine.img", format = "HFA", overwrite=TRUE)
