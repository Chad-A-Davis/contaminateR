# Planned project workflow

All functions remain empty stubs. This document maps the project stages to future
implementation and deliverables.

| Step | Work to complete | Starting point / owner |
| --- | --- | --- |
| 1. Design the package | Agree on inputs, result schemas, assumptions, and interfaces between teams. | All teams; DESCRIPTION, NAMESPACE, and function documentation |
| 2. Simulate clean data with known truth | Generate independent datasets; retain named generating coefficients and scenario settings. | Data Simulation; R/simulate.R |
| 3. Contaminate the data | Specify methods, proportions, magnitudes, row selection, and reproducibility. | Data Contamination; R/contaminate.R |
| 4. Fit / refit GLMs | Fit the original-data reference, then fit contaminated datasets with consistent formulas and families. | Modeling/Simulation Engine; R/engine.R |
| 5. Repeat through the stress-test engine | Iterate the contamination grid and repetitions; record warnings, failures, and settings. | Modeling/Simulation Engine; run_sensitivity() |
| 6. Known-truth metrics | Compare estimates with generating coefficients; summarize bias, RMSE, and interval coverage. | Stability Metrics/Evaluation; known_truth_metrics() |
| 7. Real-data stability metrics | Compare estimates, SEs, and significance against the original-data reference. | Stability Metrics/Evaluation; stability_metrics() |
| 8. Visualization & reporting | Summarize each applicable metric branch; show scenario settings, variation, valid counts, and failures. | Visualization/Real Data Application; R/plot.R and future reporting design |
| 9. Simulation study | Vary sample size, family, truth, and contamination; evaluate performance across independent datasets. | Data Simulation with Modeling and Metrics teams; planned study artifact |
| 10. Real-world case study | Select documented data, motivate contamination scenarios, and interpret observed stability. | Visualization/Real Data Application; planned case-study artifact |
| 11. Testing & quality control | Validate contracts, numerical results, reproducibility, and failure handling; obtain three PR approvals. | All teams; tests/test-plan.R and CONTRIBUTING.md |
| 12. Package integration & documentation | Integrate modules, complete help and vignette, and run package checks. | All teams; man/, vignettes/, README.md |
| 13. Final presentation | Present design, simulation results, case study, limitations, and reproducible usage. | All teams; planned presentation artifact |

Stages 6 and 7 are parallel evaluation branches that feed visualization and
reporting. Simulations can use both branches; real data use reference-based
stability because the true generating coefficients are unknown. Stages 9 and 10
are complementary applications that feed quality control, integration, and the
final presentation. Testing should also happen throughout development.

## Separate the two kinds of repetition

The stress-test engine repeats contamination and GLM refits for one input dataset.
The simulation study needs an outer loop that generates independent clean datasets
and runs that engine for each dataset. Group fits by contamination scenario across
those independent datasets when computing bias, RMSE, and coverage. Do not treat
many perturbations of one dataset as independent datasets for coverage claims.

Keep truth as a named coefficient vector in the simulation study configuration,
with names matching fitted terms. Pass it through the optional `truth` argument
when running a simulated dataset. Real-data studies leave `truth = NULL`.

## Reporting and delivery

Decide on a report format before adding a reporting API. Reports should describe
the model, data source, simulation truth when available, contamination grid, seeds,
metric definitions, aggregate results, failed fits, and limitations. Any alert
threshold must be justified for the application. The simulation study, real-world
case study, and presentation are project deliverables rather than additional
required public package functions.
