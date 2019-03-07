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
                       first_date = as.Date("2018-12-15"))
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

    
    ## ## simulate basic epicurve
    ## dat <- c(1, 2, 4)
    ## i <- incidence(dat)

    ## ## example with a function for SI
    ## si <- distcrete("gamma", interval = 1L,
    ##                 shape = 1.5,
    ##                 scale = 2, w = 0)
    
    ## w <- si$d(0:100)
    ## w[1] <- 0
    ## w <- w / sum(w)
    
    ## ## manual computations of expected forces of infection
    ## expected_lambdas <- c(
    ##     day_1 = NA,
    ##     day_2 = w[1 + 1],
    ##     day_3 = sum(w[1:2 + 1]),
    ##     day_4 = sum(w[2:3 + 1]),
    ##     day_5 = sum(w[c(4,3,1) + 1])
    ## )

    ## R_est <- get_R(i, si = si)
    ## expect_equal_to_reference(R_1, file = "rds/R_1.rds")

    ## expect_identical(i, R_1$incidence)
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

