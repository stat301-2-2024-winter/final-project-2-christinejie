
load(here::here("initial_processing/house_split.rda"))
load(here::here("initial_processing/house_folds.rda"))
load(here::here("initial_processing/house_recipe.rda"))
library(tidyverse)
library(rsample)
library(parsnip)
library(tidymodels)
library(glmnet)
library(ranger)
library(kknn)
library(kableExtra)
set.seed(123)
library(here)
tidymodels_prefer()
library(doMC)
num_cores <- parallel::detectCores(logical=TRUE)
registerDoMC(cores=num_cores)

# model specifications ----
knn_mod <-
  nearest_neighbor(mode = "regression", neighbors = tune())  |> 
  set_engine("kknn")


# define workflows ----
knn_workflow_fe <- workflow() |> 
  add_model(knn_mod) |> 
  add_recipe(tree_fe)

knn_params <- extract_parameter_set_dials(knn_mod) 

knn_grid <- grid_regular(knn_params, levels = 5)

knn_fit_fe <- tune_grid(
  knn_workflow_fe,
  house_folds,
  grid = knn_grid,
  control = control_grid(save_workflow = TRUE)
)

save(knn_fit_fe,
     file="results/tuned_knn_fe.rda")