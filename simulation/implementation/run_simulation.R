# Expects the existing simulation/implementation/sim_grid.R.

source("simulation/implementation/sim_grid.R")
source("simulation/generation/generate_data.R")
source("simulation/analysis/fit_models.R")

# Pilot first. Change to seq_len(nrow(sim_grid)) and n_reps for full run.
scenario_ids <- seq_len(nrow(sim_grid))
rep_ids <- seq_len(n_reps)

output_dir <- "results/model_fits"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

stopifnot(all(c("n", "p_m", "p_r", "theta_z", "beta_x") %in% names(sim_grid)))
if (!"scenario" %in% names(sim_grid)) sim_grid$scenario <- seq_len(nrow(sim_grid))

for (i in scenario_ids) {
  condition <- sim_grid[i, , drop = FALSE]
  theta_0 <- calibrate_intercept(condition$p_r, condition$theta_z)
  beta_0 <- calibrate_intercept(1 - condition$p_m, condition$beta_x)

  results <- vector("list", length(rep_ids))
  for (j in seq_along(rep_ids)) {
    rep <- rep_ids[j]
    seed <- 777 + (condition$scenario - 1) * n_reps + rep
    set.seed(seed)

    dat <- generate_data(n = condition$n, p_m = condition$p_m,
                         p_r = condition$p_r, theta_z = condition$theta_z,
                         beta_x = condition$beta_x,
                         theta_0 = theta_0, beta_0 = beta_0)

    stopifnot(!any(dat$D == 0 & dat$Dstar == 1))
    fits <- fit_models(dat, beta_0 = beta_0, c_marg = 1 - condition$p_m)
    fits$scenario <- condition$scenario
    fits$replication <- rep
    fits$seed <- seed
    fits$n <- condition$n
    fits$p_m <- condition$p_m
    fits$p_r <- condition$p_r
    fits$theta_z <- condition$theta_z
    fits$beta_x <- condition$beta_x
    results[[j]] <- fits
  }

  result_df <- do.call(rbind, results)
  filename <- sprintf("scenario_%03d.csv", condition$scenario)
  write.csv(result_df, file.path(output_dir, filename), row.names = FALSE)
  message("Saved ", filename)
}
