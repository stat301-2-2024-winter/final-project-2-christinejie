
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


# tune penalty and mixure 

en_mod <- linear_reg(penalty = tune(), mixture = tune()) %>%
  set_engine("glmnet") |>  
  set_mode("regression")

en_params <- extract_parameter_set_dials(en_mod) |>
  update(penalty = penalty(range = c(-3, 0))) |>
  update(mixture = mixture(range = c(0, 1)))
           
           
en_grid <- grid_regular(en_params, levels = 5)


#workflow 
en_workflow_fe <- workflow() |>
  add_model(en_mod) |>
  add_recipe(lin_fe)

keep_pred <- control_resamples(save_pred = TRUE)

# fitting models 
en_tuned_fe <-
  en_workflow_fe |> tune_grid(
    house_folds,
    grid = en_grid,
    control = control_grid(save_workflow = TRUE))


en_best_fe <- show_best(en_tuned_fe, metric = "rmse")

save(en_tuned_fe,
     file="results/en_tuned_fe.rda")


