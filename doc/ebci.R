## ---- include=FALSE, cache=FALSE----------------------------------------------
library("knitr")
knitr::opts_knit$set(self.contained = FALSE)
knitr::opts_chunk$set(tidy = TRUE, collapse=TRUE, comment = "#>",
                      tidy.opts=list(blank=FALSE, width.cutoff=55))

## -----------------------------------------------------------------------------
library("ebci")
## If m_2=0, then we get the usual critical value
cva(m2=0, kappa=Inf, alpha=0.05)$cv
## Otherwise the critical value is larger:
cva(m2=4, kappa=Inf, alpha=0.05)$cv
## Imposing a constraint on kurtosis tightens it
cva(m2=4, kappa=3, alpha=0.05)$cv

## -----------------------------------------------------------------------------
## For illustration, only use 20 largest CZ
df <- cz[sort(cz$pop, index.return=TRUE, decreasing=TRUE)$ix[1:20], ]

## As Y_i, use fixed effect estimate theta25 of causal effect of neighborhood for children with parents at the 25th percentile of income distribution. The standard error for this estimate is se25. As predictors use average outcome for permanent residents (stayers), stayer25. Let us use 90% CIs.
r <- ebci(formula=theta25~stayer25, data=df, se=se25, alpha=0.1, kappa=Inf)

## -----------------------------------------------------------------------------
r$delta

## -----------------------------------------------------------------------------
c(r$sqrt_mu2, r$kappa)

## -----------------------------------------------------------------------------
names(r$df)

## -----------------------------------------------------------------------------
cva(m2=((1-1/r$df$w_eb[1])*r$sqrt_mu2/r$df$se[1])^2, Inf, alpha=0.1)$cv*
r$df$w_eb[1]*r$df$se[1]
r$df$len_eb[1]

## -----------------------------------------------------------------------------
knitr::kable(data.frame(name=paste0(df$czname, ", ", df$state), estimate=r$df$th_eb,
lower_ci=r$df$th_eb-r$df$len_eb, upper_ci=r$df$th_eb+r$df$len_eb), digits=3)

## -----------------------------------------------------------------------------
knitr::kable(data.frame(name=paste0(df$czname, ", ", df$state), estimate=r$df$th_op,
lower_ci=r$df$th_op-r$df$len_op, upper_ci=r$df$th_op+r$df$len_op), digits=3)

## -----------------------------------------------------------------------------
mean(r$df$len_op)/mean(r$df$len_eb)

## -----------------------------------------------------------------------------
mean(r$df$ncov_pa)

