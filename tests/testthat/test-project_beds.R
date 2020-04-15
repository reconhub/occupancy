## contant admissions and one day length of stay
test_that("project_beds - integration test 1", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x = projections::build_projections(x = admissions, dates = dates)

    # simulation results
    beds <- project_beds(x, rlos, n_sim = 10)

    # check daily occupancies
    expected <- matrix(1, 10, 10)
    expect_true(all(expected == beds))

    # check rownames
    beds_dates = rownames(beds)
    expected = as.character(sort(dates))
    expect_equal(beds_dates, expected)
})

## contant admissions and long length of stay
test_that("project_beds - integration test 2", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(10, n)
    }

    # setup
    x = projections::build_projections(x = admissions, dates = dates)

    # simulation results
    beds <- project_beds(x, rlos, n_sim = 10)

    # check daily occupancies
    expected <- matrix(1:10, nrow = 10, ncol = 10)
    expect_true(all(expected == beds))

    # check rownames
    beds_dates = rownames(beds)
    expected = as.character(sort(dates))
    expect_equal(beds_dates, expected)
})
