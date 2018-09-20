data {
  int<lower=1> K;
  int<lower=1> M;
  int<lower=1> V;
  int<lower=1> N;
  int<lower=1> D;
  vector[D] W[N];
  int<lower=1,upper=N> Offset[M,2]; // range of word index per doc
  
  vector<lower=0>[K] Alpha; // topic prior
  vector[V] Mu;
  real Nu;
  matrix[V,V] Sigma;
  
}
parameters {
  simplex[K] theta[M];
  vector[V] mu[K];
  matrix[V,V] sigma[K];
}
model {
  // prior
  for (m in 1:M)
    theta[m] ~ dirichlet(Alpha);
  for (k in 1:K){
    sigma[k] ~ inv_wishart(Nu, Sigma);
    mu[k] ~ multi_normal(Mu, sigma[k]);
  }
  
  // likelihood
  for (m in 1:M) {
    for (n in Offset[m,1]:Offset[m,2]) {
      real gamma[K];
      for (k in 1:K)
        gamma[k] = log(theta[m,k]) + multi_normal_lpdf(W[n]|mu[k], sigma[k]);
      target += log_sum_exp(gamma);
    }
  }
}