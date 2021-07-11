# penguin-prediction-tool

This tool uses classifcation algorithms to predict penguin species (Adelie, Chinstrap, Gentoo) based on bill length (mm) and bill (mm) depth. Models include multinomial regression, k-nearest neighbors, random forest, xgboost (default hyperparameters settings were used). Accuracy of prediction for the four models on the test set were as follows:

<img width="492" alt="image" src="https://user-images.githubusercontent.com/45637747/125153890-b5727880-e10b-11eb-8baa-31c59ae57727.png">

The script utilizes the argparser package in R for parsing command-line arguments. The following examples show the incantation for running the Rscript with the following arguments: model, bill length and bill depth. 

Ex 1: Rscript penguin_sh_tool.R model=mn_mod_fit bill_length=39 bill_depth=18         <br>
Ex 2: Rscript penguin_sh_tool.R knn_mod_fit 50 18                                    <br>
Ex 3: Rscript penguin_sh_tool.R rf_mod_fit 50 18                                      <br>
Ex 4. Rscript penguin_sh_tool.R xg_mod_fit 50 14                                     <br>

The output of Ex 3 should include the following messages:

<img width="685" alt="image" src="https://user-images.githubusercontent.com/45637747/125180220-6deff900-e1ac-11eb-80b3-d2c67b82295e.png">

<img width="685" alt="image" src="https://user-images.githubusercontent.com/45637747/125153826-3d0bb780-e10b-11eb-83eb-92625e231ac0.png">

And return the predicted species based on the model and inputs.

<img width="240" alt="image" src="https://user-images.githubusercontent.com/45637747/125153850-704e4680-e10b-11eb-9933-ea8a855c5365.png">


