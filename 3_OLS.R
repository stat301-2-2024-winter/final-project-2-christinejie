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

lm_spec <- linear_reg() |> 
  set_mode("regression") |> 
  set_engine("lm")


#ks 
lm_workflow_ks <- workflow() %>% 
  add_model(lm_spec) %>% 
  add_recipe(linear_ks)


lm_fit_ks <- lm_workflow_ks |> 
  fit_resamples(
    resamples = house_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

save(lm_fit_ks,
     file="results/lm_fit_ks.rda")


#fe 

lm_workflow_fe <- workflow() %>% 
  add_model(lm_spec) %>% 
  add_recipe(tree_fe)


lm_fit_fe <- lm_workflow_fe |> 
  fit_resamples(
    resamples = house_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

save(lm_fit_fe,
     file="results/lm_fit_fe.rda")

lm_fit_fe |> 
  collect_metrics()
