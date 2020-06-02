// generated with brms 2.13.0
functions {
}
data {
  int<lower=1> N;  // number of observations
  vector[N] Y;  // response variable
  int<lower=1> K_top;  // number of population-level effects
  matrix[N, K_top] X_top;  // population-level design matrix
  int<lower=1> K_beta;  // number of population-level effects
  matrix[N, K_beta] X_beta;  // population-level design matrix
  int<lower=1> K_nec;  // number of population-level effects
  matrix[N, K_nec] X_nec;  // population-level design matrix
  int<lower=1> K_d;  // number of population-level effects
  matrix[N, K_d] X_d;  // population-level design matrix
  // covariate vectors for non-linear functions
  vector[N] C_1;
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
}
parameters {
  vector[K_top] b_top;  // population-level effects
  vector[K_beta] b_beta;  // population-level effects
  vector[K_nec] b_nec;  // population-level effects
  vector[K_d] b_d;  // population-level effects
  real<lower=0> phi;  // precision parameter
}
transformed parameters {
}
model {
  // initialize linear predictor term
  vector[N] nlp_top = X_top * b_top;
  // initialize linear predictor term
  vector[N] nlp_beta = X_beta * b_beta;
  // initialize linear predictor term
  vector[N] nlp_nec = X_nec * b_nec;
  // initialize linear predictor term
  vector[N] nlp_d = X_d * b_d;
  // initialize non-linear predictor term
  vector[N] mu;
  for (n in 1:N) {
    // compute non-linear predictor values
    mu[n] = inv_logit(nlp_top[n] * exp( - nlp_beta[n] * (C_1[n] - nlp_nec[n]) ^ nlp_d[n] * step(C_1[n] - nlp_nec[n])));
  }
  // priors including all constants
  target += normal_lpdf(b_top | 2, 100);
  target += gamma_lpdf(b_beta | 0.0001, 0.0001);
  target += uniform_lpdf(b_nec | 0.0001, 0.9999);
  target += normal_lpdf(b_d | 0, 100);
  target += gamma_lpdf(phi | 0.01, 0.01);
  // likelihood including all constants
  if (!prior_only) {
    target += beta_lpdf(Y | mu * phi, (1 - mu) * phi);
  }
}
generated quantities {
}
