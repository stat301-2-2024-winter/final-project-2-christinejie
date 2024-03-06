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



house_metrics <- bind_rows(
  bt_best_fe %>% mutate(model = "BT FE"),
  bt_best_ks %>% mutate(model = "BT KS"),
  knn_best_fe %>% mutate(model = "KNN FE"),
  knn_best_ks  %>% mutate(model = "KNN KS"),
  lasso_best_fe |> mutate(model = "Lasso FE"),
  lasso_best_ks |>  mutate(model = "Lasso KS"),
  lm_best_fe |>  mutate(model = "Linear FE"),
  lm_best_ks |>  mutate(model = "Linear KS"),
  ridge_best_fe |> mutate(model = "Ridge FE"),
  ridge_best_ks |> mutate(model = "Ridge KS")
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
  



save(house_metrics,
     rmse_table,
     file="results/model_results.rda")