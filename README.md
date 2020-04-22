
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bedoc

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![R build
status](https://github.com/tjtnew/bedoc/workflows/R-CMD-check/badge.svg)](https://github.com/tjtnew/bedoc/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/bedoc)](https://CRAN.R-project.org/package=bedoc)
[![Codecov test
coverage](https://codecov.io/gh/tjtnew/bedoc/branch/master/graph/badge.svg)](https://codecov.io/gh/tjtnew/bedoc?branch=master)
<!-- badges: end -->

> Hospital Bed Occupancy Forecasting

`bedoc` implements forecasting of daily bed occupancy from input data on
daily admissions and the distribution of duration of stay. It aims to
provide a reliable and standardised approach to forecasting that will
help improve the quality and ease of provision of predictions going
forward.

## Installing the package

Whilst this package is not yet on cran, the development version can be
installed using `devtools`:

``` r
devtools::install_github("tjtnew/bedoc")
```

## Functionality

For an introduction to the packages’ functionality see view the
`Introduction` vignette.

``` r
vignette("Introduction", package = "bedoc")
```
