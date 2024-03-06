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
ridge_mod <- linear_reg(penalty = 0.01, mixture = 0) %>%
  set_engine("glmnet") |>  
  set_mode("regression")

# define workflows ----
ridge_workflow_fe <- workflow() |>
  add_model(ridge_mod) |>
  add_recipe(tree_fe)

keep_pred <- control_resamples(save_pred = TRUE)

ridge_fit_fe <- fit_resamples(
  ridge_workflow_fe, 
  resamples = house_folds,
  control = keep_pred
)

ridge_fit_fe |> 
  collect_metrics()

save(ridge_fit_fe,
     file="results/ridge_fit_fe.rda")