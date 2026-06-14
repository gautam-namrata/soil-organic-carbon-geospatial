# Soil Organic Carbon Under Forest vs Cropland Land Use
## SOC Comparison: Germany vs France

---

## 1. Overview

This project extracts and compares Soil Organic Carbon (SOC) at **0–5 cm depth** for Germany and France using open spatial datasets, with a focus on how land cover (forest vs cropland) affects SOC storage.

---

## 2. Data Sources

| Data | Source | Function / Access | Details |
|------|--------|-------------------|---------|
| Soil Organic Carbon | SoilGrids via `geodata` | `soil_world()` | Depth: 0–5 cm |
| Land Cover (trees & cropland) | ESA WorldCover via `geodata` | `landcover()` | Variables: `trees`, `cropland` |
| Country Boundaries | GADM | `gadm()` | Level 0 (national) |

---

## 3. Methods

1. Downloaded national boundaries for Germany (`DEU`) and France (`FRA`) using GADM
2. Extracted global SOC raster and cropped/masked to each country boundary
3. Extracted global land cover rasters (tree cover and cropland) and cropped/masked similarly
4. Verified that SOC and land cover rasters share the same resolution before masking
5. Defined **forest** as pixels with tree cover fraction **> 0.3** (30%)
6. Masked SOC separately to forest and cropland areas for each country
7. Computed mean SOC per land use class per country using `global(..., "mean")`
8. Calculated absolute difference and percentage change (forest → cropland)
9. Visualised results with a bar chart (`ggplot2`) and exported summary to CSV

---

## 4. Key Results

| Country | Forest SOC (dg/kg) | Cropland SOC (dg/kg) | Difference | % Change |
|---------|--------------------|----------------------|------------|----------|
| Germany | 75.44 | 67.24 | −8.20 | −10.87% |
| France  | 73.42 | 58.13 | −15.29 | −20.83% |

> **Finding:** France loses nearly **twice as much SOC** when converting forest to cropland compared to Germany.

---

## 5. Tools & Packages

```r
install.packages(c("terra", "sf", "geodata", "tidyverse", "ggplot2", "readxl"))
```

| Package | Purpose |
|---------|---------|
| `terra` | Raster operations (crop, mask, global stats) |
| `sf` | Vector spatial data handling |
| `geodata` | Downloading GADM boundaries, SoilGrids, and land cover data |
| `tidyverse` | Data wrangling |
| `ggplot2` | Visualisation |
| `readxl` | Reading Excel files (for any supplementary tabular input) |

---

## 6. Output Files

| File | Description |
|------|-------------|
| `Result_geospatial.csv` | Summary table with SOC values, differences, and % change |
| Plot (in-session) | Bar chart of SOC difference (forest vs cropland) by country |

---

## 7. Notes

- Bulk density layers were manually downloaded from SoilGrids but are currently **commented out** in the script — intended for future SOC stock calculations (SOC stock = SOC × bulk density × depth)
- SOC units follow SoilGrids convention: **dg/kg** at 0–5 cm
- All raster layers were confirmed to share the same spatial resolution before masking
