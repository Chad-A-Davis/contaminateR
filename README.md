# contaminateR

A documentation-only R package skeleton for studying how data contamination changes GLM estimates,
uncertainty, and inferential conclusions. This is an exploratory sensitivity tool;
thresholds for deployment decisions must be chosen and validated for each application.

## Project workflow

See [WORKFLOW.md](WORKFLOW.md) for the full 13-stage plan, including separate
known-truth evaluation and real-data stability branches, visualization/reporting,
simulation and case studies, quality control, integration, and final presentation.
Known-truth metrics will assess bias, RMSE, and coverage across independently
simulated datasets. Real-data metrics compare contaminated fits with the original
reference fit without assuming known coefficients.

## Planned usage (not implemented)

The package can be installed with `R CMD INSTALL .`. The following is a proposed
usage example; it does not perform an analysis yet:

```r
library(contaminateR)
data <- simulate_glm_data(n = 300, seed = 42)
result <- run_sensitivity(
  y ~ x1 + x2, data, columns = c("x1", "x2"),
  family = gaussian(), repetitions = 5, seed = 123
)
print(result)
head(result$metrics)
head(result$scenarios)
plot(result, term = "x1")
```

The intended API accepts your own data frame and formula. Planned binomial and Poisson
GLM support uses `family = binomial()` and `family = poisson()`.
For example, simulate binary outcomes with
`simulate_glm_data(family = "binomial", seed = 42)`.

## Planned behavior

All functions have empty bodies and currently return `NULL`. The R source files
contain implementation notes, and `man/contaminateR.Rd` documents arguments and
proposed return values. The example above illustrates the intended API and will
be usable once your teams implement it.

The planned workflow fits a reference GLM, contaminates selected numeric predictors
across a grid of methods, proportions, and magnitudes, repeatedly refits the model,
and reports coefficient changes, uncertainty changes, and significance flips.
Scenario results should record fit warnings and failures. Deployment thresholds
and automated reporting remain future design work.

## Team boundaries and next steps

| Team | Starting files | Suggested extensions |
| --- | --- | --- |
| Data Simulation | `R/simulate.R` | Independent clean datasets and named generating coefficients |
| Data Contamination | `R/contaminate.R` | Outliers, missingness, label noise, signed bias |
| Modeling/Simulation Engine | `R/engine.R` | Additional model adapters, parallel execution |
| Stability Metrics/Evaluation | `R/metrics.R` | Known-truth bias/RMSE/coverage and reference-based stability |
| Visualization/Real Data Application | `R/plot.R` | Aggregated summaries, public-data case studies, automated reports |

Future application work should define a domain-specific contamination grid,
validate it against plausible data problems, and calibrate alert thresholds on
held-out data. Automated reporting and deployment gates are future extensions.
No universal failure threshold is implemented.

## Development

Replace the placeholder maintainer in `DESCRIPTION` before publishing.
Run `R CMD build .`, then `R CMD check --no-manual contaminateR_0.0.0.9000.tar.gz`.
`tests/test-plan.R` contains a commented test plan for your future implementation.
See [CONTRIBUTING.md](CONTRIBUTING.md) for the review policy.

## Vignette

See [Getting started with contaminateR](vignettes/introduction.Rmd) for the
planned workflow and team handoff. Examples are not evaluated because the
functions are still empty stubs. Build the vignette with `R CMD build .`
(requires the suggested packages knitr and rmarkdown, plus Pandoc).
