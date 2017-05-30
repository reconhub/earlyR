## ----data----------------------------------------------------------------

onset <- as.Date(c("2017-02-04", "2017-02-12", "2017-02-15",
                   "2017-02-23", "2017-03-01", "2017-03-01",
		   "2017-03-02", "2017-03-03", "2017-03-03"))		 


## ----incidence-----------------------------------------------------------

library(incidence)
i <- incidence(onset)
i
plot(i, border = "white")


## ----incidence2----------------------------------------------------------

today <- as.Date("2017-03-21")
i <- incidence(onset, last_date = today)
i
plot(i, border = "white")


## ----si------------------------------------------------------------------

mu <- 15.3 # mean in days days
sigma <- 9.3 # standard deviation in days


## ----estimate------------------------------------------------------------

library(earlyR)

res <- get_R(i, si_mean = mu, si_sd = sigma)
res
plot(res)

plot(res, "lambdas", scale = length(onset) + 1)
abline(v = onset, lwd = 3, col = "grey")
abline(v = today, col = "blue", lty = 2, lwd = 2)
points(onset, seq_along(onset), pch = 20, cex = 3)


## ----sample_R------------------------------------------------------------

R_val <- sample_R(res, 1000)
summary(R_val)
quantile(R_val)
quantile(R_val, c(0.025, 0.975))
hist(R_val, border = "grey", col = "navy",
     xlab = "Values of R",
     main = "Sample of likely R values")


## ----generate_si---------------------------------------------------------

si <- res$si
si


## ----projections---------------------------------------------------------

library(projections)

future_i <- project(i, R = R_val, n_sim = 1000, si = res$si, n_days = 30)
future_i
mean(future_i) # average incidence / day
plot(future_i)


## ----pred_size-----------------------------------------------------------

predicted_n <- colSums(future_i)
summary(predicted_n)
hist(predicted_n, col = "darkred", border = "white",
     main = "Prediction: new cases in 30 days",
     xlab = "Total number of new cases")


## ----alternative---------------------------------------------------------

alt_i <- incidence(onset)
alt_res <- get_R(alt_i, si_mean = mu, si_sd = sigma)
alt_R_val <- sample_R(alt_res, 1000)
alt_future_i <- project(alt_i, R = alt_R_val, n_sim = 1000, si = res$si, n_days = 30)
alt_future_i
mean(alt_future_i)
plot(alt_future_i)

## alternative plot
col <- "#cc66991a"
matplot(alt_future_i, type = "l", col = col, lty = 1, lwd = 5,
        xlab = "Day from today",
	ylab = "Projected daily incidence")

alt_predicted_n <- colSums(alt_future_i)
summary(alt_predicted_n)
hist(alt_predicted_n, col = "darkred", border = "white",
     main = "Prediction: new cases in 30 days",
     xlab = "Total number of new cases")


