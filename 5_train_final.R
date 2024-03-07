load(here::here("results/rf_tuned_fe.rda"))
load(here::here("results/rf_tuned_ks.rda"))
load(here::here("initial_processing/house_split.rda"))
load(here::here("initial_processing/house_folds.rda"))
load(here::here("initial_processing/house_recipe.rda"))
library(dplyr)
library(tidyverse)
library(rsample)
library(tidymodels)
library(kableExtra)
library(here)
tidymodels_prefer()
set.seed(123)
library(doMC)
num_cores <- parallel::detectCores(logical=TRUE)
registerDoMC(cores=num_cores)

final_wflow <-
  rf_tuned_fe |>
  extract_workflow() |>
  finalize_workflow(select_best(rf_tuned_fe, metric = "rmse"))

final_fit <- fit(final_wflow, house_train)

### 
house_metrics_final <- metric_set(rmse, rsq, mae, mape)


house_predict_rf <- house_test |>
  select(price_log10) |>
  bind_cols(10^predict(final_fit, house_test))


house_final_metrics <-
  house_metrics_final(house_predict_rf, price_log10, .pred) |>
  knitr::kable (digits = 3)
