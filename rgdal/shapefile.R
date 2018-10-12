############################
require(rgdal)
require(rgeos)
 
# Read shapefile
shp = 'C:/temp/myshp.shp'
myshp = readOGR(shp, layer = basename(strsplit(shp, "\\.")[[1]])[1])
 
# Read shapefile attributes
df = data.frame(myshp)
 
# Simplify geometry using rgeos
simplified = gSimplify(myshp, tol = 1000, topologyPreserve=FALSE)
 
# Create a spatial polygon data frame (includes shp attributes)
spdf = SpatialPolygonsDataFrame(simplified, df)
 
# Write to shapefile
writeOGR(spdf, layer = 'myshp_simplified', 'C:/temp', driver="ESRI Shapefile")
############################
