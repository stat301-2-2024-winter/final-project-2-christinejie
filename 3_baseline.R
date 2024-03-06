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

save(null_fit_ks,
     file="results/null_fit_ks.rda")


# rmse_null_ks <- null_fit_ks %>% 
#   collect_metrics() %>% 
#   filter(.metric == "rmse")
# 
# rmse_null_ks

#fe 
null_workflow_fe <- workflow() %>% 
  add_model(null_spec) %>% 
  add_recipe(linear_fe)

null_fit_fe <- null_workflow_fe |> 
  fit_resamples(
    resamples = house_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

save(null_fit_fe,
     file="results/null_fit_fe.rda")


# rmse_null_fe <- null_fit_fe %>%
#   collect_metrics() %>%
#   filter(.metric == "rmse")
# 
# rmse_null_fe



