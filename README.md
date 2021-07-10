# penguin-prediction-tool

This tool uses a classifcation model to predict penguin species (Adelie, Chinstrap, Gentoo) based on bill length (mm) and bill (mm) depth. 
It uses argparser to imput the arguments into the Rscript from the command line. 

Example 1: Rscript penguin_sh_tool.R mn_mod_fit 39 18 output: Adelie
Example 2: Rscript penguin_sh_tool.R knn_mod_fit 50 18 output: Chinstrap
Example 3: Rscript penguin_sh_tool.R rf_mod_fit 50 18 output: Chinstrap
