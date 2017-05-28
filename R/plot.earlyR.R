#' Plot earlyR objects
#'
#' This method is designed for plotting \code{earlyR} objects, output by the
#' function \code{\link{get_R}}.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#'
#' @rdname plot.earlyR
#'
#' @param x A \code{earlyR} object.
#'
#' @param scale A numeric value indicating the scaling factor for lambdas.
#'
#' @param ... Further arguments to be passed to other methods (not used).
#'

plot.earlyR <- function(x, y = c("R", "lambdas"), scale = 1, ...) {

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

    lambdas <- x$lambdas / max(x$lambdas, na.rm = TRUE)

    plot(x$dates, lambdas, type = "h", lwd = 5,
         col = heat.colors(length(x$dates)),
         lend = 1, xlab = "Date",
         ylab = "Infectiousness (lambdas)",
         main = "Global force of infection",
         ...)
  }
}






#' @export
#'
#' @rdname plot.earlyR

points.earlyR <- function(x, scale = 1, ...) {
  lambdas <- x$lambdas / max(x$lambdas, na.rm = TRUE)

  points(x$dates,  lambdas, type = "h", lwd = 5,
         col = heat.colors(length(x$dates)),
         lend = 1, xlab = "Date",
         ylab = "Infectiousness (lambdas)",
         main = "Global force of infection",
         ...)

}
