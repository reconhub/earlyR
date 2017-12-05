context("Test plotting functions")

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
    plot_1 <- function() plot(R_1)
    plot_2 <- function() plot(R_1, type = "lambdas")
    plot_3 <- function() plot(R_1, type = "lambdas", scale = 10)
    
    vdiffr::expect_doppelganger("basic R ML plot", plot_1)
    vdiffr::expect_doppelganger("basic lambda plot", plot_2)
    vdiffr::expect_doppelganger("scaled lambda plot", plot_3)

})


