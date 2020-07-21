test_that("errors, projections class - test 1", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep("test", 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # error test
    expect_error(project_beds(x, rlos, n_sim = 10),
                 "projection in x contains a non-numeric value")
})


test_that("errors, projections class - test 2", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(0, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # error test
    expect_error(project_beds(x, rlos, n_sim = 10),
                 "some projected values in x must be > 0")
})


test_that("errors, projections class - test 3", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # error test
    expect_error(project_beds(x, rlos, n_sim = "test"),
                 "n_sim is not a number")
})


test_that("errors, projections class - test 4", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- 10

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # error test
    expect_error(project_beds(x, rlos, n_sim = 10),
                 "r_los must be a function")
})


test_that("errors, projections class - test 5", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # error test
    expect_error(project_beds(x, rlos, n_sim = 10,
                              last_date = Sys.Date() - 100),
                 "We can't change the past")
})



test_that("errors, projections class - test 6", {

    # applied to non-projecting class
    x <- logical()
    expect_error(
        project_beds(x),
        "project_beds not implemented for class logical",
        fixed = TRUE
    )
})


test_that("errors, projections class - test 7", {

    # sims less than one errors
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }
    x <- build_projections(x = admissions, dates = dates)
    expect_error(
        project_beds(x, rlos, n_sim = 0),
        "n_sim must be >= 1",
        fixed = TRUE)
})



