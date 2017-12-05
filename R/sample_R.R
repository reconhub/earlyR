#' Get a sample of plausible Reproduction Numbers
#'
#' This function derives a sample of plausible R values from an \code{earlyR}
#' object (as returned by \code{\link{get_R}}). The probability of each returned
#' values of R are directly proportional to their likelihood.
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#'
#' @examples
#'
#' if (require(incidence)) {
#'  x <- incidence(c(1, 5, 5, 12, 45, 65))
#'  plot(x)
#'  res <- get_R(x, disease = "ebola")
#'  res
#'  plot(res)
#'
#'  sample_R(res, 10)
#'  hist(sample_R(res, 1000), col = "grey", border = "white")
#' }
#'
#' @param x An \code{earlyR} object.
#'
#' @param n The number of R values to sample.
#'

sample_R <- function(x, n = 100) {
  if (!inherits(x, "earlyR")) {
    stop("x is not an earlyR object")
  }

  sample(x$R_grid, prob = x$R_like, n, replace = TRUE)
}
