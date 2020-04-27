
<!-- README.md is generated from README.Rmd. Please edit that file -->

# occupancy

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![R build
status](https://github.com/reconhub/occupancy/workflows/R-CMD-check/badge.svg)](https://github.com/reconhub/occupancy/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/occupancy)](https://CRAN.R-project.org/package=occupancy)
[![Codecov test
coverage](https://codecov.io/gh/tjtnew/occupancy/branch/master/graph/badge.svg)](https://codecov.io/gh/reconhub/occupancy?branch=master)
<!-- badges: end -->

> Hospital Bed Occupancy Forecasting

`occupancy` implements forecasting of daily bed occupancy from input
data on daily admissions and the distribution of duration of stay. It
aims to provide a reliable and standardised approach to forecasting that
will help improve the quality and ease of provision of predictions going
forward.

## Installing the package

Whilst this package is not yet on cran, the development version can be
installed using `devtools`:

``` r
devtools::install_github("reconhub/occupancy")
```

## Functionality

For an introduction to the packages’ functionality see view the
`Introduction` vignette.

``` r
vignette("Introduction", package = "occupancy")
```
