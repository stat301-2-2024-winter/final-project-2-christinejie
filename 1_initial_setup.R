# load packages ----
library(tidyverse)
library(rsample)
library(parsnip)
library(tidymodels)
library(glmnet)
library(ranger)
library(kknn)
library(kableExtra)
set.seed(123)

# handle common conflicts
tidymodels_prefer()

#loading in data and cleaning
house <- read_csv("data/austinHousingData.csv") |>
  janitor::clean_names() |>
  mutate(
    has_association = factor(has_association),
    has_cooling = factor(has_cooling),
    has_garage = factor(has_garage),
    has_heating = factor(has_heating),
    has_spa = factor(has_spa),
    has_view = factor(has_view),
    home_type = factor(home_type),
    city = factor(city),
    zipcode = factor(zipcode),
    price_log10 = log10(latest_price)
  ) |>
  select(
    -c(
      description,
      home_image,
      latest_saledate,
      street_address,
      latest_price_source,
      zpid
    )
  )

save(house,
     file = "results/house.rda")


## split data
house_split <- house |>
  initial_split(prop = 0.75,
                strata = price_log10,
                breaks = 4)


house_train <- training(house_split)
house_test <- testing(house_split)

save(house, house_train, house_test, file = "initial_processing/house_split.rda")

load(here::here("initial_processing/house_split.rda"))

## folds
house_folds <- vfold_cv(house_train,
                        v = 10,
                        repeats = 5,
                        strata = price_log10)

save(house_folds,
     file = "results/house_folds.rda")

# summary of all variables 
summary <-skimr::skim_without_charts(house_train)

# price with no transformations
price_not_log <- house_train |> 
  ggplot(aes(x=latest_price)) + 
  geom_histogram(bins=50) 


# log transform price 
price_log<-house_train |> 
  ggplot(aes(x=price_log10)) + 
  geom_histogram(bins=50) 


save(summary,
     price_not_log,
     price_log,
     file=here::here("initial_processing/price"))


#step interact 
house_train |>
  ggplot(aes(x = num_of_bathrooms, y = num_of_bedrooms)) +
  geom_point() +
  geom_abline(lty = 2) +
  labs(x = "Number of Bathrooms", y = "Number of Bedrooms", 
       title = "Number of Bedrooms vs Number of Bathrooms") + 
  theme(plot.title = element_text(size = 24, face = "bold")) 
ggsave("plots/plot_5.png")


## corr plot
corr<-house_train |> 
  select(where(is.numeric)) |> 
  cor()

ggcorrplot::ggcorrplot(corr)
ggsave("plots/plot_4.png")


