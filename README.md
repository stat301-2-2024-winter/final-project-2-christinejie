## Overview
The goal of this final project is to predict house prices in Austin, TX, using predictor variables such as number of bedrooms and square feet. I used 6 models for this prediction problem. 

## RDA Files 
-`results/bt_tuned_fe.rda` : contains the tuned bt model with the feature engineered recipe 
-`results/bt_tuned_ks.rda` : contains the tuned bt model with the kitchen sink recipe 
-`results/en_tuned_fe.rda` : contains the tuned en model with the feature engineered recipe 
-`results/en_tuned_ks.rda` : contains the tuned en model with the kitchen sink recipe 
-`results/en_tuned_ks.rda` : contains the final tuned rf model to the entire training data set 
-`results/knn_tuned_fe.rda` : contains the tuned knn model with the feature engineered recipe 
-`results/knn_tuned_ks.rda` : contains the tuned knn model with the kitchen sink recipe 
-`results/model_results.rda` : contains overall results for all models 
-`results/null_fit_fe.rda` : contains the baseline model with the feature engineered recipe 
-`results/null_fit_ks.rda` : contains the baseline model with the kitchen sink recipe 
-`results/rf_tuned_fe.rda` : contains the tuned rf model with the feature engineered recipe 
-`results/rf_tuned_ks.rda` : contains the tuned rf model with the kitchen sink recipe 
-`results/rmse_table.rda` : contains the table of all rmse values 
-`initial_processing/house_folds.rda`: contains house_folds, which is the folded training data set 
-`initial_processing/house_recipe.rda`: contains 4 recipes 
-`initial_processing/house_split.rda`: contains the testing and training data sets 
-`initial_processing/house.rda`: contains the entire house data set

## R files 
-`1_initial_setup.R`: splitting, folding data, initial RDA 
-`2_recipes.R`: build 4 recipes, prep and bake each recipe 
-`3_bt_fe.R`: build bt model, bt workflow, tune bt model, fit tuned bt model with fe recipe. 
-`3_bt_ks.R`: build bt model, bt workflow, tune bt model, fit tuned bt model with ks recipe. 
-`3_en_fe.R`: build en model, en workflow, tune en model, fit tuned en model with fe recipe. 
-`3_en_ks.R`: build en model, en workflow, tune en model, fit tuned en model with ks recipe. 
-`3_knn_fe.R`: build knn model, knn workflow, tune knn model, fit tuned knn model with fe recipe. 
-`3_knn_ks.R`: build knn model, knn workflow, tune knn model, fit tuned knn model with ks recipe. 
-`3_OLS.R`: build OLS model, OLS workflow, fit tuned OLS model with ks and fe recipe. 
-`3_rf_fe.R`: build rf model, rf  workflow, tune rf  model, fit tuned rf  model with fe recipe. 
-`3_rf_ks.R`: build rf  model, rf  workflow, tune rf  model, fit tuned rf  model with ks recipe. 
-`4_model_results.R`: select best parameters for each model, build table showing rmse and standard error for best parameters for each model
-`5_train_final.R`: train best model to entire training set
-`6_train_final.R`: find RMSE, MAE, RSQ for best model, plot predicted vs observed observations 

