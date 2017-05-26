#' Print method for earlyR objects
#'
#' This method prints the content of \code{earlyR} objects.
#'
#' @export
#'
#' @author Thibaut Jombart (\email{thibautjombart@@gmail.com})
#'
#' @param x A \code{earlyR} object.
#'
#' @param ... further parameters to be passed to other methods (currently not
#' used)
#'
print.earlyR <- function(x, ...){
    cat("\n/// Early estimate of reproduction number (R) //")
    cat("\n // class:", paste(class(x), collapse=", "))
    cat("\n")

    cat("\n // Maximum-Likelihood estimate of R ($R_ml):\n")
    print(x$R_ml)
    cat("\n")

    cat("\n // $infectiousness:\n")
    cat(" ", head(x$infectiousness))
    if (length(x$infectiousness)>6L) cat("...")
    cat("\n")

    cat("\n // $dates:\n")
    cat(" ", head(x$dates))
    if (length(x$dates)>6L) cat("...")
    cat("\n")
}
