library(rstan)

load("./20news.RData")

data = list(
  K = K,
  M = M,
  V = V,
  N = N,
  D = 50,
  W = corpus.lda$vector,
  Offset = offset,
  Alpha = rep(1, K),
  Mu = rep(0, V),
  Nu = 1,
  Sigma = matrix()
)

sm = stan_model(file = "./gaussianlda.stan")

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
  eta = .1 # best eta
)


