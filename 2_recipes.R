load(here::here("initial_processing/house.rda"))
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
library(recipes)
set.seed(123)
library(here)
tidymodels_prefer()

library(doMC)
num_cores <- parallel::detectCores(logical=TRUE)
registerDoMC(cores=num_cores)

#kitchen sink standard 
linear_ks <- recipe(price_log10 ~ ., data = house_train) |>
  step_rm(latest_price) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_normalize(all_predictors()) 

prep_rec_lin_ks<- prep(linear_ks) |> 
  bake(new_data = NULL) 

prep_rec_lin_ks


#feature engineered standard 

lin_fe <- recipe(price_log10 ~ ., data = house_train) |>
  step_rm(latest_price,
          year_built,
          num_price_changes,
          num_of_accessibility_features,
          num_of_community_features,
          city,
          zipcode,
          home_type) |> 
  step_interact(terms = ~ num_of_bathrooms:num_of_bedrooms) |> 
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |> 
  step_normalize()


prep_rec_lin_fe<- prep(linear_fe) |> 
  bake(new_data = NULL) 


# kitchen sink tree 
tree_ks <- recipe(price_log10 ~ ., data = house_train) |>
  step_rm(latest_price) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) 

prep_rec_tree_ks<- prep(tree_ks) |> 
  bake(new_data = NULL) 

prep_rec_tree_ks

#featured engineering tree 
tree_fe <- recipe(price_log10 ~ ., data = house_train) |>
  #impute here too 
  step_rm(latest_price,
          year_built,
          num_price_changes,
          num_of_accessibility_features,
          num_of_community_features) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_nzv(all_predictors()) 

prep_rec_tree_ks<- prep(tree_ks) |> 
  bake(new_data = NULL) 

prep_rec_tree_ks

save(lin_ks,
     lin_fe,
     tree_ks,
     tree_fe,
     file="results/house_recipe.rda")

