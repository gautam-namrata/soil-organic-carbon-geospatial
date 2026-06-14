# Soil Organic Carbon Under Forest vs Cropland Land Use
# SOC Comparison: Germany vs France

---

## 1. Overview

This project extracts and compares Soil Organic Carbon (SOC) at 0-5 cm depth for Germany and France using open spatial datasets, with a focus on how land cover (forest vs cropland) affects SOC storage.

---

## 2. Data Sources

- SOC: SoilGrids, geodata, with the use of soil_world(), 0–5 cm depth
- Land Cover: ESA WorldCover through geodata::landcover()
- Boundaries: GADM Level 0

---

## 3. Methods

1. Downloaded national boundaries, SOC raster, and land cover rasters for both countries
2. Cropped and masked all layers to each country boundary
3. Defined forest as pixels with tree cover greater than 30%
4. Masked SOC separately to forest and cropland areas
5. Computed mean SOC per land use class per country

---

## 4. Key Results

| Country | Forest SOC | Cropland SOC | Difference | % Change |
|---------|-----------|--------------|------------|----------|
| Germany | 75.44 dg/kg | 67.24 dg/kg | 8.20 | -10.87% |
| France  | 73.42 dg/kg | 58.13 dg/kg | 15.29 | -20.83% |

France loses nearly twice the SOC when converting forest to cropland compared to Germany.

---

## 5. Tools & Packages

terra, sf, geodata, tidyverse, ggplot2
