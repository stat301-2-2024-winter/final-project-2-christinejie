load(here::here("results/bt_tuned_fe.rda"))
load(here::here("results/bt_tuned_ks.rda"))
load(here::here("results/knn_tuned_fe.rda"))
load(here::here("results/knn_tuned_ks.rda"))
load(here::here("results/lasso_fit_fe.rda"))
load(here::here("results/lasso_fit_ks.rda"))
load(here::here("results/lm_fit_fe.rda"))
load(here::here("results/lm_fit_ks.rda"))
load(here::here("results/null_fit_fe.rda"))
load(here::here("results/null_fit_ks.rda"))
load(here::here("results/ridge_fit_fe.rda"))
load(here::here("results/ridge_fit_ks.rda"))
load(here::here("results/rf_tuned_fe.rda"))
load(here::here("results/rf_tuned_ks.rda"))
library(dplyr)
library(tidyverse)
library(rsample)
library(tidymodels)
library(kableExtra)
library(here)
tidymodels_prefer()
library(doMC)
num_cores <- parallel::detectCores(logical=TRUE)
registerDoMC(cores=num_cores)


#table 

bt_best_fe <- bt_tuned_fe |> 
  show_best("rmse") |> 
  slice_min(mean) 

bt_best_ks <- bt_tuned_ks |> 
  show_best("rmse") |> 
  slice_min(mean) 

knn_best_fe <- knn_fit_fe |> 
  show_best("rmse") |> 
  slice_min(mean) 

knn_best_ks <- knn_fit_ks |> 
  show_best("rmse") |> 
  slice_min(mean) 

lasso_best_ks <-lasso_fit_ks |> 
  collect_metrics()

lasso_best_fe <- lasso_fit_fe |> 
  collect_metrics()

lm_best_ks <- lm_fit_ks |> 
  collect_metrics()

lm_best_fe <- lm_fit_fe |> 
  collect_metrics()


ridge_best_fe <- ridge_fit_fe |> 
  collect_metrics()

ridge_best_ks <- ridge_fit_ks |> 
  collect_metrics()

rf_best_ks <- rf_tuned_ks |> 
  show_best("rmse") |> 
  slice_min(mean) 

rf_best_fe <- rf_tuned_fe |> 
  show_best("rmse") |> 
  slice_min(mean) 

en_best_fe <- show_best(en_tuned_fe, metric = "rmse") |> 
  slice_min(mean) 

en_best_ks <- show_best(en_tuned_ks, metric = "rmse") |> 
  slice_min(mean) 


baseline_best_ks <- null_fit_ks |> 
  collect_metrics()

baseline_best_fe <- null_fit_fe |> 
  collect_metrics()

house_metrics <- bind_rows(
  bt_best_fe %>% mutate(model = "BT FE"),
  bt_best_ks %>% mutate(model = "BT KS"),
  knn_best_fe %>% mutate(model = "KNN FE"),
  knn_best_ks  %>% mutate(model = "KNN KS"),
  lm_best_fe |>  mutate(model = "Linear FE"),
  lm_best_ks |>  mutate(model = "Linear KS"),
  rf_best_ks |> mutate(model="RF KS"),
  rf_best_fe |> mutate(model="RF FE"),
  en_best_fe |>  mutate (model = "EN FE"),
  en_best_ks |>  mutate (model = "EN KS"),
  baseline_best_ks |>  mutate (model = "Baseline KS"),
  baseline_best_fe |>  mutate (model = "Baseline FE")
)


rmse_table <- house_metrics %>%
  filter(.metric == "rmse") |> 
  rename("Standard Error" = std_err) |>
  rename(RMSE = mean) |>
  rename("Model Type" = model) |>
  rename("Number Computations" = n) |>
  arrange(RMSE) |> 
  select("Model Type", RMSE, "Standard Error") %>%
  knitr::kable(digits = c(NA, 2, 4, 0))
  
rmse_table


save(house_metrics,
     rmse_table,
     file="results/model_results.rda")