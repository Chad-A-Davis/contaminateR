# Workflow steps 4-5: fit/refit GLMs and repeat contamination scenarios.
# Optional truth: named true coefficients retained in settings for simulation
# evaluation. Do not estimate truth from real data. This function studies one
# dataset; independent clean datasets belong in the outer simulation study.
# Keep stability comparisons against the clean reference for either data source.
# Aggregate known-truth metrics across independent datasets separately.
# Intended contract: fit the reference GLM, create the contamination scenario
# grid, refit each scenario repeatedly, and collect stability metrics. Record
# refit warnings/errors so one failed refit does not discard the entire study.
# Planned return: a contaminateR_result list with reference, scenarios, metrics,
# and settings. The print method should summarize refit counts and failures.
# Status: both functions are unimplemented and currently return NULL.

# Modeling/Simulation Engine team: GLMs are the initial supported model class.
run_sensitivity <- function(formula, data, columns, family = stats::gaussian(),
                            methods = c("gaussian", "uniform", "bias"),
                            proportions = c(0, 0.1, 0.25), magnitudes = c(0.5, 1),
                            repetitions = 10, alpha = 0.05, seed = NULL, truth = NULL) {}

print.contaminateR_result <- function(x, ...) {}
