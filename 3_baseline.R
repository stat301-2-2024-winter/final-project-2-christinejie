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

null_spec <- null_model() %>% 
  set_engine("parsnip") %>% 
  set_mode("regression") 


#ks 
null_workflow_ks <- workflow() %>% 
  add_model(null_spec) %>% 
  add_recipe(linear_ks)

null_fit_ks <- null_workflow_ks |> 
  fit_resamples(
    resamples = house_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

rmse_null_ks <- null_fit_ks %>% 
  collect_metrics() %>% 
  filter(.metric == "rmse")

rmse_null_ks

#fe 
null_workflow_fe <- workflow() %>% 
  add_model(null_spec) %>% 
  add_recipe(linear_fe)

null_fit_fe <- null_workflow_fe |> 
  fit_resamples(
    resamples = house_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

rmse_null_fe <- null_fit_fe %>% 
  collect_metrics() %>% 
  filter(.metric == "rmse")

rmse_null_fe




save(null_spec,
     null_workflow,
     null_fit,
     rmse_null,
     file="results/null.rda")