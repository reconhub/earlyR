
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

## Vignettes

An overview and examples of *earlyR* are provided in the vignettes:

...

## Websites

The following websites are available:

...

## Getting help online

Bug reports and feature requests should be posted on *github* using the [*issue*](http://github.com/reconhub/earlyR/issues) system. All other questions should be posted on the **RECON forum**: <br>
[http://www.repidemicsconsortium.org/forum/](http://www.repidemicsconsortium.org/forum/)

Contributions are welcome via **pull requests**.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

