
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
# library(broom)

# data from http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/population-distribution-demography/geostat
# Originally seen at http://spatial.ly/2014/08/population-lines/

# The result of the code below can be seen at http://imgur.com/ob8c8ph

# library(tidyverse)

DataSet1 <- read_csv('https://raw.githubusercontent.com/RWorkshop/IRLOGI-datasets/master/GEOSTAT_grid_POP_1K_2011_V2_0_1.csv') 
DataSet2 <- read_csv('https://raw.githubusercontent.com/RWorkshop/IRLOGI-datasets/master/JRC-GHSL_AIT-grid-POP_1K_2011.csv')




# ggsave('/tmp/europe.png', width=10, height=10)

head(DataSet1)

head(DataSet2)

combinedData <- rbind(DataSet1,DataSet2) 
head(combinedData)



summary(combinedData)

allData <- combinedData %>%
          mutate(TOT_P_CON_DT='')

head(allData)

allData <- allData %>%
  mutate(lat = as.numeric(gsub('.*N([0-9]+)[EW].*', '\\1', GRD_ID))/100,
         lng = as.numeric(gsub('.*[EW]([0-9]+)', '\\1', GRD_ID)) * ifelse(gsub('.*([EW]).*', '\\1', GRD_ID) == 'W', -1, 1) / 100) %>%
  filter(lng > 25, lng < 60) 
head(allData)

summaryData <- allData %>%
  group_by(lat=round(lat, 1), lng=round(lng, 1)) %>%
  summarize(value = sum(TOT_P, na.rm=TRUE))  

dim(summaryData)



finalData <- summaryData %>%
  ungroup() %>%
  complete(lat, lng)

finalData %>%
  ggplot(aes(lng, lat + 5*(value/max(value, na.rm=TRUE)))) +
    geom_line(size=0.4, alpha=0.8, color='#5A3E37', aes(group=lat), na.rm=TRUE) +
    ggthemes::theme_map() +
    coord_equal(0.9)
