
#SOC from SoilGrids for Germany and France.
# This is done to understand what are the differences in SOC values between two countries if they change forest into cropland 
rm(list=ls())
library(tidyverse)
library(terra)
library(sf)
library(ggplot2)
library(readxl)
library(geodata)

#Extracting the Boundary of GERMANY AND FRANCE using (G)
germany_boundary <- gadm(country="DEU",level=0, path=tempdir())
france_boundary <- gadm(country="FRA", level=0, path=tempdir())
print(germany_boundary)
plot(germany_boundary,border='black',lwd=2)
plot(france_boundary,border='black',lwd=2)

#Extracting Soil Organic Carbon(SOC) from Soil Grids

soc_world <- soil_world("soc",depth=5, path=tempdir())

####SOC for Germany and France#
plot(soc_world)
soc_germany <- crop(soc_world,germany_boundary)
soc_germany<- mask(soc_germany,germany_boundary )
plot(soc_germany)

soc_france <- crop(soc_world, france_boundary)
soc_france <- mask(soc_france,france_boundary)
plot(soc_france)

##bulk density###MANUALLY DOWNLOADED FROM SOILGRIDS#####
#bulk_germany<- rast('/Users/namratagautam/Downloads/out (1).tif')
#print(bulk_germany)
#plot(bulk_germany)
#bulk_france <- rast('/Users/namratagautam/Downloads/out (2).tif')
#plot(bulk_france)

###ST###
s_germany <- global(soc_germany,mean,na.rm=TRUE)
s_france <- global(soc_france,mean,na.rm=TRUE)
print(s_germany)
print(s_france)

mean_fg <- data.frame(
  country=c("Germany","France"),
  meanvalue=c(s_germany,s_france)
)

print(mean_fg)


###FOR LAND COVER- using  (on forest)

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


#####C

#Define Forest and cropland
###Since the resolution might be different. It is now necessary to match the pixels.
##CHECK IF they match or not / the distance
res(soc_germany)    
res(tree_g)

res(soc_france)
res(tree_f)

res(soc_germany)    
res(crop_g)

res(soc_france)
res(crop_f)

##The pixel matched
print(crop_g)
print(crop_f)
print(crop_g)
print(crop_f)

# Mask SOC to forest areas only
# Where tree cover > 0.3 = forest

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

# Forest SOC — France
forest_mask_f <- tree_f > 0.3
forest_soc_f  <- mask(soc_france, forest_mask_f, maskvalue=0)

mean_forest_f <- global(forest_soc_f, "mean", na.rm=TRUE)
print(mean_forest_f)

# Cropland SOC — France
crop_soc_f  <- mask(soc_france, crop_f, maskvalue=0)
mean_crop_f <- global(crop_soc_f, "mean", na.rm=TRUE)

print(mean_crop_f)

# Add difference
results_diff <- data.frame(
  Country    = c("Germany", "France"),
  Forest_SOC = c(75.44, 73.42),
  Cropland_SOC = c(67.24, 58.13),
  Difference = c(75.44-67.24, 73.42-58.13),
  Percnt_change   = c(((67.24 - 75.44) / 75.44) * 100,  ((58.13 - 73.42) / 73.42) * 100))
  
  print(results_diff)
#France loses ALMOST TWICE as much SOC when going from forest to cropland.
  
print(results_diff)

###PLOT
ggplot(results_diff,
       aes(x=Country, y=Difference, fill=Country)) +
  geom_col(width=0.5) +
  scale_fill_manual(values=c(
    "Germany" = "darkgreen",
    "France"  = "blue")) +labs( title   = "SOC difference- Forest to Cropland", subtitle = "Source SoilGrids ", x       = "Country",
    y       = "Change in Difference ", caption = "Negative = SOC loss when converting forest to cropland"
  ) 





