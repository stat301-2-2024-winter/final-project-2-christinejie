load(here::here("results/rf_tuned_fe.rda"))
load(here::here("results/rf_tuned_ks.rda"))
load(here::here("initial_processing/house_split.rda"))
load(here::here("initial_processing/house_folds.rda"))
load(here::here("initial_processing/house_recipe.rda"))
load(here::here("results/final_fit.rda"))
library(dplyr)
library(tidyverse)
library(rsample)
library(tidymodels)
library(kableExtra)
library(here)
tidymodels_prefer()
set.seed(123)
library(doMC)
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)


###
house_metrics_final <- metric_set(rmse, rsq, mae)


###
house_predict_rf_not_log <- house_test |>
  mutate(price = 10 ^ price_log10) |>
  select(price) |>
  bind_cols(10 ^ predict(final_fit, house_test))

house_final_metrics_not_log <-
  house_metrics_final(house_predict_rf_not_log, price, .pred) %>%
  select(.metric, .estimate) |>
  kbl(digits = 3) %>%  # Set the number of digits for each column
  kable_styling()

house_predict_rf_log <- house_test |>
  select(price_log10) |>
  bind_cols(predict(final_fit, house_test))

house_final_metrics_log <-
  house_metrics_final(house_predict_rf_log, price_log10, .pred) %>%
  select(.metric, .estimate) |>
  kbl(digits = 3) %>%  # Set the number of digits for each column
  kable_styling()

## graph of predicted vs actual 
ggplot(house_predict_rf_not_log, aes(x = price, y = .pred)) +
  geom_jitter(alpha = 0.5) +
  geom_abline(lty = 2) +
  labs(y = "Predicted Price", x = "Actual Price",
       title = "Predicted Price vs Actual Price") +
  scale_x_continuous(labels = function(x) paste0("$", scales::comma(x))) +
  scale_y_continuous(labels = function(y) paste0("$", scales::comma(y))) +
  theme(plot.title = element_text(size = 24, face = "bold"))
ggsave("plots/plot_1.png")


ggplot(house_predict_rf_not_log, aes(x = price, y = .pred)) +
  geom_jitter(alpha = 0.5) +
  geom_abline(lty = 2) +
  labs(y = "Predicted Price", x = "Actual Price",
       title = "Predicted Price vs Actual Price, \nfor Prices Less than $1.25M") +
  coord_cartesian(xlim = c(NA, 1250000))  +
  scale_x_continuous(labels = function(x) paste0("$", scales::comma(x))) +
  scale_y_continuous(labels = function(y) paste0("$", scales::comma(y))) +
  theme(plot.title = element_text(size = 24, face = "bold"))
ggsave("plots/plot_2.png")

ggplot(house_predict_rf_not_log, aes(x = price, y = .pred)) +
  geom_jitter(alpha = 0.5) +
  geom_abline(lty = 2) +
  labs(y = "Predicted Price", x = "Actual Price",
       title = "Predicted Price vs Actual Price, \nfor Prices Greater than $1.25M") +
  coord_cartesian(xlim = c(1250000, NA))  +
  scale_x_continuous(labels = function(x) paste0("$", scales::comma(x))) +
  scale_y_continuous(labels = function(y) paste0("$", scales::comma(y))) +
  theme(plot.title = element_text(size = 24, face = "bold"))  # Change font size to 16
ggsave("plots/plot_3.png")








save(house_metrics_final,
     house_predict_rf_not_log,
     house_final_metrics_not_log,
     house_predict_rf_log,
     house_final_metrics_log,
     file="results/final_results.rda")



