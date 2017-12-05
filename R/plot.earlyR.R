#' Plot earlyR objects
#'
#' These functions are designed for plotting \code{earlyR} objects, output by
#' the function \code{\link{get_R}}. It can plot either the likelihood of R
#' values, or the force of infection over time (see argument \code{type}). For
#' \code{points}, the latter is used.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#'
#' @rdname plot.earlyR
#'
#' @param x A \code{earlyR} object.
#'
#' @param type The type of graphic to be generated, matching either "R" or
#'     "lamdbas"; "R" will plot the likelihood of R values; "lambdas" will plot
#'     the force of infection over time.
#'
#' @param scale A numeric value indicating the scaling factor for lambdas on the
#'     'y' axis.
#'
#' @param ... Further arguments to be passed to other methods (not used).
#'
#' if (require(incidence)) {
#'
#' ## example: onsets on days 1, 5, 6 and 12; estimation on day 24
#' onset <- c(1, 5, 6, 12)
#' x <- incidence(onset, last_date = 24)
#' x
#'
#' res <- get_R(x, disease = "ebola")
#' res
#' plot(res)
#' plot(res, "lambdas")
#' plot(res, "lambdas", scaling = 5)
#' points(onset, 1:4, cex = 3, pch = 20)
#'
#' }
#
plot.earlyR <- function(x, type = c("R", "lambdas"), scale = 1, ...) {

  type <- match.arg(type)
  if (type == "R") {
    graphics::plot(x$R_grid, x$R_like, type = "l", lwd = 2,
         xlab = "Reproduction number",
         ylab = "Likelihood",
         yaxt = "n", ...)
    graphics::segments(x$R_ml, 0, x$R_ml, max(x$R_like),
             col = "blue", lwd = 2)
    graphics::points(x$R_ml, max(x$R_like), pch = 20, cex = 2)
    graphics::text(x$R_ml + .2 * max(x$R_grid),
         max(x$R_like), pch = 20, cex = 1.5,
         label = paste("R =", round(x$R_ml,3)))
  } else {

    lambdas <- scale * x$lambdas / max(x$lambdas, na.rm = TRUE)

    graphics::plot(x$dates, lambdas, type = "h", lwd = 5,
                   col = grDevices::heat.colors(length(x$dates)),
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
  lambdas <- scale * x$lambdas / max(x$lambdas, na.rm = TRUE)

  graphics::points(x$dates,  lambdas, type = "h", lwd = 5,
                   col = grDevices::heat.colors(length(x$dates)), lend = 1,
                   xlab = "Date", ylab = "Infectiousness (lambdas)",
                   main = "Global force of infection", ...)

}
