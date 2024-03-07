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
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)


###
house_metrics_final <- metric_set(rmse, rsq, mae)

house_predict_rf_not_log <- house_test |>
  mutate(price = 10 ^ price_log10) |>
  select(price) |>
  bind_cols(10 ^ predict(final_fit, house_test))

house_final_metrics_not_log <-
  house_metrics_final(house_predict_rf_not_log, price, .pred) |>
  knitr::kable (digits = 3)

house_predict_rf_log <- house_test |>
  select(price_log10) |>
  bind_cols(predict(final_fit, house_test))

house_final_metrics_log <-
  house_metrics_final(house_predict_rf_log, price_log10, .pred) |>
  knitr::kable (digits = 3)
