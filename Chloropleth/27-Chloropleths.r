
install.packages("maptools")
install.packages("rgdal")
require("maptools")
require("ggplot2")
require("plyr")
require("rgdal")
library(rgdal)
library(maptools)
if (!require(gpclib)) install.packages("gpclib", type="source")
gpclibPermit()



counties <- readOGR("http://raw.githubusercontent.com/DragonflyStats/IRLOGI-GSI/master/IEmapdata/IRL_adm1.shp")
