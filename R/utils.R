# Internal helper contracts (unimplemented; currently return NULL):
# with_seed: evaluate code with an optional seed, restoring caller RNG state even
# on error. With seed = NULL, use the caller's normal random-number stream.
# check_number: validate a finite numeric scalar against inclusive bounds and an
# optional integer constraint; reject invalid input with an informative error.

# Evaluate random operations without changing the caller's RNG state when seeded.
with_seed <- function(seed, code) {}

check_number <- function(x, name, lower = -Inf, upper = Inf, integer = FALSE) {}
