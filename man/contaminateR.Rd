\name{contaminateR}
\alias{simulate_glm_data}
\alias{contaminate_data}
\alias{run_sensitivity}
\alias{stability_metrics}
\alias{known_truth_metrics}
\alias{print.contaminateR_result}
\alias{plot.contaminateR_result}
\title{Explore GLM sensitivity to numeric predictor contamination}
\description{Documented function stubs for a planned GLM sensitivity workflow. All function bodies are empty and currently return NULL. The contracts below describe intended behavior, not implemented functionality.}
\usage{
simulate_glm_data(n = 200, family = c("gaussian", "binomial", "poisson"),
                 beta = c(0, 1, -1), seed = NULL)
contaminate_data(data, columns, method = c("gaussian", "uniform", "bias"),
                 proportion = 0.1, magnitude = 1, seed = NULL)
run_sensitivity(formula, data, columns, family = stats::gaussian(),
                methods = c("gaussian", "uniform", "bias"),
                proportions = c(0, 0.1, 0.25), magnitudes = c(0.5, 1),
                repetitions = 10, alpha = 0.05, seed = NULL, truth = NULL)
stability_metrics(reference, fitted, alpha = 0.05)
known_truth_metrics(fits, truth, conf_level = 0.95)
\method{print}{contaminateR_result}(x, ...)
\method{plot}{contaminateR_result}(x, term = NULL, ...)
}
\arguments{
\item{fits}{List of GLM fits from independent simulated datasets under a common scenario.}
\item{truth}{Optional named vector of generating coefficients for the engine; required for known-truth metrics. Names must match model terms.}
\item{conf_level}{Confidence level for planned interval coverage evaluation.}
\item{n}{Number of simulated observations, at least two.}
\item{family}{Simulation family name, or for the engine a family accepted by \code{stats::glm}.}
\item{beta}{Finite coefficients, intercept first, followed by at least one slope.}
\item{seed}{Optional random seed. When supplied, caller RNG state is restored.}
\item{data}{Nonempty data frame. Missing model values are rejected by the engine.}
\item{columns}{Distinct numeric columns to contaminate; response columns are rejected by the engine.}
\item{method, methods}{Gaussian noise, symmetric uniform noise, or constant positive bias.}
\item{proportion, proportions}{Fractions of rows in the interval zero to one.}
\item{magnitude, magnitudes}{Nonnegative noise standard deviation, uniform half-width, or bias amount in original units.}
\item{formula}{GLM formula.}
\item{repetitions}{Positive integer number of refits per scenario.}
\item{alpha}{Significance threshold between zero and one.}
\item{reference, fitted}{Reference and contaminated GLM fits.}
\item{x}{A sensitivity analysis result.}
\item{term}{Coefficient name to plot; defaults to the first term.}
\item{...}{Additional plotting arguments; ignored by print.}
}
\details{The following behavior is planned for implementation. Contamination samples floor(n times proportion) rows without replacement and uses the same rows across selected columns. Refit errors and warnings are recorded in the scenario table. Coefficients omitted by singular fits may have missing metrics. Significance comparisons use GLM summary p-values. Known-truth evaluation will summarize bias, RMSE, and interval coverage across independent simulated datasets. Repeated perturbations of a single dataset do not constitute independent simulation replicates. Real-data stability compares against the reference fit without assuming known truth. No deployment threshold is imposed.}
\value{Currently all functions return \code{NULL}. Planned return values: Simulation and contamination return data frames. The engine returns a \code{contaminateR_result} list containing \code{reference}, \code{scenarios}, \code{metrics}, and \code{settings}. Metrics return a data frame of coefficient changes, reference-SE-standardized changes, SE ratios, and significance flips. Known-truth metrics return per-term bias, RMSE, coverage, and usable replicate counts. Print and plot invisibly return the result.}
\examples{
\dontrun{
# Planned usage after implementation:
d <- simulate_glm_data(seed = 1)
r <- run_sensitivity(y ~ x1 + x2, d, "x1", repetitions = 1, seed = 2)
print(r)
head(r$metrics)
}
}
