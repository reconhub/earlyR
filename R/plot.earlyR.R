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

plot.earlyR <- function(x, y = c("R", "lambda"), ...) {

  y <- match.arg(y)
  if (y == "R") {
    plot(x$R_grid, x$R_like, type = "l", lwd = 2,
         xlab = "Reproduction number",
         ylab = "Likelihood",
         yaxt = "n", ...)
    segments(x$R_ml, 0, x$R_ml, max(x$R_like),
             col = "blue", lwd = 2)
    points(x$R_ml, max(x$R_like), pch = 20, cex = 2)
    text(x$R_ml + .2 * max(x$R_grid),
         max(x$R_like), pch = 20, cex = 1.5,
         label = paste("R =", round(x$R_ml,3)))
  } else {
    plot(x$dates, x$R_ml * x$lambda, type = "h", lwd = 5,
         col = heat.colors(length(x$dates)),
         lend = 1, xlab = "Date",
         ylab = "Infectiousness (lambda)",
         main = "Global force of infection",
         ...)
  }
}
