
[![Build Status](https://travis-ci.org/reconhub/earlyR.svg?branch=master)](https://travis-ci.org/reconhub/earlyR)
[![Build status](https://ci.appveyor.com/api/projects/status/spq4patqkwrtlcgt/branch/master?svg=true)](https://ci.appveyor.com/project/thibautjombart/earlyr/branch/master)
[![codecov.io](https://codecov.io/github/reconhub/earlyR/coverage.svg?branch=master)](https://codecov.io/github/reconhub/earlyR?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/earlyR)](https://cran.r-project.org/package=earlyR)

# Welcome to the *earlyR* package!

This package implements simple estimation of infectiousness, as measured by the
reproduction number (R), in the early stages of an outbreak. This estimation requires:

- **prior knowledge**: the **serial interval** distribution, defined as the *mean* and
*standard deviation* of the (Gamma) distribution. In general, these parameters
are best taken from the literature.

- **data**: the daily **incidence** of the disease, including **only confirmed
    and probable** cases.



## Installing the package

To install the current stable, CRAN version of the package, type:

```r
install.packages("earlyR")
```

To benefit from the latest features and bug fixes, install the development,
*github* version of the package using:


```r
devtools::install_github("reconhub/earlyR")
```

Note that this requires the package *devtools* installed.


# What does it do?

The main features of the package include:

- **`get_R`**: a function to estimate *R* as well as the force of infection over
    time, from incidence data; output is an object of class `earlyR`

- **`sample_R`**: a function to obtain a sample of likely *R* values

- **`plot`**: a function to visualise `earlyR` objects (*R* or force of infection).

- **`points`**: a function using `earlyR` objects to add the force of infection
    to an existing plot.



# Resources

## Worked example

In this example we assume a small outbreak of Ebola Virus Disease (EVD), for
which the serial interval has been previously characterised. We study a fake
outbreak, for which we will quantify infectiousness (R), and then project future
incidence using the package
[*projections*](https://github.com/reconhub/projections).

The fake data we consider consist of confirmed cases with the
following symptom onset dates:


```r
onset <- as.Date(c("2017-02-04", "2017-02-12", "2017-02-12",
                   "2017-02-23", "2017-03-05", "2017-03-06",
		   "2017-02-21", "2017-03-01", "2017-03-01"))
```

We compute the daily incidence using the package
[*incidence*](https://github.com/reconhub/incidence):


```r
library(incidence)
i <- incidence(onset)
i
```

```
## <incidence object>
## [9 cases from days 2017-02-04 to 2017-03-06]
## 
## $counts: matrix with 31 rows and 1 columns
## $n: 9 cases in total
## $dates: 31 dates marking the left-side of bins
## $interval: 1 day
## $timespan: 31 days
```

```r
plot(i, border = "white")
```

![plot of chunk incidence](figure/incidence-1.png)

Notice that the epicurve stops exactly after the last date of onset. Let us
assume it is currently the 12th March, and no case has been seen since the 6th
March. We need to indicate this to `incidence` using:


```r
today <- as.Date("2017-03-12")
i <- incidence(onset, last_date = today)
i
```

```
## <incidence object>
## [9 cases from days 2017-02-04 to 2017-03-12]
## 
## $counts: matrix with 37 rows and 1 columns
## $n: 9 cases in total
## $dates: 37 dates marking the left-side of bins
## $interval: 1 day
## $timespan: 37 days
```

```r
plot(i, border = "white")
```

![plot of chunk incidence2](figure/incidence2-1.png)

It is **very important** to make sure that the last days without cases are
included here. Omitting this information would lead to an over-estimation of the
reproduction number (*R*).


For estimating *R*, we need estimates of the mean and standard deviation of the
serial interval, i.e. the delay between primary and secondary symptom onset
dates. This has been quantified durin the West African EVD outbreak (WHO Ebola
Response Team (2014) NEJM 371:1481–1495):


```r
mu <- 15.3 # mean in days days
sigma <- 9.3 # standard deviation in days
```

The function `get_R` is then used to estimate the most likely values of *R*:

```r
res <- get_R(i, si_mean = mu, si_sd = sigma)
```

```
## Error in get_R(i, si_mean = mu, si_sd = sigma): could not find function "get_R"
```

```r
res
```

```
## Error in eval(expr, envir, enclos): object 'res' not found
```

```r
plot(res)
```

```
## Error in plot(res): object 'res' not found
```

```r
plot(res, "lambdas", scale = length(onset) + 1)
```

```
## Error in plot(res, "lambdas", scale = length(onset) + 1): object 'res' not found
```

```r
abline(v = onset, lwd = 3, col = "grey")
```

```
## Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...): plot.new has not been called yet
```

```r
abline(v = today, col = "blue", lty = 2, lwd = 2)
```

```
## Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...): plot.new has not been called yet
```

```r
points(onset, seq_along(onset), pch = 20, cex = 3)
```

```
## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet
```

The first figure shows the distribution of likely values of *R*, and the
Maximum-Likelihood (ML) estimation. The second figure show the global force of
infection over time, with vertical grey bars indicating the presence of cases,
and dots showing the dates of symptom of onset. The dashed blue line indicates
current day.


Based on this figure and on the estimated *R*, it seems likely that new cases
will be seen in the near future. How many? We can use the package
[*projections*](https://github.com/reconhub/projections) to have an idea. The
function `project` can be used to simulate a large number of future epicurves
which are in line with the current data, serial interval and *R*. Rather than
using a single ML estimate of *R* (as we can see, there is some variability in
the distribution), we use a sample of 1,000 likely *R* values using `sample_R`:


```r
R_val <- sample_R(res, 1000)
```

```
## Error in sample_R(res, 1000): could not find function "sample_R"
```

```r
summary(R_val)
```

```
## Error in summary(R_val): object 'R_val' not found
```

```r
quantile(R_val)
```

```
## Error in quantile(R_val): object 'R_val' not found
```

```r
quantile(R_val, c(0.025, 0.975))
```

```
## Error in quantile(R_val, c(0.025, 0.975)): object 'R_val' not found
```

```r
hist(R_val, border = "grey", col = "navy",
     xlab = "Values of R",
     main = "Sample of likely R values")
```

```
## Error in hist(R_val, border = "grey", col = "navy", xlab = "Values of R", : object 'R_val' not found
```

We create the serial interval (SI) distribution using:
[*distcrete*](https://github.com/reconhub/distcrete).
 

```r
library(distcrete)
library(epitrix)

cv <- mu/sigma # coefficient of variation
cv
```

```
## [1] 1.645161
```

```r
param <- gamma_mucv2shapescale(mu, cv) # convertion to Gamma parameters
param
```

```
## $shape
## [1] 0.3694733
## 
## $scale
## [1] 41.4103
```

```r
si <- distcrete::distcrete("gamma", interval = 1,
                           shape = param$shape,
                           scale = param$scale, w = 0)
si
```

```
## A discrete distribution
##   name: gamma
##   parameters:
##     shape: 0.369473279507882
##     scale: 41.4103017689906
```

We now use `project` to simulate future epicurves:

```r
library(projections)

future_i <- project(i, R = R_val, n_sim = 1000, si = si, n_days = 30)
```

```
## Error in sample(R, n_sim, replace = TRUE): object 'R_val' not found
```

```r
future_i
```

```
## Error in eval(expr, envir, enclos): object 'future_i' not found
```




## Vignettes

Vignettes are still in development.


## Websites

A dedicated website is still in development.




## Getting help online

Bug reports and feature requests should be posted on *github* using the
[*issue*](http://github.com/reconhub/earlyR/issues) system. All other questions
should be posted on the **RECON forum**: <br>
[http://www.repidemicsconsortium.org/forum/](http://www.repidemicsconsortium.org/forum/)

Contributions are welcome via **pull requests**.

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to abide by its
terms.

