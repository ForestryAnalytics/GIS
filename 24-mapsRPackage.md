
The maps library for R is a powerful tool for creating maps of countries and
regions of the world. For example, you can create a map of the USA and its
states in just three lines of code:
Simple Maps examples


```R

library(maps)
#data(states)


```

    Warning message in data(states):
    "data set 'states' not found"


```R
map(state, interior = FALSE)
map(state, boundary = FALSE, col=gray, add = TRUE)

```


    Error in maptype(database): object 'state' not found
    Traceback:


    1. map(state, interior = FALSE)

    2. maptype(database)

