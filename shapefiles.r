
library(maptools)
library(rgdal)     # R wrapper around GDAL/OGR
library(ggplot2)   # for general plotting
#library(ggmaps)    # for fortifying shapefiles
library(shapefiles)

crswgs84=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


urlfile<-'http://www.per.gov.ie/wp-content/uploads/Data-table-all-businesses.csv'
url(urlfile)

library(sp)
#states <- readShapePoly(urlfile,proj4string=crswgs84,verbose=TRUE)
states <- read.shapefile(url(urlfile))


states=readShapePoly("/home/mithil/java/R/statesp020.shp",proj4string=crswgs84,verbose=TRUE)


The shapefile is now read and stored into an object called “states”. readShapePoly function is used to read a shapefile that contains polygons. Lets explore the object that is created, beginning with what type it is.



> class(states)

So the object is of type SpatialPolygonsDataFrame. This comes from the sp package. This object has 5 slots – data, polygons, bbox, plotOrder,bbox, proj4string. data contains the information about the polygons, polygons contains the actual polygon coordinates, bbox is the bounding box drawn around the boundaries of the shapefile and the proj4string is the projection.


str(states@data)
str(states@polygons[[1]])
states@bbox
states@proj4string


#### How to plot a shapefile :
To see how the shapefile looks like or to create an image out of it use

> plot(states)
Selection_172

How to transform a shapefile :
To transform a shapefile to a different coordinate system use the spTransform method from the rgdal package. Lets transform our sp object to mercator projection

crsmerc=CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")
states_transformed<-spTransform(states,CRS=crsmerc)
How to check if a point falls inside a polygon :
One last but useful function that we will see in this post is the gContains function from the rgeos package. This function checks whether a polygon contains a point or more generally whether a geometry contains another geometry.


library(rgeos)
p<-SpatialPoints(list(lng,lat), proj4string=crswgs84)
gContains(fdg,pt)


gContains returns true or false depending on whether the polygon does or does not contain the point.

This post demonstrates the power of R in handling spatial data. The packages introduced in this post- maptools and rgeos are quite powerful and interested readers may want to go through the library documentation to see all the functionalities it provides

