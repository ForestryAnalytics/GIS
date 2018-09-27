

The R-markdown source of the tutorial is found [here](https://raw.githubusercontent.com/edzer/UseR2017/master/tutorial.Rmd).
#### Required packages:




```R
install.packages('sf')
library(sf)
```

    Installing package into '/home/nbcommon/R'
    (as 'lib' is unspecified)
    Warning message:
    "package 'sf' is not available (for R version 3.3.0)"


    Error in library(sf): there is no package called 'sf'
    Traceback:


    1. library(sf)

    2. stop(txt, domain = NA)



```R
# install.packages(c("sf", "tidyverse", "devtools"))


devtools::install_github("tidyverse/ggplot2")
```

    Downloading GitHub repo tidyverse/ggplot2@master
    from URL https://api.github.com/repos/tidyverse/ggplot2/zipball/master



    Error in system(full, intern = quiet, ignore.stderr = quiet, ...): error in running command
    Traceback:


    1. devtools::install_github("tidyverse/ggplot2")

    2. install_remotes(remotes, quiet = quiet, ...)

    3. vapply(remotes, install_remote, ..., FUN.VALUE = logical(1))

    4. FUN(X[[i]], ...)

    5. source_pkg(bundle, subdir = remote$subdir)

    6. source_pkg_info(path = path, subdir = subdir)

    7. decompress(path, outdir)

    8. my_unzip(src, target)

    9. system_check(unzip, args, quiet = TRUE)

    10. suppressWarnings(withr::with_dir(path, withr::with_envvar(env_vars, 
      .     system(full, intern = quiet, ignore.stderr = quiet, ...))))

    11. withCallingHandlers(expr, warning = function(w) invokeRestart("muffleWarning"))

    12. withr::with_dir(path, withr::with_envvar(env_vars, system(full, 
      .     intern = quiet, ignore.stderr = quiet, ...)))

    13. force(code)

    14. withr::with_envvar(env_vars, system(full, intern = quiet, ignore.stderr = quiet, 
      .     ...))

    15. force(code)

    16. system(full, intern = quiet, ignore.stderr = quiet, ...)



## A short history of handling spatial data in R

* pre-2003: several people doing spatial statistics or map manipulation with S-Plus, and later R (e.g. spatial in MASS; spatstat, maptools, geoR, splancs, gstat, ...)
* 2003: workshop at [DSC](https://www.r-project.org/conferences/DSC-2003/), agreement that a package with base classes would be useful
* 2003: start of [r-sig-geo](https://stat.ethz.ch/mailman/listinfo/r-sig-geo)
* 2003: [rgdal](https://cran.r-project.org/package=rgdal) released on CRAN
* 2005: [sp](https://cran.r-project.org/package=sp) released on CRAN
* 2008: [Applied Spatial Data Analysis with R](http://www.asdar-book.org/)
* 2011: [rgeos](https://cran.r-project.org/package=rgeos) released on CRAN
* 2013: second edition of [Applied Spatial Data Analysis with R](http://www.asdar-book.org/)
* 2016-7: [simple features for R](https://cran.r-project.org/package=sf), R consortium support
* 2017-8: [spatiotemporal tidy arrays for R](https://github.com/edzer/stars), R consortium support

## Simple feature access in R: package `sf`

Simple feature access is an [ISO standard](http://www.opengeospatial.org/standards/sfa) that is widely adopted. It is used in spatial databases, GIS, open source libraries, GeoJSON, GeoSPARQL, etc.

What is this about?

* _feature_: abstraction of real world phenomena (type, or instance)
* _simple feature_: feature with all geometric attributes described piecewise by straight line or planar interpolation between sets of points 
* 7 + 10 [types](https://en.wikipedia.org/wiki/Well-known_text#Well-known_binary), 68 classes, of which 7 used in like 99% of the use cases
* support for mixe d type (`GEOMETRYCOLLECTION`), and type mix (`GEOMETRY`)
* empty geometry (like `NA`)
* text and binary serialisations (WKT, WKB)


links to 
[GEOS](https://trac.osgeo.org/geos/), 
[GDAL](http://www.gdal.org/), 
[Proj.4](http://proj4.org/), 
[liblwgeom](https://github.com/postgis/postgis/tree/svn-trunk/liblwgeom); see also the [package vignettes](https://cran.r-project.org/package=sf)

_access_ refers to standardised encodings, such as well-known text (WKT):



```R
```{r}
(pt = st_point(c(2,4)))
```

```

and well-known binary,



```R
(pt_bin = st_as_binary(pt))

```

the binary form in which spatial databases put geometries in BLOBs, binary large objects, converted back by


```R

st_as_sfc(list(pt_bin))[[1]]

```



as well as to _names_ of functions to manipulate objects, e.g.



```R

st_dimension(pt)
st_intersects(pt, pt, sparse = FALSE)

```


```R

package `sf` uses simple R structures to store geometries:
```


```R


str(pt)
str(st_linestring(rbind(c(0,0), c(0,1), c(1,1))))
str(st_polygon(list(rbind(c(0,0), c(0,1), c(1,1), c(0,0)))))

```




## Tidyverse, list-columns

According to the "tidy data" paper ([Wickham 2014](https://www.jstatsoft.org/article/view/v059i10)), data is tidy when

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

but it is not directly clear how this maps to geometries: should a coordinate dimension (e.g. latitude) for a column, should each coordinate (x,y pair) form a colum, or should a whole geometry (e.g. polygon, with holes), form a column? 

Early attempts (and ggplot2 up to version 2.2.1) wanted _simple_ columns, meaning each coordinate split over two columns. An approach called _fortify_ would mold (tidy?) polygons into simple `data.frame`s. 

It is [well known](https://github.com/tidyverse/ggplot2/wiki/plotting-polygon-shapefiles) that this approach has its limitations when polygons have holes.

Since the [UseR! 2016 keynote](https://channel9.msdn.com/Events/useR-international-R-User-conference/useR2016/Towards-a-grammar-of-interactive-graphics) of Hadley, list-columns have been declared tidy. 

One of the arguments for this was exactly this: polygons with holes are hard to represent in simple `data.frame`s. Other cases are: nested `data.frame`s, or columns that contain, for each record, a model object e.g. obtained from `lm`.

The tidy data rule for simple feature means: we have a `data.frame` **where each _feature_ forms a row**. A single column (a list-column) contains the geometry for each observation.

