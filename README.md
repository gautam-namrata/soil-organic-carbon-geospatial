# Soil Organic Carbon Under Forest vs Cropland Land Use
# SOC Comparison: Germany vs France

---

## 1. Overview

This project investigates how converting forest to cropland affects Soil Organic Carbon (SOC), and compares the difference of SOC loss between Germany and France.
SOC  plays a major role in the global carbon cycle. When forests are cleared for agriculture, soil carbon built up over decades is rapidly lost  released into the atmosphere as CO₂. This analysis quantifies that loss using globally available soil and land cover datasets. 

## Research Question
How does forest to cropland conversion drive SOC loss differently across Germany and France?

---

## 2. Data Sources

1. SOC: SoilGrids, geodata, with the use of soil_world(), 0–5 cm depth.
2. Land Cover: ESA WorldCover through geodata, landcover().
3. Boundaries: GADM Level 0.

---

## 3. Methods

1. Downloaded national boundaries, SOC raster, and land cover rasters for both countries.
2. Cropped and masked all layers to each country boundary.
3. Defined forest as pixels with tree cover greater than 30%.
4. Masked SOC separately to forest and cropland areas.
5. Computed mean SOC per land use class per country.

---

## 4. Key Results

| Country | Forest SOC | Cropland SOC | Difference | % Change |
|---------|-----------|--------------|------------|----------|
| Germany | 75.44 dg/kg | 67.24 dg/kg | 8.20 | -10.87% |
| France  | 73.42 dg/kg | 58.13 dg/kg | 15.29 | -20.83% |

France loses nearly twice the SOC when converting forest to cropland compared to Germany.

---
## Limitations

1. Analysis uses only the 0–5 cm soil depth, SOC loss extends deeper and may be underestimated.
2. Forest threshold of > 0.30 tree cover fraction is commonly used in remote sensing but differs from the strict FAO definition (> 0.50)
3. No statistical significance testing was performed results are descriptive.


## 5. Tools & Packages

terra, sf, geodata, tidyverse, ggplot2, readxl
