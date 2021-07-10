#!/usr/bin/env Rscript
library(argparser)
library(tidyverse)
library(palmerpenguins)
library(gt)
theme_set(theme_light())

p <- arg_parser("choose two inputs (bill length and bill depth) to predict species type (Adelie, Chinstrap, Gentoo) from the command line")

p <- add_argument(p, "bill_length",
                  type = "double",
                  help = "should be in mm")

p <- add_argument(p, "bill_depth",
                  type = "double",
                  help = "should be in mm")

p <- add_argument(p, "--model",
                  help = "select a model ('mn_mod_fit', 'knn_mod_fit', 'rf_mod_fit')")

argv <- parse_args(p)

palmer_df <- read_csv(path_to_file("penguins.csv"))

library(tidymodels)
set.seed(777)

spl <- palmer_df %>% initial_split(prop = .8, strata = species)

palmer_train <- training(spl)

palmer_test <- testing(spl)

cv_resamples <- palmer_train %>% vfold_cv()

# featrure engineering

recipe <- recipe(species ~ bill_length_mm + bill_depth_mm, data = palmer_train) %>%
  step_impute_median(all_predictors()) %>%
  step_normalize(all_predictors())

## Create models
mn_mod <- multinom_reg() %>%
  set_mode("classification") %>%
  set_engine('nnet')

rf_mod <- rand_forest() %>%
  set_mode("classification") %>%
  set_engine("ranger")

knn_mod <- nearest_neighbor() %>%
  set_mode("classification") %>%
  set_engine("kknn")

#### Multinomial regression model

mn_workflow <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(mn_mod)

mn_mod_fit <- mn_workflow %>%
  fit(data = palmer_train)

mn_mod_preds <- mn_mod_fit %>%
  predict(new_data = palmer_test,
          type = 'class')

mn_results <- palmer_test %>%
  select(species) %>%
  bind_cols(mn_mod_preds)

metrics <- metric_set(accuracy, sens, spec)

mn_results %>%
  mutate_if(is.character, as.factor) %>%
  mutate(model = 'multinom_reg') %>%
  metrics(truth = species,
          estimate = .pred_class)

#### Random Forest model

rf_workflow <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(rf_mod)

rf_mod_fit <- rf_workflow %>%
  fit(data = palmer_train)

rf_mod_preds <- rf_mod_fit %>%
  predict(new_data = palmer_test,
          type = 'class')

rf_results <- palmer_test %>%
  select(species) %>%
  bind_cols(rf_mod_preds)

rf_results %>%
  mutate_if(is.character, as.factor) %>%
  mutate(model = 'rf_mod') %>%
  metrics(truth = species,
          estimate = .pred_class)

#### knn model

knn_workflow <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(knn_mod)

knn_mod_fit <- knn_workflow %>%
  fit(data = palmer_train)

knn_mod_preds <- knn_mod_fit %>%
  predict(new_data = palmer_test,
          type = 'class')

knn_results <- palmer_test %>%
  select(species) %>%
  bind_cols(knn_mod_preds)

knn_results %>%
  mutate_if(is.character, as.factor) %>%
  mutate(model = 'knn_mod') %>%
  metrics(truth = species,
          estimate = .pred_class)

test = tibble(bill_length_mm = argv$bill_length, bill_depth_mm = argv$bill_depth) %>%
  mutate_if(is.character, as.numeric)

rf_mod_fit %>%
  predict(new_data = test,
          type = 'class')


