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

#recipe standard 
house_recipe_standard <- recipe(price_log10 ~ ., data = house_train) |>
  step_rm(latest_price) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_interact(terms = ~ median_students_per_teacher:avg_school_rating) |>
  step_interact(terms = ~ num_of_bathrooms:num_of_bedrooms) |>
  step_interact(terms =  ~ num_of_stories:living_area_sq_ft) |> 
  step_interact(terms =  ~ parking_spaces:garage_spaces) |> 
  step_zv(all_predictors()) |>
  step_normalize(all_predictors()) 
  


prep_rec_standard<- prep(house_recipe_standard) |> 
  bake(new_data = house_train) 

# recipe tree? maybe not
house_recipe_tree <- recipe(price_log10 ~ ., data = house_train) |>
  step_rm(latest_price) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_normalize(all_predictors()) 

prep_rec_tree<- prep(house_recipe_tree) |> 
  bake(new_data = house_train) 


save(house_recipe_standard,
     prep_rec_standard,
     house_recipe_tree,
     prep_rec_tree,
     file="results/house_recipe.rda")

