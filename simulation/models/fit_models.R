# Fit SAMBA estimators to one simulated dataset.
# Oracle sensitivity is used for approxdist and nonlogistic.
# obsloglik fixes the sensitivity intercept to its true value.

fit_models <- function(dat, beta_0, c_marg = NULL) {
  if (!requireNamespace("SAMBA", quietly = TRUE)) {
    stop("Install the SAMBA package before fitting models.")
  }
  stopifnot(all(c("X", "Z", "Dstar", "c_X") %in% names(dat)),
            is.finite(beta_0))
  if (is.null(c_marg)) stop("Provide theoretical marginal sensitivity (1 - p_m).")
  stopifnot(is.finite(c_marg), c_marg > 0, c_marg < 1)

  Z <- matrix(dat$Z, ncol = 1L, dimnames = list(NULL, "Z"))
  X <- matrix(dat$X, ncol = 1L, dimnames = list(NULL, "X"))
  Dstar <- dat$Dstar

  extract_result <- function(method, expression, slope_position, variance_position,
                             variance_matrix = FALSE) {
    warnings <- character()
    fit <- tryCatch(
      withCallingHandlers(expression, warning = function(w) {
        warnings <<- c(warnings, conditionMessage(w))
        invokeRestart("muffleWarning")
      }),
      error = function(e) e
    )
    if (inherits(fit, "error")) {
      return(data.frame(method = method, estimate = NA_real_, se = NA_real_,
                        status = "error", message = conditionMessage(fit)))
    }
    result <- tryCatch({
      estimate <- as.numeric(fit$param[slope_position])
      variance <- if (variance_matrix) {
        as.numeric(fit$variance[variance_position, variance_position])
      } else {
        as.numeric(fit$variance[variance_position])
      }
      se <- sqrt(variance)
      if (length(estimate) != 1L || length(se) != 1L ||
          !is.finite(estimate) || !is.finite(se) || se <= 0) {
        stop("Nonfinite estimate or invalid standard error")
      }
      data.frame(method = method, estimate = estimate, se = se,
                 status = "ok", message = paste(unique(warnings), collapse = " | "))
    }, error = function(e) {
      data.frame(method = method, estimate = NA_real_, se = NA_real_,
                 status = "invalid", message = conditionMessage(e))
    })
    result
  }

  approx <- extract_result(
    "approxdist",
    SAMBA::approxdist(Dstar = Dstar, Z = Z, c_marg = c_marg),
    slope_position = 1L, variance_position = 1L
  )

  nonlog <- extract_result(
    "nonlogistic",
    SAMBA::nonlogistic(Dstar = Dstar, Z = Z, c_X = dat$c_X),
    slope_position = 2L, variance_position = 2L
  )

  naive_fit <- tryCatch(
    glm(Dstar ~ Z[, 1], family = binomial()),
    error = function(e) NULL
  )
  
  naive_theta <- if (!is.null(naive_fit)) {
    coef(naive_fit)
  } else {
    c(NA_real_, NA_real_)
  }
  
  naive <- if (!is.null(naive_fit)) {
    extract_result(
      "naive",
      list(
        param = coef(naive_fit),
        variance = diag(vcov(naive_fit))
      ),
      slope_position = 2L,
      variance_position = 2L
    )
  } else {
    data.frame(
      method = "naive",
      estimate = NA_real_,
      se = NA_real_,
      status = "error",
      message = "Naive glm failed"
    )
  }
  
  naive_beta <- tryCatch(coef(glm(Dstar ~ X[, 1], family = binomial())),
                         error = function(e) c(NA_real_, NA_real_))
  start <- c(naive_theta[1:2], beta_0, naive_beta[2])
  if (any(!is.finite(start))) start <- c(qlogis(mean(Dstar) + 1e-6), 0, beta_0, 0)
  
  obs <- extract_result(
    "obsloglik",
    SAMBA::obsloglik(Dstar = Dstar, Z = Z, X = X,
                     start = start, beta0_fixed = beta_0),
    slope_position = 2L, variance_position = 2L,
    variance_matrix = TRUE
  )
  
  rbind(naive, approx, nonlog, obs)
}
