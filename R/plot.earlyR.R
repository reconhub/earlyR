#' Plot earlyR objects
#'
#' This method is designed for plotting \code{earlyR} objects, output by the
#' function \code{\link{get_R}}.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#'
#' @param x A \code{earlyR} object.
#'
#' @param ... Further arguments to be passed to other methods (not used).
#'

plot.earlyR <- function(x, ...) {

  plot(x$R_grid, x$R_like, type = "l", lwd = 2,
       xlab = "Reproduction number",
       ylab = "Likelihood",
       yaxt = "n")
  segments(x$R_ml, 0, x$R_ml, max(x$R_like), col = "blue")
  points(x$R_ml, max(x$R_like), pch = 20, cex = 2)

}
