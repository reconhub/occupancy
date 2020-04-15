#' @importFrom methods is
NULL

#' @importFrom projections build_projections
NULL


#' @title Constructor for projections objects
#' @keywords NULL
#' @export
#' @name build_projections
projections::build_projections

#' Simulator for projecting bed occupancy
#'
#' This function predits bed occupancy from admission data (dates, and numbers
#' of admissions on these days). Duration of hospitalisation is provided by a
#' function returning `integer` values for the number of days in hospital.
#'
#' @param dates A vector of dates, ideally as `Date` but `integer` should work too.
#'
#' @param n_admissions An `integer` vector giving the number of admissions
#'   predicted for each date in `dates`.
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
#' @author Thibaut Jombart
#' @keywords internal
#' @noRd
simulate_occupancy <- function(n_admissions, dates, r_los, n_sim = 10) {

    ## Outline:

    ## We take a vector of dates and incidence of admissions, and turn this into a
    ## vector of admission dates, whose length is sum(n_admissions). We will
    ## simulate for each date of admission a duration of stay, and a corresponding
    ## vector of dates at which this case occupies a bed. Used beds are then
    ## counted (summing up all cases) for each day. To account for stochasticity
    ## in duration of stay, this process can be replicated `n_sim` times,
    ## resulting in `n_sim` predictions of bed needs over time.


    admission_dates <- rep(dates, n_admissions)
    n <- length(admission_dates)
    last_date <- max(dates)
    out <- vector(n_sim, mode = "list")


    for (j in seq_len(n_sim)) {
        los <- r_los(n)
        list_dates_beds <- lapply(seq_len(n),
                                  function(i) seq(admission_dates[i],
                                                  length.out = los[i],
                                                  by = 1L))
        ## Note: unlist() doesn't work with Date objects
        dates_beds <- do.call(c, list_dates_beds)
        dates_beds <- dates_beds[dates_beds <= last_date]
        beds_days <- incidence::incidence(dates_beds)

        out[[j]] <- projections::build_projections(
            x = beds_days$counts,
            dates = incidence::get_dates(beds_days))
    }

    projections::merge_projections(out)

}


#' Project bed occupancy from admissions
#'
#' This function projects bed occupancy using admission incidence and a
#' distribution of length of stay (los).
#'
#' @param x a \code{\link[projections:build_projections]{projections}} object
#' storing one or more integer forecasts of daily admissions.
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
#'  @return A \code{\link[projections:build_projections]{projections}} object
#'  that collects the output from the different admission trajectories.
#'
#'
#' @examples
#' if (require(projections))  {
#'
#'   ## make fake data
#'   ## each column after the first is a separate forecast
#'   admissions <- data.frame(
#'       date = Sys.Date() - 1:10,
#'       as.data.frame(replicate(30, sample(1:100, 10, replace = TRUE))))
#'
#'   x <- build_projections(x = admissions[, -1], dates = admissions$date)
#'   x
#'   plot(x)
#'
#'   ## fake LoS; check `distcrete::distcrete` for discretising existing distributions
#'   r_los <- function(n) rgeom(n, prob = .3)
#'
#'   ## project bed occupancy
#'   beds <- project_beds(x, r_los)
#'   beds
#'   plot(beds)
#' }
#'
#' @export
project_beds <- function(x, r_los, n_sim = 10) {

    ## sanity checks
    if (!all(is.finite(x))) stop("projection in x contains a non-numeric value")

    if (!all(x > 0)) stop("projected values in x must be >= 1")

    if (!is.finite(n_sim)) stop("`n_sim` is not a number")

    if (n_sim[1] < 1) stop("`n_sim` must be >= 1")

    if (inherits(r_los, "distcrete")) {
        r_los <- r_los$r
    }
    if (!is.function(r_los)) stop("`r_los` must be a function")

    ## get daily bed needs predictions for each simulated trajectory of admissions
    x_dates <- projections::get_dates(x)
    beds <- lapply(seq_len(ncol(x)),
                   function(i) simulate_occupancy(n_admissions = x[,i],
                                                  dates = x_dates,
                                                  r_los = r_los,
                                                  n_sim = n_sim))

    projections::merge_projections(beds)

}
