context("Test print function")

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
    
    expect_equal_to_reference(capture.output(print(R_1)),
                              file = "rds/print_1.rds")
    
})


