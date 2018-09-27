

```R

## Reference systems

If one wants to know which position of the Earth we refer to, coordinates of geospatial data require a reference system:

* geodesic/geographic coordinates need an order (long/lat or lat/long?), a unit (rad, degree?) and a datum (a reference ellipsoid: WGS84, ETRS89, NAD27?)
* projected coordinates (e.g. UTM, web Mercator) need also measurement units, and some way of encoding how they relate to geodesic coordinates, in which datum (the Proj.4 string)

To handle coordinate reference systems, convert coordinates (projections) and do datum transformations, [Proj.4](http://proj4.org/) is the code base most widely adopted, and maintained, by the open source geospatial community.

Package `sf` has `crs` objects that register coordinate reference systems:
```{r}
st_crs("+proj=longlat +datum=WGS84")  # "Proj.4 string"
st_crs(3857)                          # EPSG code
st_crs(3857)$units                    # reveal units
st_crs(NA)                            # unknown (assumed planar/Cartesian)
```

`crs` objects are registered as an attribute of geometry collections.

## sf: handling real data

### reading and writing spatial data

```{r}
fname = system.file("shape/nc.shp", package = "sf")
nc = read_sf(fname)
print(nc, n = 3)
plot(nc)
```

### coordinate transformation/conversion

* `st_transform`: transforms or converts coordinates to new reference system

```{r}
(a1 = st_area(nc[1,]))                      # area, using geosphere::areaPolygon
(a2 = st_area(st_transform(nc[1,], 32119))) # NC state plane, m
(a3 = st_area(st_transform(nc[1,], 2264)))  # NC state plane, US foot
units::set_units(a1, km^2)
units::set_units(a2, km^2)
units::set_units(a3, km^2)
```

From here on, we will work with the `nc` dataset in projected coordinates:
```{r}
nc = st_transform(nc, 32119) # NC state plane, m
```

## Methods for simple features

A complete list of methods for a particular class is obtained, after loading the class, by
```{r, eval = FALSE}
methods(class = "sf")
```

### book keeping, low-level I/O

* `st_as_text`: convert to WKT     
* `st_as_binary`: convert to WKB
* `st_as_sfc`: convert geometries to `sfc` (e.g., from WKT, WKB)
* `as(x, "Spatial")`: convert to `Spatial*`
* `st_as_sf`: convert to sf (e.g., convert from `Spatial*`)


### logical binary geometry predicates

* `st_intersects`: touch or overlap
* `st_disjoint`: !intersects
* `st_touches`: touch
* `st_crosses`: cross (don't touch)
* `st_within`: within
* `st_contains`: contains
* `st_overlaps`: overlaps
* `st_covers`: cover
* `st_covered_by`: covered by
* `st_equals`: equals
* `st_equals_exact`: equals, with some fuzz

returns a sparse (default) or dense logical matrix:
```{r}
nc1 = nc[1:5,]
st_intersects(nc1, nc1)
st_intersects(nc1, nc1, sparse = FALSE)
```

### geometry generating logical operators

* `st_union`: union of several geometries
* `st_intersection`: intersection of pairs of geometries
* `st_difference`: difference between pairs of geometries
* `st_sym_difference`: symmetric difference (`xor`)

```{r, fig=TRUE}
opar = par(mfrow = c(1,2))
ncg = st_geometry(nc[1:3,])
plot(ncg, col = sf.colors(3, categorical = TRUE))
u = st_union(ncg)
plot(u, lwd = 2)
plot(st_intersection(ncg[1], ncg[2]), col = 'red', add = TRUE)
plot(st_buffer(u, 10000), border = 'blue', add = TRUE)
# st_buffer(u, units::set_unit(10, km)) # with sf devel
plot(st_buffer(u, -5000), border = 'green', add = TRUE)
par(opar)
```

### higher-level operations: summarise, interpolate, aggregate, st_join

* `aggregate` and `summarise` use `st_union` (by default) to group feature geometries
* `st_interpolate_aw`: area-weighted interpolation, uses `st_intersection` to interpolate or redistribute attribute values, based on area of overlap:
* `st_join` uses one of the logical binary geometry predicates (default: `st_intersects`) to join records in table pairs

```{r}
g = st_make_grid(nc, n = c(20,10))
a1 = st_interpolate_aw(nc["BIR74"], g, extensive = FALSE)
sum(a1$BIR74) / sum(nc$BIR74) # not close to one: property is assumed spatially intensive
a2 = st_interpolate_aw(nc["BIR74"], g, extensive = TRUE)
sum(a2$BIR74) / sum(nc$BIR74)
#a1$intensive = a1$BIR74
#a1$extensive = a2$BIR74
#plot(a1[c("intensive", "extensive")])
a1$what = "intensive"
a2$what = "extensive"
# devtools::install_github("tidyverse/ggplot2")
library(ggplot2)
l = st_cast(nc, "LINESTRING")
ggplot() + geom_sf(data = rbind(a1,a2), aes(fill = BIR74)) + 
	geom_sf(data = l, col = 'lightgray') + facet_grid(what~.) +
    scale_fill_gradientn(colors = sf.colors(10))
```

Example of `st_join`:
```{r}
nrow(nc)
x = st_join(nc, nc)
nrow(x) # neighbours AND each state with itself
x = st_join(nc, nc, join = st_touches)
nrow(x) # neighbours, now excluding itself
st_rook = function(a, b, prepared) st_relate(a, b, pattern = "F***1****")
x = st_join(nc, nc, join = st_rook)
nrow(x) # "rook" neighbours: touch over a line, not in a point
# which states touch another state in a point only?
sel = unlist(st_relate(nc, nc, pattern = "F***0****"))
plot(st_geometry(nc))
plot(st_geometry(nc[sel,]), add = TRUE, col = 'grey')
```

see also [this issue](https://github.com/edzer/sfr/issues/234).

Which points touch four states?

```{r}
pts = st_intersection(nc, nc)
pts = pts[st_dimension(pts) == 0, ]
plot(st_geometry(nc))
plot(st_geometry(nc[sel,]), add = TRUE, col = 'grey')
plot(st_geometry(pts), add = TRUE, col = '#ff000044', pch = 16)
# how many neighbours does each of these points have?
unique(lengths(st_intersects(pts, nc)))
```
```
