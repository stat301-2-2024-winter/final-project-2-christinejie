load(here::here("results/house.rda"))
load(here::here("results/house_split.rda"))
load(here::here("results/house_folds.rda"))
load(here::here("results/house_recipe.rda"))
load(here::here("results/null.rda"))
load(here::here("results/lm.rda"))
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


house_metrics <- bind_rows(rmse_lm %>% mutate(model = "Linear"),
                           rmse_null %>% mutate(model = "Baseline"))


rmse_table <- house_metrics |>
  rename(metric = .metric) |>
  rename("SE" = std_err) |>
  rename(RMSE = mean) |>
  rename("Model" = model) |>
  rename("Computations" = n) |>
  select("Model", RMSE, "SE", "Computations") |> 
  kbl(digits = c(NA, 2, 3, 0))



save(house_metrics,
     rmse_table,
     file="results/rmse_table.rda")