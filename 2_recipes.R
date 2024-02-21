load(here::here("results/house.rda"))
load(here::here("results/house_split.rda"))
load(here::here("results/house_folds.rda"))
load(here::here("results/house_recipe.rda"))
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

#recipe
house_recipe <- recipe(price_log10 ~ ., data = house_train) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_normalize(all_predictors()) |>
  step_zv(all_predictors()) 
  
save(house_recipe,
     file="results/house_recipe.rda")

prep(house_recipe) |> 
  bake(new_data = NULL) |> 
  view()