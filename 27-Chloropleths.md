
### what is a chloropleth?



```R
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


```

    Installing package into '/home/nbcommon/R'
    (as 'lib' is unspecified)
    Installing package into '/home/nbcommon/R'
    (as 'lib' is unspecified)
    Loading required package: maptools
    Loading required package: sp
    Checking rgeos availability: TRUE
    Loading required package: ggplot2
    Loading required package: plyr
    Loading required package: rgdal
    rgdal: version: 1.1-10, (SVN revision 622)
     Geospatial Data Abstraction Library extensions to R successfully loaded
     Loaded GDAL runtime: GDAL 1.11.3, released 2015/09/16
     Path to GDAL shared files: /usr/share/gdal/1.11
     Loaded PROJ.4 runtime: Rel. 4.9.2, 08 September 2015, [PJ_VERSION: 492]
     Path to PROJ.4 shared files: (autodetected)
     Linking to sp version: 1.2-3 



FALSE


    Loading required package: gpclib
    Warning message in library(package, lib.loc = lib.loc, character.only = TRUE, logical.return = TRUE, :
    "there is no package called 'gpclib'"Installing package into '/home/nbcommon/R'
    (as 'lib' is unspecified)
    Warning message in gpclibPermit():
    "support for gpclib will be withdrawn from maptools at the next major release"


TRUE



```R
counties <- readOGR("http://raw.githubusercontent.com/DragonflyStats/IRLOGI-GSI/master/IEmapdata/IRL_adm1.shp")
```


    Error in readOGR("http://raw.githubusercontent.com/DragonflyStats/IRLOGI-GSI/master/IEmapdata/IRL_adm1.shp"): missing layer
    Traceback:


    1. readOGR("http://raw.githubusercontent.com/DragonflyStats/IRLOGI-GSI/master/IEmapdata/IRL_adm1.shp")

    2. stop("missing layer")

