context("Test get_R")

test_that("Lambdas sum to the right numbers", {
  skip_on_cran()

  dat <- sample(1:10, 50, replace = TRUE)
  i <- incidence(dat)
  ## example with a function for SI
  si <- distcrete("gamma", interval = 1L,
                  shape = 1.5,
                  scale = 2, w = 0)
  
  R_est <- get_R(i, si = si, days = 1000)
  expect_equal(sum(R_est$lambdas, na.rm = TRUE), i$n)
  
})




test_that("Estimation robust to heading zeros", {
  skip_on_cran()

  dat <- as.Date("2019-01-01") + sample(1:10, 50, replace = TRUE)
  i <- incidence(dat)
  i_early <- incidence(dat,
                       first_date = as.Date("2018-12-15"),
                       standard = TRUE)
  ## example with a function for SI
  si <- distcrete("gamma", interval = 1L,
                  shape = 1.5,
                  scale = 2, w = 0)
  
  R_est <- get_R(i, si = si)
  R_est_early <- get_R(i_early, si = si)
  expect_equal(R_est$ml, R_est_early$ml)
  expect_equal(R_est$R_like, R_est_early$R_like)
  
})





test_that("Test against simple example", {
    skip_on_cran()
    skip("\n!!! TODO (2019-05-28): REWRITE for changes from 3acfd712232bf36b91f3ec3906e545ced2c2cb6a\n")

    
    ## simulate basic epicurve
    dat <- c(1, 2, 4)
    i <- incidence(dat)

    ## example with a function for SI
    si <- distcrete("gamma", interval = 1L,
                    shape = 1.5,
                    scale = 2, w = 0)
    
    w <- si$d(0:100)
    w[1] <- 0
    w <- w / sum(w)
    
    ## manual computations of expected forces of infection
    expected_lambdas <- c(
        day_1 = NA,
        day_2 = w[1 + 1],
        day_3 = sum(w[1:2 + 1]),
        day_4 = sum(w[2:3 + 1]),
        day_5 = sum(w[c(4,3,1) + 1])
    )

    R_est <- get_R(i, si = si)
    expect_equal_to_reference(R_1, file = "rds/R_1.rds")

    expect_identical(i, R_1$incidence)
})





test_that("Test that SI is used consistently", {
    skip_on_cran()

    ## simulate basic epicurve
    dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
    i <- incidence(dat)


    ## example with a function for SI
    si <- distcrete("gamma", interval = 1L,
                    shape = 1.5,
                    scale = 2, w = 0)
    R_1 <- get_R(i, si = si)

    expect_identical(si, R_1$si)


    ## with internally generated SI
    mu <- 10
    sd <- 3.2213
    params <- epitrix::gamma_mucv2shapescale(mu, sd/mu) 
    R_2 <- get_R(i, si_mean = mu, si_sd = sd)
    expect_identical(params, R_2$si$parameters)

})





test_that("Errors are thrown when they should", {
    expect_error(get_R("mklmbldfb"),
                 "No method for objects of class character")

    i <- incidence(1:10, 3)
    expect_error(get_R(i, "ebola"),
                 "daily incidence needed, but interval is 3 days")
    
    i <- incidence(1:10, 1, group = letters[1:10])
    expect_error(get_R(i, "ebola"),
                 "cannot use multiple groups in incidence object")

    i <- incidence(1)
    si <- distcrete("gamma", interval = 5L,
                    shape = 1.5,
                    scale = 2, w = 0)
    expect_error(get_R(i, si = si),
                 "interval used in si is not 1 day, but 5")

    expect_error(get_R(c(0,0,0)),
                 "Cannot estimate R with no cases")

})


test_that("issue 11 isn't compromised", {

  params <- list(shape = 1.88822148063956, scale = 4.5613778865727)
  si     <- distcrete::distcrete("gamma", 
                                 shape = params$shape, 
                                 scale = params$scale, 
                                 interval = 1L, w = 0L)
  i_df <- data.frame(
         dates = c("2014-04-07", "2014-04-08", "2014-04-09", "2014-04-10",
                   "2014-04-11", "2014-04-12", "2014-04-13", "2014-04-14",
                   "2014-04-15", "2014-04-16", "2014-04-17", "2014-04-18", "2014-04-19",
                   "2014-04-20", "2014-04-21", "2014-04-22", "2014-04-23",
                   "2014-04-24", "2014-04-25", "2014-04-26", "2014-04-27", "2014-04-28",
                   "2014-04-29", "2014-04-30", "2014-05-01", "2014-05-02",
                   "2014-05-03", "2014-05-04", "2014-05-05", "2014-05-06", "2014-05-07",
                   "2014-05-08", "2014-05-09", "2014-05-10", "2014-05-11",
                   "2014-05-12", "2014-05-13", "2014-05-14", "2014-05-15", "2014-05-16",
                   "2014-05-17", "2014-05-18", "2014-05-19", "2014-05-20", "2014-05-21",
                   "2014-05-22", "2014-05-23", "2014-05-24", "2014-05-25",
                   "2014-05-26", "2014-05-27", "2014-05-28", "2014-05-29", "2014-05-30",
                   "2014-05-31", "2014-06-01", "2014-06-02", "2014-06-03",
                   "2014-06-04", "2014-06-05", "2014-06-06", "2014-06-07", "2014-06-08",
                   "2014-06-09", "2014-06-10", "2014-06-11", "2014-06-12",
                   "2014-06-13", "2014-06-14", "2014-06-15", "2014-06-16", "2014-06-17"),
        counts = c(1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 2L,
                   0L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 0L, 2L, 0L, 1L, 1L, 1L, 3L,
                   2L, 2L, 2L, 1L, 1L, 3L, 3L, 3L, 0L, 2L, 3L, 3L, 3L, 1L, 3L, 1L,
                   2L, 2L, 3L, 4L, 10L, 1L, 1L, 1L, 2L, 0L, 5L, 3L, 0L, 4L, 5L, 5L,
                   1L, 5L, 4L, 3L, 1L, 1L, 2L, 5L, 5L, 4L)
  )

  i_trunc <- as.incidence(i_df[-1], dates = as.Date(i_df$dates))
  i_trunc
  the_R <- get_R(i_trunc, si = si)
  # The estimate should be 1.24
  expect_identical(round(the_R$R_ml, 2), 1.24)

  # The likelihood surface should pretty much be contained between 0.24 and 2.24
  expect_equal(sum(with(the_R, R_like[R_grid <= 2.24 & R_grid >= 0.24])), 1)

})

