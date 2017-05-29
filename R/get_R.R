#' Estimate the Reproduction Number
#'
#' This function estimates the (most of the time, 'basic') reproduction number
#' (R) using i) the known distribution of the Serial Interval (delay between
#' primary to secondary onset) and ii) incidence data.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#'
#' @rdname get_R
#'
#' @param x The daily incidence to be used for inferring the reproduction
#'   number. Input can be an \code{incidence} object, as output by the package
#'   \code{incidence}, or a vector of numbers indicating daily number of
#'   cases. Note that 'zero' incidence should be reported as well (see details).
#'
#' @param ... Further arguments to be passed to the methods.
#'
#' @details The estimation of R relies on all available incidence data. As such,
#'   all zero incidence after the first case should be included in
#'   \code{x}. When using \code{inidence} from the 'incidence' package, make
#'   sure you use the argument \code{last_date} to indicate where the epicurve
#'   stops, otherwise the curve is stopped after the last case. Use
#'   \code{as.data.frame} to double-check that the epicurve includes the last
#'   'zeros'.
#'
#' @examples
#'
#' if (require(incidence)) {
#'
#' ## example: onsets on days 1, 5, 6 and 12; estimation on day 24
#'  x <- incidence(c(1, 5, 6, 12), last_date = 24)
#'  x
#'  as.data.frame(x)
#'  plot(x)
#'  res <- get_R(x)
#'  res
#'  plot(res)
#'  plot(res, "lambdas")
#'
#' }
#'

get_R <- function(x, ...) {
  UseMethod("get_R")
}






#' @export
#' @rdname get_R

get_R.default <- function(x, ...) {
  class <- paste(class(x), collapse = ", ")
  stop("No method for objects of class", class)
}






#' @export
#' @rdname get_R
#'
#' @param disease A character string indicating the name of the disease
#'   studied. If provided, then \code{si_mean} and \code{si_sd} will be filled
#'   in automatically using value from the literature.
#'
#' @param si_mean The mean of the serial interval distribution.
#'
#' @param si_sd The standard deviation of the serial interval distribution.
#'
#' @param max_R The maximum value the reproduction number can take.
#'
#' @param days The number of days after the last incidence date for which the
#'   force of infection should be computed. This does not change the estimation
#'   of the reproduction number, but will affect projections.

get_R.integer <- function(x, disease = "ebola", si_mean = NULL, si_sd = NULL,
                          max_R = 5, days = 30, ...) {
  dates <- seq_along(x)
  last_day <- max(dates) + days

  disease <- tolower(disease)
  disease <- match.arg(disease)


  ## The serial interval is a discretised Gamma distribution. We ensure w(0) = 0
  ## so that a case cannot contribute to its own infectiousness.

  if (disease == "ebola") {
    si_mean <- 15.3
    si_sd <- 9.3
  }

  if (is.null(si_mean)) stop("si_mean is missing")
  if (is.null(si_sd)) stop("si_sd is missing")

  si_param <- epitrix::gamma_mucv2shapescale(si_mean, si_sd / si_mean)

  MAX_T <- 1000
  si_full <- distcrete::distcrete("gamma", shape = si_param$shape,
                             scale = si_param$scale,
                             interval = 1L, w = 0L)
  si <- si_full$d(seq_len(MAX_T))
  si[1] <- 0
  si <- si / sum(si)

  x_with_tail <- rep(0, last_day)
  x_with_tail[dates] <- x
  all_lambdas <- EpiEstim::OverallInfectivity(x_with_tail, si)[-1]
  dates_lambdas <- seq_along(all_lambdas) + 1
  x_lambdas <- all_lambdas[dates]

  loglike <- function(R) {
    if (R <= 0 ) return(-Inf)
    sum(stats::dpois(x[-1], lambda = R * x_lambdas, log = TRUE))
  }

  like <- function(R) exp(loglike(R))

  GRID_SIZE <- 1000

  R_grid <- seq(0, max_R, length.out = GRID_SIZE)
  R_like <- vapply(R_grid, like, numeric(1))
  R_ml <- R_grid[which.max(R_like)]


  out <- list(incidence = x,
              R_grid = R_grid,
              R_like = R_like,
              R_ml = R_ml,
              dates = dates_lambdas,
              lambdas = all_lambdas,
              si = si_full)
  class(out) <- c("earlyR", "list")

  return(out)
}






#' @export
#' @rdname get_R

get_R.numeric <- function(x, ...) {
  get_R(as.integer(x), ...)
}






#' @export
#' @rdname get_R

get_R.incidence <- function(x, ...) {

  if (as.integer(x$interval) != 1L) {
    msg <- sprintf("daily incidence needed - interval is %d days",
                   x$interval)
    stop(msg)
  }

  if (ncol(x$counts) > 1L) {
    msg <- "cannot use multiple groups in incidence object"
    stop(msg)
  }

  df <- as.data.frame(x)

  out <- get_R(as.integer(x$counts), ...)

  if (inherits(x$dates, "Date")) {
    out$dates <- min(x$dates) - 1 + out$dates
  }

  return(out)
}
