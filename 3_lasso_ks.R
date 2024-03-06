
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


lasso_mod <- linear_reg(penalty = 0.01, mixture = 1) %>%
  set_engine("glmnet") |>  
  set_mode("regression")

#workflow 
lasso_workflow_ks <- workflow() |>
  add_model(lasso_mod) |>
  add_recipe(linear_ks)
keep_pred <- control_resamples(save_pred = TRUE)

# fitting models 
lasso_fit_ks <- fit_resamples(
  lasso_workflow_ks, 
  resamples = house_folds,
  control = keep_pred
)

save(lasso_fit_ks,
     file="results/lasso_fit_ks.rda")