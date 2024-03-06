load(here::here("results/house.rda"))
load(here::here("results/house_split.rda"))
load(here::here("results/house_folds.rda"))
load(here::here("results/house_recipe.rda"))
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
ridge_mod <- linear_reg(penalty = 0.01, mixture = 0) %>%
  set_engine("glmnet") |>  
  set_mode("regression")

# define workflows ----
ridge_workflow_ks <- workflow() |>
  add_model(ridge_mod) |>
  add_recipe(linear_ks)

keep_pred <- control_resamples(save_pred = TRUE)

ridge_fit_ks <- fit_resamples(
  ridge_workflow_ks, 
  resamples = house_folds,
  control = keep_pred
)

save(ridge_fit_ks,
     file="results/ridge_fit_ks.rda")