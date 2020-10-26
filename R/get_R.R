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
#'     number. Input can be an \code{incidence} object, as output by the package
#'     \code{incidence}, or a vector of numbers indicating daily number of
#'     cases. Note that 'zero' incidence should be reported as well (see
#'     details).
#'
#' @param ... Further arguments to be passed to the methods.
#'
#' @details The estimation of R relies on all available incidence data. As such,
#'     all zero incidence after the first case should be included in
#'     \code{x}. When using \code{inidence} from the 'incidence' package, make
#'     sure you use the argument \code{last_date} to indicate where the epicurve
#'     stops, otherwise the curve is stopped after the last case. Use
#'     \code{as.data.frame} to double-check that the epicurve includes the last
#'     'zeros'.
#'
#' @return A list with the \code{earlyR} class, containing the following
#'     components:
#' \itemize{
#' \item \code{$incidence}: the input incidence, in its original format
#'
#' \item \code{$R_grid}: the grid of R values for which the likelihood has been
#' computed.
#'
#' \item \code{$R_like}: the values of likelihood corresponding to the
#' \code{$R_grid}
#'
#' \item \code{$R_ml}: the maximum likelihood estimate of R
#'
#' \item \code{$dates}: the dates for which infectiousness has been computed
#'
#' \item \code{$lambdas}: the corresponding values of force of infection
#'
#' \item \code{$si}: the serial interval, stored as a \code{distcrete} object
#'
#' }
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
#'  res <- get_R(x, disease = "ebola")
#'  res
#'  plot(res)
#'
#' }
#'

get_R <- function(x, ...) {
  UseMethod("get_R")
}






#' @export
#' @rdname get_R
#' @aliases get_R.default

get_R.default <- function(x, ...) {
  class <- paste(class(x), collapse = ", ")
  stop("No method for objects of class ", class)
}






#' @export
#' @rdname get_R
#' @aliases get_R.integer

#' @param disease A character string indicating the name of the disease
#'     studied. If provided, then \code{si_mean} and \code{si_sd} will be filled
#'     in automatically using value from the literature. Accepted values are:
#'     "ebola".
#'
#' @param si A \code{distcrete} object (see package \code{distcrete}) containing
#'     the discretized distribution of the serial interval.
#'
#' @param si_mean The mean of the serial interval distribution. Ignored if
#'     \code{si} is provided.
#'
#' @param si_sd The standard deviation of the serial interval
#'     distribution. Ignored if \code{si} is provided.
#'
#' @param max_R The maximum value the reproduction number can take.
#'
#' @param days The number of days after the last incidence date for which the
#'     force of infection should be computed. This does not change the
#'     estimation of the reproduction number, but will affect projections.

get_R.integer <- function(x, disease = NULL, si = NULL,
                          si_mean = NULL, si_sd = NULL,
                          max_R = 10, days = 30, ...) {

  if (sum(x, na.rm = TRUE) == 0) {
    stop("Cannot estimate R with no cases.")
  }
  
  dates <- seq_along(x)
  last_day <- max(dates) + days

  if (is.null(disease)) {
      disease <- "null"
  } else {
      disease <- tolower(disease)
      disease <- match.arg(disease, c("ebola"))
  }


  ## maximum numbers of time steps the distribution of the serial interval is
  ## discretized for

  MAX_T <- 1000


  ## The serial interval is a discretised Gamma distribution. We ensure w(0) = 0
  ## so that a case cannot contribute to its own infectiousness.

  if (is.null(si)) {
      if (is.null(si_mean) && disease == "ebola") {
          si_mean <- 15.3
      }
      if (is.null(si_sd) && disease == "ebola") {
          si_sd <- 9.3
      }
      if (is.null(si_mean)) stop("si_mean is missing")
      if (is.null(si_sd)) stop("si_sd is missing")

      si_param <- epitrix::gamma_mucv2shapescale(si_mean, si_sd / si_mean)

      si_full <- distcrete::distcrete("gamma", shape = si_param$shape,
                                      scale = si_param$scale,
                                      interval = 1L, w = 0L)
  } else {
      if (!inherits(si, "distcrete")) {
          stop("'si' must be a distcrete object")
      }
      if (as.integer(si$interval) != 1L) {
          msg <- sprintf("interval used in si is not 1 day, but %d)",
                         si$interval)
          stop(msg)
      }

      si_full <- si
  }
  si <- si_full$d(seq_len(MAX_T))
  si[1] <- 0
  si <- si / sum(si)

  x_with_tail <- rep(0, last_day)
  x_with_tail[dates] <- x

  
  ## Important note: we cannot compute the likelihood of the first day with
  ## case(s), as the force of infection on that day is by default 0: the
  ## likelihood is in fact conditional on the first day with cases. The
  ## resulting log-likelihood for the first day with cases will be -Inf. We keep
  ## track of this day and ignore this data point when summing over
  ## log-likelihood. In the general case, this will be the first element of x
  ## (x[1]), but we also implement the general case where the incidence curve
  ## could have started before the first cases. Note that the force of infection
  ## for day 1 is also by definition not known (NA), so the first day of data
  ## (x[1]) is always ignored in any case.

  ignored_likelihood <- 1 # fist day always ignored
  if (! sum(x_with_tail) == 0) {
    days_with_cases <- which(x_with_tail > 0)
    first_day_with_cases <- min(days_with_cases, na.rm = TRUE)
    ignored_likelihood <- union(1, first_day_with_cases)
  }
  
  all_lambdas <- EpiEstim::overall_infectivity(x_with_tail, si)
  dates_lambdas <- seq_along(all_lambdas)
  lambdas_for_x <- all_lambdas[dates]

  loglike <- function(R) {
    if (R < 0 ) return(-Inf)
    all_likelihoods <- stats::dpois(x,
                                    lambda = R * lambdas_for_x,
                                    log = TRUE)
    sum(all_likelihoods[-ignored_likelihood])
  }

  GRID_SIZE <- 1000

  R_grid <- seq(0, max_R, length.out = GRID_SIZE)
  R_loglike <- vapply(R_grid, loglike, numeric(1))
  R_like <- loglike_to_density(R_loglike)
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
#' @aliases get_R.numeric

get_R.numeric <- function(x, ...) {
    out <- get_R(as.integer(x), ...)
    out$incidence <- x
    return(out)
}






#' @export
#' @rdname get_R
#' @aliases get_R.incidence

get_R.incidence <- function(x, ...) {

  if (as.integer(x$interval) != 1L) {
    msg <- sprintf("daily incidence needed, but interval is %d days",
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

  out$incidence <- x
  return(out)
}
