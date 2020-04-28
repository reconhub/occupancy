test_that("errors, incidence class - test 1", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- incidence(rep(dates, admissions), interval = 1.5)

    # test error
    expect_error(project_beds(x, rlos, n_sim = 10),
                 "daily incidence needed, but interval is ")
})


test_that("errors, incidence class - test 2", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- incidence(rep(dates, admissions))

    # test error
    expect_error(project_beds(x, rlos, n_sim = "test"),
                 "n_sim must be a number")
})


test_that("errors, incidence class - test 3", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- incidence(rep(dates, admissions))

    # test error
    expect_error(project_beds(x, rlos, n_sim = 0),
                 "n_sim must be >= 1")
})


test_that("errors, incidence class - test 4", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- 10

    # setup
    x <- incidence(rep(dates, admissions))

    # test error
    expect_error(project_beds(x, rlos, n_sim = 10),
                 "r_los must be a function")
})


test_that("errors, incidence class - test 5", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- incidence(rep(dates, admissions))

    # test error
    expect_error(project_beds(x, rlos, n_sim = 10,
                              last_date = Sys.Date() - 100),
                 "We can't change the past!")
})
