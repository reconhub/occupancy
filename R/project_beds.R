#' Project bed occupancy from admissions
#'
#' This projects bed occupancy using admission incidence stored as a
#' `projections` object, and a distribution of length of stay (los). This is a
#' wrapper around `simulate_occupancy`, which essentially applies this function
#' to different admission trajectories and collects outputs into a single
#' `projections` object.
#'
#' @param x a `projections` object storing forecast of daily admissions
#'
#' @param r_los function generating random duration of hospitalisation
#'
#' @param n_sim The number of times duration of hospitalisation is simulated for
#'   each admission. Defaults to 10. Only relevant for low (<30) numbers of
#'   initial admissions, in which case it helps accounting for the uncertainty
#'   in LoS.
#'
#' @seealso \code{\link{simulate_occupancy}}
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
project_beds <- function(x, r_los, n_sim = 1) {

    ## get daily bed needs predictions for each simulated trajectory of admissions
    x_dates <- projections::get_dates(x)
    beds <- lapply(seq_len(ncol(x)),
                   function(i) simulate_occupancy(n_admissions = x[,i],
                                                  dates = x_dates,
                                                  r_los = r_los,
                                                  n_sim = n_sim))

    projections::merge_projections(beds)

}
