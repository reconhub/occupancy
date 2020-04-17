## single contant admissions and one day length of stay, default last_date,
test_that("project_beds, projections class - test set 1", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # simulation results
    beds <- project_beds(x, rlos, n_sim = 10)
    beds <- merge_projections(beds)

    # check daily occupancies
    expected <- matrix(1, 10, 10)
    expect_true(all(expected == beds))

    # check rownames
    beds_dates <- rownames(beds)
    expected <- as.character(sort(dates))
    expect_equal(beds_dates, expected)
})


## single contant admissions and long length of stay, default last_date
test_that("project_beds, projections class - test set 2", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(10, n)
    }

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # simulation results
    beds <- project_beds(x, rlos, n_sim = 10)
    beds <- merge_projections(beds)

    # check daily occupancies
    expected <- matrix(1:10, nrow = 10, ncol = 10)
    expect_true(all(expected == beds))

    # check rownames
    beds_dates <- rownames(beds)
    expected <- as.character(sort(dates))
    expect_equal(beds_dates, expected)
})


## single contant admissions and long length of stay, last_date way ahead
test_that("project_beds, projections class - test set 3", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- rep(1, 10)
    rlos <- function(n) {
        rep(10, n)
    }
    last_date <- Sys.Date() + 100

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # simulation results
    beds <- project_beds(x, rlos, n_sim = 10, last_date = last_date)
    beds <- merge_projections(beds)

    # check daily occupancies
    expected <- matrix(c(1:10, 9:1), nrow = 19, ncol = 10)
    expect_true(all(expected == beds))

    # check rownames
    beds_dates <- rownames(beds)
    expected <- c(as.character(sort(dates)), as.character(Sys.Date() + 0:8))
    expect_equal(beds_dates, expected)
})


## multiple contant admissions and one day length of stay, default last_date,
test_that("project_beds, projections class - test set 4", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- matrix(rep(1, 10), nrow = 10, ncol = 2)
    rlos <- function(n) {
        rep(1, n)
    }

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # simulation results
    beds <- project_beds(x, rlos, n_sim = 10)
    beds <- merge_projections(beds)

    # check daily occupancies
    expected <- matrix(1, 10, 10)
    expected <- cbind(expected, expected)
    expect_true(all(expected == beds))

    # check rownames
    beds_dates <- rownames(beds)
    expected <- as.character(sort(dates))
    expect_equal(beds_dates, expected)
})


## multiple contant admissions and long length of stay, default last_date
test_that("project_beds, projections class - test set 5", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- matrix(rep(1, 10), nrow = 10, ncol = 2)
    rlos <- function(n) {
        rep(10, n)
    }

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # simulation results
    beds <- project_beds(x, rlos, n_sim = 10)
    beds <- merge_projections(beds)

    # check daily occupancies
    expected <- matrix(1:10, nrow = 10, ncol = 10)
    expected <- cbind(expected, expected)
    expect_true(all(expected == beds))

    # check rownames
    beds_dates <- rownames(beds)
    expected <- as.character(sort(dates))
    expect_equal(beds_dates, expected)
})


## multiple contant admissions and long length of stay, last_date way ahead
test_that("project_beds, projections class - test set 6", {

    # parameters
    dates <- Sys.Date() - 1:10
    admissions <- matrix(rep(1, 10), nrow = 10, ncol = 2)
    rlos <- function(n) {
        rep(10, n)
    }
    last_date <- Sys.Date() + 100

    # setup
    x <- build_projections(x = admissions, dates = dates)

    # simulation results
    beds <- project_beds(x, rlos, n_sim = 10, last_date = last_date)
    beds <- merge_projections(beds)

    # check daily occupancies
    expected <- matrix(c(1:10, 9:1), nrow = 19, ncol = 10)
    expected <- cbind(expected, expected)
    expect_true(all(expected == beds))

    # check rownames
    beds_dates <- rownames(beds)
    expected <- c(as.character(sort(dates)), as.character(Sys.Date() + 0:8))
    expect_equal(beds_dates, expected)
})
