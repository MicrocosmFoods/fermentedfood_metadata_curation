# Curration of Fermentation dataset 
In this repository, we curated the metadata associated with the MAGs of the fermentedfood_mags_curation repository. <br>
The goals of the curation were to:
1. Find and associate each MAG with it's source raw data - NCBI accesion numbers
2. Properly cite the original papers that generated the data.
3. Re-organize the columns for food taxonomy and process information.
4. Identify representative genomes at the species and strain level.
5. Assign standardized taxonomy to the MAGs.

## The main items in the repository are:
### Notebooks
There are three notebooks in the repository. 
1. 

* data/Food_MAGs_curated_metadata_250421_corrected.csv - the updated and curated metadata table
* data/Food_MAGs_curated_metadata_250421_corrected_merged_final.csv - full metadata including food taxonomy
* data_wrangling.ipynb - the notebook used to clean and update the metadata.
* Files used for the curation of the table and intermediate files are located in data/data_sources.
* food_taxonomy.ipynb - a notebook used for the initial splicing and redundancy removal for the dataset columns about food taxonomy
* data/food_taxonomy.csv - the table in which we developed and curated the new columns about food taxonomy and processing parameters. 

Parts of the data curation were done manually. This is reflected in notes within the data wrangling notebook. 

## Food taxonomy
For food taxonomy we wanted to organize the inforamtion in an hierarchal format. This is challenging since food is not monophyletic. <br>
The categories we decided on are: substrate origin -> ingredient group -> main ingredient -> food name. <br>
An example of that would be: Animal -> Dairy -> Milk -> Cheddar cheese <br>
We also included additional parameters to add more information about the different food items. <br>
These inlclude:
* What is the consistency of the item - is it a paste, liquid, solid?
* What are the main fermentation outputs -  acids, alcohol, etc.
* What is the main acid produces and at what level.
* What is the level of alcohol (if any)
* What is the level of proteolysis/lipolysis in the product - fermentation makes food more digestible by degrading complex compounds in to simple ones. 
* Are there additional ingredients in the food - salt, enzymes, etc.
* Is fermentation mesophilic or thermophilic
* Is there additional aging time and at what temperature. In many food items ferementation is split into short (primary) fermentation, and secondary long fermentation. <br>
Notes on the process can be found in data/Food taxonomy notes.md <br>
**Work on the food taxonomy table was done manually**


