load(here::here("initial_processing/house_split.rda"))
load(here::here("initial_processing/house_folds.rda"))
load(here::here("initial_processing/house_recipe.rda"))
library(tidyverse)
library(rsample)
library(parsnip)
library(tidymodels)
library(ranger)

set.seed(123)
library(here)
tidymodels_prefer()
library(doMC)
num_cores <- parallel::detectCores(logical=TRUE)
registerDoMC(cores=num_cores)

# model specifications ----
rf_mod <- 
  rand_forest(
    mode = "regression",
    trees = 500, 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger")

extract_parameter_set_dials(rf_mod)

# define workflows ----
rf_workflow_ks <- workflow() |> 
  add_model(rf_mod) |> 
  add_recipe(tree_ks)


# hyperparameter tuning values ----
rf_params <- extract_parameter_set_dials(rf_mod) |>
  update(mtry = mtry(range = c(1, 7)))

rf_grid <- grid_regular(rf_params, levels = 5)

rf_tuned_ks <- tune_grid(
  rf_workflow_ks,
  house_folds,
  grid = rf_grid,
  control = control_grid(save_workflow = TRUE)
)

# write out results (fitted/trained workflows) ----
save(rf_tuned_ks,file=here("results/rf_tuned_ks.rda"))