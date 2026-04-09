# mtaOpenData

[![CRAN
status](https://www.r-pkg.org/badges/version/mtaOpenData)](https://CRAN.R-project.org/package=mtaOpenData)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/grand-total/mtaOpenData?color=blue)](https://r-pkg.org/pkg/mtaOpenData)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![Project Status:
Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Codecov test
coverage](https://codecov.io/gh/martinezc1/mtaOpenData/branch/main/graph/badge.svg)](https://app.codecov.io/gh/martinezc1/mtaOpenData)

`mtaOpenData` provides simple, reproducible access to MTA-related
datasets from the  
[NY State Open Data portal](https://data.ny.gov/) platform — directly
from R,  
with **no API keys** or manual downloads required. Working directly with
Socrata APIs can be cumbersome — `mtaOpenData` simplifies this process
into a clean, reproducible workflow.

Version **0.1.0** introduces a streamlined, catalog-driven interface for
MTA Open Data.

The package provides three core functions:

- [`mta_list_datasets()`](https://martinezc1.github.io/mtaOpenData/reference/mta_list_datasets.md)
  — Browse available datasets from the live MTA Open Data catalog
- [`mta_pull_dataset()`](https://martinezc1.github.io/mtaOpenData/reference/mta_pull_dataset.md)
  — Pull any cataloged dataset by key, with filtering, ordering, and
  optional date controls
- [`mta_any_dataset()`](https://martinezc1.github.io/mtaOpenData/reference/mta_any_dataset.md)
  — Pull any MTA Open Data dataset directly via its Socrata JSON
  endpoint

Datasets pulled via
[`mta_pull_dataset()`](https://martinezc1.github.io/mtaOpenData/reference/mta_pull_dataset.md)
automatically apply sensible defaults from the catalog (such as default
ordering and date fields), while still allowing user control over:

- limit
- filters
- date / from / to
- where
- order
- clean_names
- coerce_types

This redesign reduces maintenance burden, improves extensibility, and
provides a more scalable interface for working with MTA Open Data.

All functions return clean **tibble** outputs and support filtering
via  
`filters = list(field = "value")`.

------------------------------------------------------------------------

## Installation

### From **CRAN**

``` r
install.packages("mtaOpenData")
```

### Development version (GitHub)

``` r
devtools::install_github("martinezc1/mtaOpenData")
```

------------------------------------------------------------------------

## Example

``` r
library(mtaOpenData)

bus_stops <- mta_pull_dataset(dataset = "mta_bus_stops", limit = 5000)

head(bus_stops)
```

``` R
## # A tibble: 6 × 25
##   valid_from          valid_to            in_effect route_id route_short_name
##   <dttm>              <dttm>              <lgl>     <chr>    <chr>           
## 1 2020-11-20 00:00:00 2020-12-15 00:00:00 FALSE     QM3      QM3             
## 2 2020-11-20 00:00:00 2020-12-15 00:00:00 FALSE     QM44     QM44            
## 3 2020-11-20 00:00:00 2020-12-15 00:00:00 FALSE     SHNRD    SHNRD           
## 4 2020-10-28 00:00:00 2020-11-19 00:00:00 FALSE     YOAS     <NA>            
## 5 2021-10-19 00:00:00 2021-11-14 00:00:00 FALSE     CPAS     <NA>            
## 6 2021-10-19 00:00:00 2021-11-14 00:00:00 FALSE     YOAS     <NA>            
## # ℹ 20 more variables: route_long_name <chr>, route_description <chr>,
## #   route_color <chr>, stop_id <dbl>, stop_name <chr>, direction_id <dbl>,
## #   direction <chr>, revenue_stop <dbl>, timepoint <dbl>, boarding <dbl>,
## #   alighting <dbl>, is_cbd <lgl>, latitude <dbl>, longitude <dbl>,
## #   bundle <chr>, computed_region_wbg7_3whc <dbl>,
## #   computed_region_kjdx_g34t <dbl>, computed_region_yamh_8v7k <dbl>,
## #   georeference_type <chr>, georeference_coordinates <list>
```

## About

`mtaOpenData` makes New York State’s civic datasets accessible to
students,  
educators, analysts, and researchers through a unified and user-friendly
R interface.  
Developed to support reproducible research, open-data literacy, and
real-world analysis.

------------------------------------------------------------------------

## Comparison to Other Software

While the [`RSocrata`](https://CRAN.R-project.org/package=RSocrata)
package provides a general interface for any Socrata-backed portal,
`mtaOpenData` is specifically tailored for **New York State Open Data**.

This package is part of a broader ecosystem of tools for working with
New York open data:

- `mtaOpenData` — streamlined access to NYC Open Data  
- `nysOpenData` — streamlined access to NY State Open Data
- `mtaOpenData` — streamlined access to MTA-related NY State Open Data

Together, these packages provide a consistent, user-friendly interface
for working with civic data across jurisdictions.

- **Ease of Use**: No need to hunt for 4x4 dataset IDs (e.g.,
  `2ucp-7wg5`); use catalog-based keys instead.
- **Open Literacy**: Designed specifically for students and researchers
  to lower the barrier to entry for civic data analysis.

------------------------------------------------------------------------

## Contributing

We welcome contributions! If you find a bug or would like to request a
wrapper for a specific mta dataset, please open an issue or submit a
pull request on [GitHub](https://github.com/martinezc1/mtaOpenData).

------------------------------------------------------------------------

## Authors & Contributors

### Maintainer

**Christian A. Martinez** 📧 <c.martinez0@outlook.com>  
GitHub: [@martinezc1](https://github.com/martinezc1)
