
## ## These function are used to compute infectiousness over time given an
## ## empirical distribution of serial interval.




## ## Get lambda for one individual, one day

## get_lambda_one_day <- function(w, onset, day) {
##   T <- day - onset + 1
##   if (T < 1 || T > length(w)) {
##     return(0)
##   }

##   return(w[T])
## }






## ## Get lambda for one individual, several days.

## get_lambda_days <- function(w, onset, days) {

##   vapply(days,
##          function(day) get_lambda_one_day(w, onset, day),
##          numeric(1))
## }






## ## Get lambda for several individuals, several days.

## get_lambdas <- function(w, onset, days = 1:max(onset)) {
##   if (any(is.na(w))) {
##     stop("NA detected in serial interval")
##   }

##   w <- w/sum(w)
##   all_lambdas <- vapply(seq_along(onset),
##                         function(i)
##                           get_lambda_days(w, onset[i], days),
##                         numeric(length(days)))
##   rowSums(all_lambdas)
## }

