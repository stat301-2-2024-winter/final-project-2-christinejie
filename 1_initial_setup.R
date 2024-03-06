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

save(house_train, house_test, file = "results/house_split.rda")


## folds
house_folds <- vfold_cv(house_train,
                        v = 10,
                        repeats = 5,
                        strata = price_log10)

save(house_folds,
     file = "results/house_folds.rda")
# 
summary <-skimr::skim_without_charts(house)

# log transform price 
house_train |> 
  ggplot(aes(x=price_log10)) + 
  geom_histogram(bins=100) 


#step log bedrooms 
house_train |> 
  ggplot(aes(x=log(num_of_bedrooms))) + 
  geom_histogram(bins=8) 

house_train |> 
  ggplot(aes(x=num_of_bedrooms)) + 
  geom_histogram(bins=8) 


#step log sq ft 
house_train |> 
  ggplot(aes(x=living_area_sq_ft)) + 
  geom_histogram(bins=20) 

house_train |> 
  ggplot(aes(x=log(living_area_sq_ft))) + 
  geom_histogram(bins=20) 

#step log lot_size_sq_ft

house_train |> 
  ggplot(aes(x=lot_size_sq_ft)) + 
  geom_histogram(bins=30) 

house_train |> 
  ggplot(aes(x=log(lot_size_sq_ft))) + 
  geom_histogram(bins=30) 


# yr built 

house_train |> 
  ggplot(aes(x=year_built)) + 
  geom_histogram(bins=30) 

house_train |> 
  ggplot(aes(x=log(year_built))) + 
  geom_histogram(bins=30) 

house_train |> 
  ggplot(aes(x=log(latest_price),y=log(year_built))) +
  geom_jitter()

#schools
house_train |> 
  ggplot(aes(x=(num_of_primary_schools),y=(num_of_elementary_schools))) +
  geom_jitter()


#step interact 
house_train |> 
  ggplot(aes(x=median_students_per_teacher,y=avg_school_rating)) +
  geom_jitter()


house_train |> 
  ggplot(aes(x=num_of_bathrooms,y=num_of_bedrooms)) +
  geom_jitter()

corr<-house_train |> 
  select(where(is.numeric)) |> 
  cor()

ggcorrplot::ggcorrplot(corr)



