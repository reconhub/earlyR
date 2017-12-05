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
    set.seed(1)
    samp_1 <- sample_R(R_1)
    expect_equal_to_reference(samp_1, file = "rds/samp_1.rds")

})





test_that("Test that right sample size is used", {
    skip_on_cran()

  ## simulate basic epicurve
    dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
    i <- incidence(dat)


    ## example with a function for SI
    si <- distcrete("gamma", interval = 1L,
                    shape = 1.5,
                    scale = 2, w = 0)
    R_1 <- get_R(i, si = si)

    expect_length(sample_R(R_1, 3), 3L)
    expect_length(sample_R(R_1, 0), 0L)
    expect_length(sample_R(R_1, 100), 100L)
})

