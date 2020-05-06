#' Project bed occupancy from admissions
#'
#' This function projects bed occupancy using admission incidence and a
#'   distribution of length of stay (los).
#'
#' @param x Either a `\link[projections:build_projections]{projections}`
#'   object storing one or more integer forecasts of admissions or a
#'   `\link[incidence:incidence]{incidence}` object of known daily
#'   admissions.
#'
#' @param r_los A `function` with a single parameter `n` returning `n` `integer`
#'   values of lenth of hospital stay (LoS) in days. Ideally, this should come
#'   from a discrete random distribution, such as `rexp` or any `distcrete`
#'   object.
#'
#' @param n_sim The number of times duration of hospitalisation is simulated for
#'   each admission. Defaults to 10. Only relevant for low (<30) numbers of
#'   initial admissions, in which case it helps accounting for the uncertainty
#'   in LoS.
#'
#' @param last_date the last date to simulate until (defaults to the maximum
#'   date of `x`).
#'
#' @param ... Additional arguments passed to other methods.
#'
#' @author Tim Taylor, Thibaut Jombart
#'
#' @return A `\link[projections:build_projections]{projections}` object
#'   produced from the admission trajectories.
#'
#' @examples
#'   ## fake LoS; check `\link[distcrete:distcrete]{distcrete::distcrete}`
#'   ## for discretising existing distributions
#'   r_los <- function(n) rgeom(n, prob = .3)
#'
#'
#'   # Incidence input
#'
#'   ## fake data
#'   dates <- Sys.Date() - 1:10
#'   admissions <- sample(1:100, 10, replace = TRUE)
#'   x <- incidence(rep(dates, admissions))
#'   x
#'   plot(x)
#'
#'   ## project bed occupancy
#'   beds <- project_beds(x, r_los)
#'   beds
#'   plot(beds)
#'
#'
#'   # Projections input
#'
#'   ## make fake data - each column after the first is a separate forecast
#'   admissions <- data.frame(
#'       date = Sys.Date() - 1:10,
#'       as.data.frame(replicate(30, sample(1:100, 10, replace = TRUE))))
#'
#'   x <- build_projections(x = admissions[, -1], dates = admissions$date)
#'   x
#'   plot(x)
#'
#'   ## project bed occupancy
#'   beds <- project_beds(x, r_los)
#'   beds
#'   plot(beds)
#'
#' @export
project_beds <- function(x, ...) {
    UseMethod("project_beds")
}

#' @export
#' @noRd
project_beds.default <- function(x, ...) {
    stop(sprintf("project_beds not implemented for class %s",
                 paste(class(x), collapse = ", ")))
}


#' @rdname project_beds
#' @export
project_beds.projections <- function(x, r_los, n_sim = 10, last_date = NULL,
                                     ...) {

    ## sanity checks
    if (!all(is.finite(x))) stop("projection in x contains a non-numeric value")

    if (all(x == 0)) stop("some projected values in x must be > 0")

    if (!is.finite(n_sim)) stop("n_sim is not a number")

    if (n_sim < 1) stop("n_sim must be >= 1")

    if (inherits(r_los, "distcrete")) {
        r_los <- r_los$r
    }
    if (!is.function(r_los)) stop("r_los must be a function")

    x_dates <- projections::get_dates(x)
    if (is.null(last_date)) {
        last_date <- max(x_dates)
    }
    if (last_date <= min(x_dates)) {
        stop("We can't change the past!") #todo - change this!
    }

    ## get daily predictions for each simulated trajectory of admissions
    beds <- lapply(seq_len(ncol(x)),
                   function(i) simulate_occupancy(n_admissions = x[, i],
                                                  dates = x_dates,
                                                  r_los = r_los,
                                                  n_sim = n_sim,
                                                  last_date))
    projections::merge_projections(beds)
}


#' @rdname project_beds
#' @export
project_beds.incidence <- function(x, r_los, n_sim = 10, last_date = NULL,
                                   ...) {

    ## sanity checks
    if (as.integer(mean(incidence::get_interval(x))) != 1L) {
        msg <- sprintf(
            "daily incidence needed, but interval is %d days",
            as.integer(mean(incidence::get_interval(x)))
        )
        stop(msg)
    }

    admissions <- incidence::get_counts(x)
    if (!all(is.finite(admissions))) {
        stop("incidence counts contain a non-numeric value")
    }

    if (all(admissions == 0)) stop("atleast some incidence counts must be > 0")

    if (!is.finite(n_sim)) stop("n_sim must be a number")

    if (n_sim < 1) stop("n_sim must be >= 1")

    if (inherits(r_los, "distcrete")) {
        r_los <- r_los$r
    }
    if (!is.function(r_los)) stop("r_los must be a function")

    x_dates <- incidence::get_dates(x)
    if (is.null(last_date)) {
        last_date <- max(x_dates)
    }
    if (last_date <= min(x_dates)) {
        stop("We can't change the past!") #todo - change this!
    }

    ## get daily predictions for each simulated trajectory of admissions
    beds <- lapply(seq_len(ncol(x)),
                   function(i) simulate_occupancy(n_admissions = admissions,
                                                  dates = x_dates,
                                                  r_los = r_los,
                                                  n_sim = n_sim,
                                                  last_date))

    projections::merge_projections(beds)
}
