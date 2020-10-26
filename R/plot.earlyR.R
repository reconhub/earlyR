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
#' @importFrom ggplot2 .data 
#'
#' @rdname plot.earlyR
#'
#' @param x A \code{earlyR} object.
#'
#' @param type The type of graphic to be generated, matching either "R" or
#'   "lamdbas"; "R" will plot the likelihood of R values; "lambdas" will plot
#'   the force of infection over time; see `scale` argument to interprete the
#'   force of infection.
#'
#' @param scale A numeric value indicating the total number of new cases
#'   expected over the time period of the lambdas, or a recognised `character`
#'   string; lambdas will be scaled to correspond to the number of expected
#'   cases every day; defaults to `ml`, which tells function to use the maximum
#'   likelihood estimate of *R* multiplied by the number of infectious cases
#'
#' @param ... Further arguments to be passed to other methods; for the plot of
#'   *R*, `...` is passed to `ggplot2::geom_line()`; for the plot of *lambdas*,
#'   `...` is passed to `ggplot2::geom_bar()`.
#'
#' @return A `ggplot2` object.
#'
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
#'
#' }
                                        #
plot.earlyR <- function(x, type = c("R", "lambdas"), scale = "ml", ...) {

  type <- match.arg(type)
  
  if (type == "R") {
    df <- data.frame(R = x$R_grid, likelihood = x$R_like)
    df_ml <- data.frame(R_ml = x$R_ml, max_like = max(x$R_like))
    R_ml_label <- paste("R (MLE) =", round(x$R_ml, 2))
    
    
    out <- ggplot2::ggplot(df,
                           ggplot2::aes(x = .data$R,
                                        y = .data$likelihood)) +
      ggplot2::geom_line(...) +
      ggplot2::geom_segment(data = df_ml,
                            ggplot2::aes(x = .data$R_ml,
                                         0,
                                         xend = .data$R_ml,
                                         yend = .data$max_like),
                            linetype = 2) +
      ggplot2::geom_label(data = df_ml,
                          ggplot2::aes(x = .data$R_ml,
                                       y = .data$max_like * 1.05,
                                       label = R_ml_label)) +
      ggplot2::labs(x = "reproduction number (R)",
                    title = "Likelihood distribution of R")

  } else {


    ## the scaling value is defined as the sum of all the lambdas weighted by
    ## individual infectiousness; the default value is "ml", in which case the
    ## scaling value is the ML estimate of R multiplied by the number of cases.
    
    if (tolower(scale) == "ml") {
      scale <- x$R_ml * x$incidence$n
      ylab <- "Force of infection (ML estimate of expected daily cases)"
    } else {
      ylab <- "Force of infection"
    }
    lambdas <- scale * (x$lambdas / sum(x$lambdas, na.rm = TRUE))
    df_plot <- data.frame(date = x$dates, lambda = lambdas)

    out <- ggplot2::ggplot(df_plot,
                           ggplot2::aes(x = .data$date,
                                        y = .data$lambda)) +
      ggplot2::geom_bar(stat = "identity", ...) +
      ggplot2::labs(title = "Force of infection over time",
                    x = "date",
                    y = ylab)
        
  }

  return(out)
  
}






#' @export
#'
#' @rdname plot.earlyR

points.earlyR <- function(x, scale = 1, ...) {
  plot(x, type = "lambdas", scale = scale, ...)
}
