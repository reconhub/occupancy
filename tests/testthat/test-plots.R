context("plots")

library(ggplot2)    # for plotting
library(scales)     # for plotting
library(distcrete)
library(projections)  # so we can use the `project` and subset functions

set.seed(2)

# setup (tests from the overview vignette) --------------------------------
length_of_stay <-
    distcrete("weibull", shape = 1.1, scale = 7.4, w = 0.5, interval = 1)

initial_admissions <- 10 # day one
duration <- 14           # 14 days (2 weeks) duration
growth_rate <- log(2) / 7 # doubling time of 7 days

future_admissions <- round(
    initial_admissions * exp(growth_rate * (seq_len(duration))))

admissions <-
    incidence(rep(Sys.Date() + 0:14, c(initial_admissions, future_admissions)))

# convert to a projections object to use with the project_beds function
admissions <- build_projections(
    x = c(initial_admissions, future_admissions),
    dates = Sys.Date() + 0:14)

projection <- project_beds(x = admissions,
                           r_los = length_of_stay,
                           n_sims = 10)

example_plot_1 <-
    plot(projection, quantiles = c(0.025, 0.5), ylab = "Predicted occupancy") +
    scale_x_date(breaks = breaks_pretty(10)) +
    ylim(0, 500)


# make some fake admissions data
initial_admissions <- sample(Sys.Date() - 0:7, 30, replace = TRUE)
initial_admissions <- incidence(initial_admissions)

# observed study values need converting before use with R's log-normal function
recorded_mean <- 4.7
recorded_sd <- 2.9
mu <- log(recorded_mean^2 / sqrt(recorded_mean^2 + recorded_sd^2))
sd <- sqrt(log(1 + recorded_sd^2 / recorded_mean^2))

# generate the discretised serial inteval
serial_interval <- distcrete("lnorm", mu, sd, w = 0.5, interval = 1)

# project future admissions
future_admissions <- project(initial_admissions,
                             R = c(2,2.5), si = serial_interval,
                             n_days = 14, n_sim = 100)

# combine the current and future admissions data
original_admissions <- build_projections(initial_admissions$counts,
                                         initial_admissions$dates)
admissions <- future_admissions + original_admissions

projections <- project_beds(x = admissions,
                            r_los = length_of_stay,
                            n_sims = 10)

projections <- subset(projections, from = Sys.Date())

example_plot_2 <-
    plot(projections, quantiles = c(0.025, 0.5), ylab = "Predicted occupancy") +
    scale_x_date(breaks = breaks_pretty(10)) +
    ylim(0, 500)


vdiffr::expect_doppelganger("example plot one", example_plot_1)
vdiffr::expect_doppelganger("example plot two", example_plot_2)
