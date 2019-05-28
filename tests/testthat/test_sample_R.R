context("Test sample_R")

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

  samp_1 <- sample_R(R_1, n = 1e4)

  expect_length(samp_1, 1e4)

  skip("\n!!! TODO (2019-05-28): These need to be validated with expected values\n")

  expect_true(abs(round(sd(samp_1), 1) - 2.2) < 0.1)
  expect_true(abs(round(mean(samp_1), 1) - 3.3) < 0.1)

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

