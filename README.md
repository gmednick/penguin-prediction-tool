# penguin-prediction-tool

This tool uses classifcation algorithms to predict penguin species (Adelie, Chinstrap, Gentoo) based on bill length (mm) and bill (mm) depth. Models include multinomial regression, k-nearest neighbors, random forest, xgboost (default hyperparameters settings were used). The script utilizes the argparser package in R for parsing command-line arguments. The following examples show the incantation for running the Rscript with the following arguments: model, bill length and bill depth. 

Ex 1: Rscript penguin_sh_tool.R model=mn_mod_fit bill_length=39 bill_depth=18        output: Adelie <br>
Ex 2: Rscript penguin_sh_tool.R knn_mod_fit 50 18                                    output: Chinstrap <br>
Ex 3: Rscript penguin_sh_tool.R rf_mod_fit 50 18                                     output: Chinstrap <br>
Ex 4. Rscript penguin_sh_tool.R xg_mod_fit 50 14                                     output: Gentoo <br>

The output tells you what model was used and returns the prediction.

<img width="298" alt="image" src="https://user-images.githubusercontent.com/45637747/125153572-8a872500-e109-11eb-986d-5e055d8257e7.png">

