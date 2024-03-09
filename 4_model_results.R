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
load(here::here("results/en_tuned_fe.rda"))
load(here::here("results/en_tuned_ks.rda"))
load(here::here("results/model_results.rda"))
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


# new
model_results <- as_workflow_set(
  BT_FE = bt_tuned_fe,
  BT_KS = bt_tuned_ks,
  KNN_FE = knn_fit_fe,
  KNN_KS = knn_fit_ks,
  linear_FE = lm_fit_fe,
  linear_KS = lm_fit_ks,
  rf_FE = rf_tuned_fe,
  rf_ks = rf_tuned_ks,
  en_FE = en_tuned_fe,
  en_KS = en_tuned_ks,
  baseline_FE = null_fit_fe,
  baseline_KS = null_fit_ks
)
  
  

rmse_chart <- model_results |>
  collect_metrics() |>
  filter(.metric == "rmse") |>
  slice_min(mean, by = wflow_id) |>
  arrange(mean) |>
  select(
    "Model Type" = wflow_id,
    "RMSE" = mean,
    "Std Error" = std_err,
  )  |> 
  kbl() |> 
  kable_styling()


library(knitr)

library(knitr)

rmse_chart <- model_results %>%
  collect_metrics() %>%
  filter(.metric == "rmse") %>%
  slice_min(mean, by = wflow_id) %>%
  arrange(mean) %>%
  select(
    `Model Type` = wflow_id,
    RMSE = mean,
    `Std Error` = std_err
  ) %>%
  kbl(digits = c(0, 3, 4)) %>%  # Set the number of digits for each column
  kable_styling()







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
  kbl(digits = c(0, 3, 4)) %>%  # Set the number of digits for each column
  kable_styling()
  
rmse_table <- house_metrics %>%
  filter(.metric == "rmse") |> 
  rename("Standard Error" = std_err) |>
  rename(RMSE = mean) |>
  rename("Model Type" = model) |>
  rename("Number Computations" = n) |>
  arrange(RMSE) |> 
  select("Model Type", RMSE, "Standard Error") |>
  knitr::kable(
    digits = c(NA, 4, 4),
    align = c("l", "r", "r"),  # Align text columns to the left, numeric columns to the right
    caption = "<b>RMSE Metrics for Different Models</b>",  # Add a bold caption using HTML formatting
    format = "html",  # Use HTML formatting
    col.names = c("Model Type", "RMSE", "Standard Error"),  # Rename column names
    table.attr = "style='width:80%;margin-left:auto;margin-right:auto;'"  # Adjust table width and center align
  )

library(kableExtra)

library(kableExtra)

best_rf <- rf_tuned_fe |> 
  select_best() |> 
  select(mtry, min_n) |> 
  knitr::kable(caption = "<b>Best Parameters for RF Model</b>") %>%
  kableExtra::kable_styling(full_width = FALSE)

library(kableExtra)

### 




bt_best <- bt_tuned_fe |>
  select_best()

knn_best <- knn_fit_fe |>
  select_best()

rf_best <- rf_tuned_ks |>
  select_best()

en_best <- en_tuned_fe |> 
  select_best()


best_parameters <-
  bind_rows(
    bt_best |>  mutate (model = "Boosted Tree"),
    knn_best |>  mutate (model = "KNN"),
    rf_best |>  mutate (model = "Random Forest"),
    en_best |>  mutate(model = "Elastic Net")
  ) |>
  select(model,
         mtry,
         min_n,
         learn_rate,
         neighbors,
         penalty,
         mixture) %>%
  kbl(digits = c(NA, 2, 2, 3, 2, 3, 2)) %>%  # Set the number of digits for each column
  kable_styling()




rmse_table


save(house_metrics,
     rmse_table,
     rmse_chart,
     best_rf,
     best_parameters,
     file="results/model_results.rda")