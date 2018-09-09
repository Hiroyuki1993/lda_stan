library(rstan)

load("./20news.RData")

data = list(
  K = K,
  M = M,
  V = V,
  N = N,
  W = corpus.tidy$word,
  Offset = offset,
  Alpha = rep(1, K),
  Beta = rep(0.5, V)
)

sm = stan_model(file = "./lda.stan")

fit = stan(
  file = "./lda.stan",
  data = data,
  iter = 1000,
  chains = 1,
  thin = 1
)

fit.vb = vb(
  sm,
  data = data,
  output_samples = 2000,
  adapt_engaged = FALSE,
  eta = 1
)
