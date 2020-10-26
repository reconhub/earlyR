# earlyR 0.0.4

## New features

- graphs are now using ggplot2




# earlyR 0.0.3

## Bug fixes

- fix issue #11 where the likelihood surface was incorrectly calculated.
  This unfortunately reverts the issue from #4




# earlyR 0.0.2

## New features

- heat colors in the plot of lambdas have been replaced by a constant color


## Bug fixes

- fixed issue 4 relating to low log-likelihood values which resulted in constant
  zeros when reverted back to the likelihood scale





# earlyR 0.0.1

The main features of the package include:

- **`get_R`**: a function to estimate *R* as well as the force of infection over
    time, from incidence data; output is an object of class `earlyR`

- **`sample_R`**: a function to obtain a sample of likely *R* values

- **`plot`**: a function to visualise `earlyR` objects (*R* or force of infection).

- **`points`**: a function using `earlyR` objects to add the force of infection
    to an existing plot.
