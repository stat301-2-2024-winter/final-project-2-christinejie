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

lm_spec <- linear_reg() |> 
  set_mode("regression") |> 
  set_engine("lm")

lm_workflow <- workflow() %>% 
  add_model(lm_spec) %>% 
  add_recipe(house_recipe_standard)


lm_fit <- lm_workflow |> 
  fit_resamples(
    resamples = house_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

rmse_lm <- lm_fit %>% 
  collect_metrics() %>% 
  filter(.metric == "rmse")

save(lm_spec,
     lm_workflow,
     lm_fit,
     rmse_lm,
     file="results/lm.rda")
