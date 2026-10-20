# Intended contract: coefficient_table extracts term, estimate, SE, and p-value
# from a GLM. stability_metrics aligns terms with the reference fit and computes
# signed/absolute changes, changes divided by reference SE, SE ratios, and
# significance flips at alpha. Define missing-value behavior for aliased terms
# and zero reference SEs before implementation.
# Planned return: data frames, one row per coefficient term.
# Status: both functions are unimplemented and currently return NULL.

# Stability Metrics team: comparisons use the reference model's coefficient names.
coefficient_table <- function(model) {}

stability_metrics <- function(reference, fitted, alpha = 0.05) {}

# Known-truth branch (Data Simulation + Stability Metrics teams).
# Intended contract: accept a list of GLM fits from independent simulated datasets
# under one scenario and a named vector of true coefficients (matching fit terms).
# Compute per-term bias, RMSE, and confidence-interval coverage at conf_level.
# Use the family-appropriate inference convention and document it. Record valid
# fit counts; define treatment of failed fits, aliased terms, and unavailable CIs.
# Repeated contaminations of one dataset measure conditional sensitivity; they
# must not be presented as independent simulation replicates for coverage.
# Planned return: one summary row per term, including usable replicate counts.
# Status: unimplemented; currently returns NULL.
known_truth_metrics <- function(fits, truth, conf_level = 0.95) {}
