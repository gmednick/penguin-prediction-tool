#!/usr/bin/env Rscript
library(argparser)
library(tidyverse)
library(palmerpenguins)
library(gt)
theme_set(theme_light())

# The argparser package let's you add functions for parsing command-line arguments
# Ex 1: Rscript penguin_sh_tool.R mn_mod_fit 39 18       output: Adelie
# Ex 2: Rscript penguin_sh_tool.R knn_mod_fit 50 18      output: Chinstrap
# Ex 3: Rscript penguin_sh_tool.R rf_mod_fit 50 18       output: Chinstrap
# Ex 4: Rscript penguin_sh_tool.R xg_mod_fit 50 14       output: Gentoo

p <- arg_parser("choose two inputs (bill length and bill depth) to predict species type (Adelie, Chinstrap, Gentoo) from the command line")

p <- add_argument(p, "model",
                  help = "select a model ('mn_mod_fit', 'knn_mod_fit', 'rf_mod_fit')")

p <- add_argument(p, "bill_length",
                  type = "double",
                  help = "should be in mm")

p <- add_argument(p, "bill_depth",
                  type = "double",
                  help = "should be in mm")

argv <- parse_args(p)

palmer_df <- read_csv(path_to_file("penguins.csv"))

library(tidymodels)
set.seed(777)

spl <- palmer_df %>% initial_split(prop = .8, strata = species)

palmer_train <- training(spl)

palmer_test <- testing(spl)

cv_resamples <- palmer_train %>% vfold_cv()

# feature engineering

recipe <- recipe(species ~ bill_length_mm + bill_depth_mm, data = palmer_train) %>%
  step_impute_median(all_predictors()) %>%
  step_normalize(all_predictors())

test = tibble(bill_length_mm = argv$bill_length, bill_depth_mm = argv$bill_depth) %>%
  mutate_if(is.character, as.numeric)

# function for choosing a model with argparser in the command line
mod_select = function(mod) {

  print(paste0("The model is ", argv$mod))
  print(paste0("The bill length and bill depth are ", argv$bill_length, " and ", argv$bill_depth, " millimeters respectively"))

  mn_mod <- multinom_reg() %>%
    set_mode("classification") %>%
    set_engine('nnet')

  mn_workflow <- workflow() %>%
    add_recipe(recipe) %>%
    add_model(mn_mod)

  mn_mod_fit <- mn_workflow %>%
    fit(data = palmer_train)

 # Random Forest model
  rf_mod <- rand_forest() %>%
    set_mode("classification") %>%
    set_engine("ranger")

  rf_workflow <- workflow() %>%
    add_recipe(recipe) %>%
    add_model(rf_mod)

  rf_mod_fit <- rf_workflow %>%
    fit(data = palmer_train)


 # knn model
  knn_mod <- nearest_neighbor() %>%
    set_mode("classification") %>%
    set_engine("kknn")

  knn_workflow <- workflow() %>%
    add_recipe(recipe) %>%
    add_model(knn_mod)

  knn_mod_fit <- knn_workflow %>%
    fit(data = palmer_train)

  # xgboost model
  xg_mod <- boost_tree() %>%
    set_mode("classification") %>%
    set_engine("xgboost")

    xg_workflow <- workflow() %>%
    add_recipe(recipe) %>%
    add_model(xg_mod)

    xg_mod_fit <- xg_workflow %>%
    fit(data = palmer_train)

}

# test = tibble(bill_length_mm = 39, bill_depth_mm = 18)
# mod = rf_mod_fit # Model options: 'mn_mod_fit', 'knn_mod_fit', 'rf_mod_fit', 'xg_mod_fit'

mod = argv$mod

mod_select(mod) %>%
  predict(new_data = test,
          type = 'class')


