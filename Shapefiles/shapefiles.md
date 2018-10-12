
R has some very useful libraries for working with spatial data. 

In this blog we will look at some of the libraries and demonstrate few basic functionalities. Lets start with reading a shapefile.

### How to read a shapefile :
We will use the maptools package to read the shape file. 

Along with the maptools package, install the rgeos and sp packages. 
They will come handy later on.

To demonstrate reading a shapefile, we use the shapefile of US states which we download from here. 

The zip folder contains the file statesp020.shp which we will attempt to read. Lets first specify the projection that we want to use to read data in. The shapefile contains polygons in WGS84 projection, so lets define an object to hold that projection.



```R
library(maptools)
library(rgdal)     # R wrapper around GDAL/OGR
library(ggplot2)   # for general plotting
#library(ggmaps)    # for fortifying shapefiles
library(shapefiles)

crswgs84=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

```

The CRS class is present in the sp package and it holds the projection definition in proj4j format. We now read the shapefile



```R
urlfile<-'http://www.per.gov.ie/wp-content/uploads/Data-table-all-businesses.csv'
url(urlfile)
```


                                                                 description 
    "http://www.per.gov.ie/wp-content/uploads/Data-table-all-businesses.csv" 
                                                                       class 
                                                                       "url" 
                                                                        mode 
                                                                         "r" 
                                                                        text 
                                                                      "text" 
                                                                      opened 
                                                                    "closed" 
                                                                    can read 
                                                                       "yes" 
                                                                   can write 
                                                                        "no" 



```R
library(sp)
#states <- readShapePoly(urlfile,proj4string=crswgs84,verbose=TRUE)
states <- read.shapefile(url(urlfile))

```

    Warning message in file(shp.name, "rb"):
    "cannot open file '6.shp': No such file or directory"


    Error in file(shp.name, "rb"): cannot open the connection
    Traceback:


    1. read.shapefile(url(urlfile))

    2. read.shp(paste(shape.name, ".shp", sep = ""))

    3. file(shp.name, "rb")



```R
states=readShapePoly("/home/mithil/java/R/statesp020.shp",proj4string=crswgs84,verbose=TRUE)

```


    Error in getinfo.shape(filen): Error opening SHP file
    Traceback:


    1. readShapePoly("/home/mithil/java/R/statesp020.shp", proj4string = crswgs84, 
     .     verbose = TRUE)

    2. suppressWarnings(Map <- read.shape(filen = fn, verbose = verbose, 
     .     repair = repair))

    3. withCallingHandlers(expr, warning = function(w) invokeRestart("muffleWarning"))

    4. read.shape(filen = fn, verbose = verbose, repair = repair)

    5. getinfo.shape(filen)



```R
The shapefile is now read and stored into an object called “states”. readShapePoly function is used to read a shapefile that contains polygons. Lets explore the object that is created, beginning with what type it is.

```


    Error in parse(text = x, srcfile = src): <text>:1:5: unexpected symbol
    1: The shapefile
            ^
    Traceback:




```R

> class(states)

So the object is of type SpatialPolygonsDataFrame. This comes from the sp package. This object has 5 slots – data, polygons, bbox, plotOrder,bbox, proj4string. data contains the information about the polygons, polygons contains the actual polygon coordinates, bbox is the bounding box drawn around the boundaries of the shapefile and the proj4string is the projection.

```


    Error in parse(text = x, srcfile = src): <text>:2:1: unexpected '>'
    1: 
    2: >
       ^
    Traceback:




```R
str(states@data)
str(states@polygons[[1]])
states@bbox
states@proj4string

```


    Error in str(states@data): object 'states' not found
    Traceback:


    1. str(states@data)



```R
#### How to plot a shapefile :
To see how the shapefile looks like or to create an image out of it use

> plot(states)
Selection_172
```


```R
How to transform a shapefile :
To transform a shapefile to a different coordinate system use the spTransform method from the rgdal package. Lets transform our sp object to mercator projection

crsmerc=CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")
states_transformed<-spTransform(states,CRS=crsmerc)
How to check if a point falls inside a polygon :
One last but useful function that we will see in this post is the gContains function from the rgeos package. This function checks whether a polygon contains a point or more generally whether a geometry contains another geometry.

```


```R
library(rgeos)
p<-SpatialPoints(list(lng,lat), proj4string=crswgs84)
gContains(fdg,pt)

```


```R
gContains returns true or false depending on whether the polygon does or does not contain the point.

This post demonstrates the power of R in handling spatial data. The packages introduced in this post- maptools and rgeos are quite powerful and interested readers may want to go through the library documentation to see all the functionalities it provides

```
