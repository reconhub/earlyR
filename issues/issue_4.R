library(outbreaks)
library(incidence)
library(earlyR)

i <- incidence(measles_hagelloch_1861$date_of_prodrome,
                                         interval = 1)


i_sub <- i[31:42, ]

R <- get_R(i_sub, si_mean = 10.89,
                  si_sd = 1.63, max_R = 10)

plot(R)

