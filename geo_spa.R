
#Investigating SOC loss under forest to cropland conversion. 
#A comparison of Germany and France.
rm(list=ls())
library(tidyverse)
library(terra)
library(sf)
library(ggplot2)
library(readxl)
library(geodata)

# Country boundaries (GADM level 0) for Germany and France.
# For Germany
germany_boundary <- gadm(country="DEU",level=0, path=tempdir())
plot(germany_boundary,border='black',lwd=2)

# For France
france_boundary <- gadm(country="FRA", level=0, path=tempdir())
plot(france_boundary,border='black',lwd=2)

# SOC data are taken from SoilGrids at 0–5 cm depth, the topmost soil layer.
# Values are in dg/kg (decigrams of carbon per kg of soil).
soc_world <- soil_world("soc",depth=5, path=tempdir())

# The rasters are then cropped and masked to Germany and France,
# so only soil pixels within each country are kept.
plot(soc_world)
soc_germany <- crop(soc_world,germany_boundary)
soc_germany<- mask(soc_germany,germany_boundary )
plot(soc_germany)

soc_france <- crop(soc_world, france_boundary)
soc_france <- mask(soc_france,france_boundary)
plot(soc_france)

#SOC level in two countries.
s_germany <- global(soc_germany,mean,na.rm=TRUE)
s_france <- global(soc_france,mean,na.rm=TRUE)
print(s_germany)
print(s_france)

#On average, total carbon stored in the topsoil across the entire country.
# dg/kg
mean_fg <- data.frame(
  country=c("Germany","France"),
  meanvalue=c(s_germany$mean,s_france$mean)
)
print(mean_fg)

#FOR LAND COVER - Forest and Cropland
tree_world <- landcover (var="trees",tempdir())
cropland_world <- landcover (var="cropland",tempdir())

##For Germany and France
tree_g <- crop(tree_world,germany_boundary)
tree_g <- mask(tree_g,germany_boundary)

crop_g<- crop(cropland_world, germany_boundary)
crop_g <- mask (crop_g,germany_boundary)

tree_f <- crop(tree_world,france_boundary)
tree_f <-mask (tree_f, france_boundary)

crop_f <- crop(cropland_world,france_boundary)
crop_f <- mask(crop_f,france_boundary)

plot(tree_g)
plot(crop_g)

plot(tree_f)
plot(crop_f)
#trees_g- forest area of Germany
#crop_g- cropland area of Germany
#trees_f- forest of France
#crop_f- cropland of France

#Now, need to check if the SOC and land-cover raster have the same pixel size. 
res(soc_germany)    
res(tree_g)
res(soc_france)
res(tree_f)
res(soc_germany)    
res(crop_g)
res(soc_france)
res(crop_f)

# here both layers have the same resolution.
# thus, no resampling or adjustments needed
print(crop_g)
print(crop_f)
print(crop_g)
print(crop_f)

#defined forest as pixels where tree cover fraction > 0.3
# Mask SOC to forest areas only.
#Forest SOC of Germany
forest_mask_g <- tree_g > 0.3
forest_soc_g  <- mask(soc_germany, forest_mask_g, 
                      maskvalue=0)
mean_forest_g <- global(forest_soc_g, "mean", na.rm=TRUE)
print(mean_forest_g)

# Cropland SOC of Germany
# 1 = cropland, 0 = not cropland
crop_soc_g  <- mask(soc_germany, crop_g, maskvalue=0)
mean_crop_g <- global(crop_soc_g, "mean", na.rm=TRUE)
print(mean_crop_g)

# Forest SOC of France
forest_mask_f <- tree_f > 0.3
forest_soc_f  <- mask(soc_france, forest_mask_f, maskvalue=0)

mean_forest_f <- global(forest_soc_f, "mean", na.rm=TRUE)
print(mean_forest_f)

# Cropland SOC of France
crop_soc_f  <- mask(soc_france, crop_f, maskvalue=0)
mean_crop_f <- global(crop_soc_f, "mean", na.rm=TRUE)
print(mean_crop_f)

#RESULT#
#The difference (Forest SOC - Cropland SOC) represents the potential SOC loss per unit area if forest were converted to cropland. 
#A larger negative % change means greater loss.

results_diff <- data.frame(
  Country    = c("Germany", "France"),
  Forest_SOC = c(75.44, 73.42),
  Cropland_SOC = c(67.24, 58.13),
  Difference = c(75.44-67.24, 73.42-58.13),
  Percnt_change   = c(((67.24 - 75.44) / 75.44) * 100,  ((58.13 - 73.42) / 73.42) * 100))
  
  print(results_diff)
#France loses ALMOST TWICE as much SOC when going from forest to cropland.
#France loses roughly TWICE as much SOC (in relative terms)
# when converting forest to cropland.
  
print(results_diff)

#VISUALIZATION
#The bar chart shows the absolute SOC difference between forest and cropland for each country.
#Negative values confirm that cropland stores less carbon than forest in both cases but the gap is far less for France.
ggplot(results_diff,
       aes(x=Country, y= Difference, fill=Country)) +
  geom_col(width=0.5) +
  scale_fill_manual(values=c(
    "Germany" = "lightgreen",
    "France"  = "blue")) +labs( title   = "SOC difference- Forest to Cropland", subtitle = "Source SoilGrids ", x       = "Country",
    y       = "Change in Difference ", caption = "Negative = SOC loss when converting forest to cropland"
  ) 


##END##


