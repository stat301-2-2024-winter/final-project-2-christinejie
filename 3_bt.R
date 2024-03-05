load(here::here("results/house.rda"))
load(here::here("results/house_split.rda"))
load(here::here("results/house_folds.rda"))
load(here::here("results/house_recipe.rda"))
load(here::here("results/lm.rda"))
load(here::here("results/null.rda"))
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






boosted_tree_mod <- boost_tree(
  mode = "regression",
  mtry = tune(),
  min_n = tune(),
  learn_rate = tune()
) |>
  set_engine("xgboost")


bt_workflow <- workflow() |> 
  add_model(boosted_tree_mod) |> 
  add_recipe(tree_ks)

bt_params <- extract_parameter_set_dials(boosted_tree_mod) |> 
  update(mtry = mtry(c(1, 14))) |> 
  update(learn_rate = learn_rate(c(-5, -0.2)))

# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)


bt_tuned <-
  bt_workflow |> tune_grid(house_folds,
                           grid = bt_grid,
                           control = control_grid(save_workflow = TRUE))


bt_best <- show_best(bt_tuned, metric = "rmse")

