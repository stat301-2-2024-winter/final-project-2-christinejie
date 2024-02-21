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

null_workflow <- workflow() %>% 
  add_model(null_spec) %>% 
  add_recipe(house_recipe_standard)

null_fit <- null_workflow |> 
  fit_resamples(
    resamples = house_folds, 
    control = control_resamples(save_workflow = TRUE)
  )


rmse_null <- null_fit %>% 
  collect_metrics() %>% 
  filter(.metric == "rmse")

save(null_spec,
     null_workflow,
     null_fit,
     rmse_null,
     file="results/null.rda")