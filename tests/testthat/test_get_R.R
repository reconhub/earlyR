context("Test get_R")

test_that("Test against reference results", {
    skip_on_cran()

    ## simulate basic epicurve
    dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
    i <- incidence(dat)


    ## example with a function for SI
    si <- distcrete("gamma", interval = 1L,
                    shape = 1.5,
                    scale = 2, w = 0)
    R_1 <- get_R(i, si = si)
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

})

