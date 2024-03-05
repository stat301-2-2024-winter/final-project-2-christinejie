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
#remove property tax bc it's the same for everything, remove long and lat 

linear_fe <- recipe(price_log10 ~ ., data = house_train) |>
  step_rm(latest_price, property_tax_rate, latitude, longitude) |>
  step_interact(terms = ~ median_students_per_teacher:avg_school_rating) |>
  step_interact(terms = ~ num_of_bathrooms:num_of_bedrooms) |>
  step_interact(terms =  ~ num_of_stories:living_area_sq_ft) |>
  step_interact(terms =  ~ parking_spaces:garage_spaces) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_normalize(all_predictors()) |>
  step_log(num_of_bedrooms, living_area_sq_ft, lot_size_sq_ft) 

  
  

prep_rec_lin_fe<- prep(linear_fe) |> 
  bake(new_data = NULL) 

prep_rec_lin_fe




# kitchen sink tree 
# Trees automatically detect non-linear relationships 
# so we don’t need the natural spline step (it has been removed). 
# Some of the other steps are not needed 
# (such as Log-transforms, centering, scaling), 
# but can be done since they will not meaningfully change anything. 
# The natural spline step performs a basis expansion, 
# which turns one column into 5 — 
# which is what causes the issue for the random forest algorithm.


tree_ks <- recipe(price_log10 ~ ., data = house_train) |>
  step_rm(latest_price) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) 

prep_rec_tree_ks<- prep(tree_ks) |> 
  bake(new_data = NULL) 

prep_rec_tree_ks

#featured engineering tree 

tree_fe <- recipe(price_log10 ~ ., data = house_train) |>
  step_rm(latest_price) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_log(num_of_bedrooms) |>
  step_log(living_area_sq_ft) |>
  step_log(lot_size_sq_ft)

prep_rec_tree_ks<- prep(tree_ks) |> 
  bake(new_data = NULL) 

prep_rec_tree_ks

save(linear_ks,
     linear_fe,
     tree_ks,
     tree_fe,
     file="results/house_recipe.rda")

