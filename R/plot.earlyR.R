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
#'   "lamdbas"; "R" will plot the likelihood of R values; "lambdas" will plot
#'   the force of infection over time.
#'
#' @param scale A numeric value indicating the scaling factor for lambdas on the
#'   'y' axis.
#'
#' @param lambda_color A color to be used for plotting the lambdas.
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
plot.earlyR <- function(x, type = c("R", "lambdas"), scale = 1,
                        lambda_color = "#990033", ...) {

  type <- match.arg(type)
  if (type == "R") {
    df <- data.frame(R = x$R_grid, likelihood = x$R_like)
    df_ml <- data.frame(R_ml = x$R_ml, max_like = max(x$R_like))
    R_ml_label <- paste("R (MLE) =", round(x$R_ml, 2))
    
    
    out <- ggplot2::ggplot(df, ggplot2::aes(x = R, y = likelihood)) +
      ggplot2::geom_line() +
      ggplot2::geom_segment(data = df_ml,
                            ggplot2::aes(x = R_ml,
                                         0,
                                         xend = R_ml,
                                         yend = max_like),
                            linetype = 2) +
      ggplot2::geom_label(data = df_ml,
                          ggplot2::aes(x = R_ml,
                                       y = max_like * 1.05,
                                       label = R_ml_label)) +
      ggplot2::labs(x = "reproduction number (R)",
                    title = "Likelihood distribution of R")
    
  } else {

    lambdas <- scale * x$lambdas / max(x$lambdas, na.rm = TRUE)

    graphics::plot(x$dates, lambdas, type = "h", lwd = 5,
                   col = lambda_color,
                   lend = 1, xlab = "Date",
                   ylab = "Infectiousness (lambdas)",
                   main = "Global force of infection",
                   ...)
  }

  out
}






#' @export
#'
#' @rdname plot.earlyR

points.earlyR <- function(x, scale = 1, lambda_color = "#990033", ...) {
  lambdas <- scale * x$lambdas / max(x$lambdas, na.rm = TRUE)

  graphics::points(x$dates,  lambdas, type = "h", lwd = 5,
                   col = lambda_color, lend = 1,
                   xlab = "Date", ylab = "Infectiousness (lambdas)",
                   main = "Global force of infection", ...)

}
