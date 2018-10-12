

```R

## Pipe-based workflows and tidyverse

When _both_ `sf` and `dplyr` are loaded, a number of generic methods in the `tidyverse` become available for `sf` objects. They are:
```{r}
m1 = attr(methods(class = "sf"), "info")$generic
library(tidyverse)
m2 = attr(methods(class = "sf"), "info")$generic
noquote(setdiff(m2, m1))
```
Most of these do little more than simply make sure the returned object is of class `sf` again, but some of them do more, e.g. `summarise` by default aggregates (unions) the summarised geometries:
```{r, plot=TRUE}
cent <- st_geometry(nc) %>% st_centroid %>% st_coordinates 
nc1 <- nc %>% 
  mutate(area = as.numeric(st_area(.)), longitude = cent[,1]) %>%
  group_by(cut(longitude,4))  %>% 
  summarise(area = sum(area), BIR79 = sum(BIR79), dens = mean(BIR79/area))
ggplot(nc1) + geom_sf(aes(fill = dens))
```

## Array data: rasters, spatial time series

Although `sp` has some simple infrastructure for them in the `Spatial` class framework, raster data in R are best handled by the `raster` package. It is feature-rich, well integrated with the `Spatial` class framework, and can deal with massive rasters, as long as they fit on the local disk. It does not integrate particularly well with the tidyverse, or with simple features. Neither does it handle four- or higher-dimensional dimensional data (e.g. x,y.t,color), or time series data for features.

A follow-up project of the "simple features for R" project tries to address a number of these issues

## Summary/outlook

In comparison to `sp`, package `sf`

* implements all types and classes of simple features
* has no support for gridded (raster) data
* uses `data.frame`s for features, and list columns for feature geometry
* uses S3 instead of S4
* is also built on top of GDAL, GEOS and Proj.4
* tries to provide a simpler and cleaner API (or user experience) conversions to/from `sp` makes it still easy to work "backwards"

What's really new, and better in `sf`, compared to `sp`?

* simple features is a widely adopted standard
* tidyverse compatibility
* ggplot2 support (`install_github`, under development)
* support for measurement [units](https://edzer.github.io/units/)
* partial support for computations using geographic coordinates
* support by [mapview](https://cran.r-project.org/package=mapview), [tmap](https://cran.r-project.org/package=tmap), [mapedit](https://github.com/r-spatial/mapedit); 15 revdeps on CRAN
* binary geom ops: fast (indexed), low memory footprint; flexible `st_join`
* (c)lean Rcpp interface to external dependencies GDAL/GEOS/Proj.4
* fast WKB (de)serialization, in C++

Still to do:

* make `ggplot2::geom_sf` more robust and versatile
* further improve support for geographic coordinates (s2?)
* time series for simple features
* raster data, raster-sf integration [stars](https://github.com/r-spatial/stars) - see my UseR! talk
* scale from in-memory to in-database with spatial operations, similar to what `dplyr` does
```
