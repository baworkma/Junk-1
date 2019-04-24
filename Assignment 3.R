# Halie Brown, Assignment 3
# 3-30-19

#SetWD
setwd("~/Desktop/Data")

#Install/load packages

install.packages('scales')
devtools::install_github('walkerke/tigris', force = TRUE)
devtools::install_github('bhaskarvk/leaflet.extras', force = TRUE)

library(devtools)
library(leaflet)
library(glue)
library(dplyr)
library(sf)
library(tmap)
library(tmaptools)
library(tidycensus)
library(htmltools)
library(htmlwidgets)
library(ggplot2)
library(ggmap)
library(tigris)
library(tidyverse)
library(scales)

#Import your data
ar_poverty <- read_shape("/Users/heb006/Desktop/Data/ArkPoverty/acs2017_5yr_B17019_05000US05055.shp", 
as.sf = TRUE)

#Check it out
colnames(ar_poverty)

#We care about columns: 
# 1 - geoid
# 2 - name
# 3 - B17019001 (total) 
# 5 - B17019002 (Income in the Past 12 months below Poverty)
# 49 - geometry

head(ar_poverty)

#Rename columns
ar_poverty = ar_poverty[-1,]
names(ar_poverty)[2:3] <- c("County", "TotalIncome")
names(ar_poverty)[5] <- ("PovertyIncome")
#
head(ar_poverty)
#
#Calculate poverty rate: Divide PovertyIncome into TotalIncome

ar_poverty$poverty_rate <- (ar_poverty$PovertyIncome/ar_poverty$TotalIncome)

#It took me five million years to reteach myself how to do that
#Steal Dad's (a.k.a. Alex Nicoll's) code to round and make it better

ar_poverty$poverty_rate <- paste(round((ar_poverty$PovertyIncome/ar_poverty$TotalIncome)*100,digits=0),"%",sep="")

#Hot dog it worked, also it now has percentages
#Map it
tmap_mode("view")
qtm(ar_poverty, fill = "poverty_rate", )

tm_shape(ar_poverty) +
  tm_polygons(col = "poverty_rate", id = "County")

ar_income_map <- tm_shape(ar_poverty) +
  tm_polygons(col = "poverty_rate", id = "County")

tmap_save(ar_income_map, "AR_PovertyCounties_Map.html")

#I feel like something is missing? But we're done!

