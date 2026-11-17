# Data generation functions for SAMBA simulation
# This file defines functions only; it does not run the simulation.

calibrate_intercept <- function(target_prob, slope) {
  stopifnot(length(target_prob) == 1L, is.finite(target_prob),
            target_prob > 0, target_prob < 1,
            length(slope) == 1L, is.finite(slope))
  difference <- function(intercept) {
    integrate(function(x) plogis(intercept + slope * x) * dnorm(x),
              lower = -Inf, upper = Inf, rel.tol = 1e-9)$value - target_prob
  }
  uniroot(difference, interval = c(-40, 40), tol = 1e-9)$root
}

generate_data <- function(n, p_m, p_r, theta_z, beta_x,
                          theta_0 = NULL, beta_0 = NULL) {
  stopifnot(length(n) == 1L, is.finite(n), n >= 1, n == as.integer(n),
            p_m > 0, p_m < 1, p_r > 0, p_r < 1,
            is.finite(theta_z), is.finite(beta_x))
  if (is.null(theta_0)) theta_0 <- calibrate_intercept(p_r, theta_z)
  if (is.null(beta_0)) beta_0 <- calibrate_intercept(1 - p_m, beta_x)

  X <- rnorm(n)
  Z <- rnorm(n)
  p_D <- plogis(theta_0 + theta_z * Z)
  D <- rbinom(n, size = 1L, prob = p_D)
  c_X <- plogis(beta_0 + beta_x * X)
  Dstar <- rbinom(n, size = 1L, prob = D * c_X)

  data.frame(X = X, Z = Z, D = D, Dstar = Dstar,
             p_D = p_D, c_X = c_X)
}
