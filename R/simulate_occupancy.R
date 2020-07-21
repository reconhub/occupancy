#' Simulator for projecting bed occupancy
#'
#' This function predits bed occupancy from admission data (dates, and numbers
#' of admissions on these days). Duration of hospitalisation is provided by a
#' function returning `integer` values for the number of days in hospital.
#'
#' @param dates A vector of dates, ideally as `Date` but `integer` should work
#' too.
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
#' @param last_date the last date to simulate until.
#' @author Tim Taylor, Thibaut Jombart
#' @keywords internal
#' @noRd
simulate_occupancy <- function(n_admissions, dates, r_los, n_sim = 10,
                               last_date) {

    ## Outline:

    ## We take a vector of dates and incidence of admissions, and turn this into
    ## a vector of admission dates, whose length is sum(n_admissions). We will
    ## simulate for each date of admission a duration of stay, and a
    ## corresponding vector of dates at which this case occupies a bed. Used
    ## beds are then counted (summing up all cases) for each day. To account for
    ## stochasticity in duration of stay, this process can be replicated `n_sim`
    ## times, resulting in `n_sim` predictions of bed needs over time.

    admission_dates <- rep(dates, n_admissions)
    n <- length(admission_dates)
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
