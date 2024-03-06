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

lasso_best_fe <- lasso_fit_fe |> 
 collect_metrics()

lasso_best_ks <- lasso_fit_ks |> 
  show_best("rmse") |> 
  slice_min(mean) 

### 
carseat_metrics <- bind_rows(
  knn_metrics %>% mutate(model = "Nearest Neighbors"),
  rf_metrics %>% mutate(model = "Random Forest"),
  bt_metrics %>% mutate(model = "Boosted Tree")
)

### 
rmse_table <- house_metrics |>
  rename(metric = .metric) |>
  rename("SE" = std_err) |>
  rename(RMSE = mean) |>
  rename("Model" = model) |>
  rename("Computations" = n) |>
  select("Model", RMSE, "SE", "Computations") |> 
  knitr::kable(digits = c(NA, 2, 3, 0))



save(house_metrics,
     rmse_table,
     file="results/rmse_table.rda")