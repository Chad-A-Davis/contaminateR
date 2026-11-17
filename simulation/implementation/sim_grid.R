
n_levels <- c(500, 1000, 5000) # sample size
p_m_levels <- c(0.15, 0.30, 0.60) # false-negative (miss rate)
p_r_levels <- c(0.05, 0.10, 0.30) # disease prevalence P(D = 1)
theta_z_levels <- c(0.1, 0.5, 1) # disease-model slope
beta_x_levels <- c(0.1, 0.5, 1) # sensitivity-model slope

n_reps <- 200

sim_grid <- expand.grid(
  n = n_levels,
  p_m = p_m_levels,
  p_r = p_r_levels,
  theta_z = theta_z_levels,
  beta_x = beta_x_levels
)

sim_grid$scenario <- seq_len(nrow(sim_grid))
sim_grid <- sim_grid[, c("n", "p_m", "p_r", "theta_z", "beta_x")]

nrow(sim_grid)
head(sim_grid)
