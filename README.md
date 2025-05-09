# Curation of Fermentation dataset
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
1. `data_wrangling.ipnyb` - this is the main notebook used for data curation.
2. `data_visualization.ipynb` - a notebook used to create several figures based on the data. Static files from the notebook were saved to the images folder.
3. `food_taxonomy.ipynb` - a short notebook used to get the original food taxonomy columns. The majority of the work on the table was done manaully in a google spreadsheet
4. `drep_prep.ipynb` - a short notebook used to create an input table for dRep (more on this step bellow)


### data tables
The folder contains the main tables used for the curation as well as the curated metadata tables. <br>
The latest version of the metadata table (as of 05/06/2025) is `Food_MAGs_curated_metadata_250502.csv`.
Previous versions are also available. All start with the same name and dated by their time of saving. <br>
Other important tables:
* `food_taxonomy.csv` non-redundant rows of the food taxonomy.
>> * there are also notes on the creation of the food taxonomy table in `Food taxonomy notes.md`
* `Cdb95.csv`, `Cbd99.csv`, `Wdb95.csv`, `Wdb99.csv` - dRep outputs used to add the representative genome columns.
>> * Cbd tables indicate which cluster a MAG belongs to.
>> * Wdb identifies the representative genome in each cluster
>> * 95/99 indicates the clustering level. 95 is species and 99 is strain.
* `taxa_table.csv`, `gtdbtk*` tables - the taxonomy tables. The gtdbtk tables were used to create the taxa_table.
>> * taxonomy was only reassigned for Bacteria/Archaea. For Eukaryotes we used the available taxonomy with a few corrections (noted in the data_wrangling notebook)


A subfolder - `data_source/` -  contains the original metadata table (`2025-03-24-all-ff-mag-metadata-cleaned-curated.tsv`), as well as intermediate tables and other supplementary information used to curate the metadata table.


**Parts of the data curation were done manually. This is reflected in notes within the data wrangling notebook.**


## Food taxonomy
For food taxonomy we wanted to organize the information in an hierarchical format. This is challenging since food is not monophyletic. <br>
The categories we decided on are: substrate origin -> ingredient group -> main ingredient -> food name. <br>
An example of that would be: Animal -> Dairy -> Milk -> Cheddar cheese <br>
We also included additional parameters to add more information about the different food items. <br>
These include:
* What is the consistency of the item - is it a paste, liquid, solid?
* What are the main fermentation outputs -  acids, alcohol, etc.
* What is the main acid produced and at what level.
* What is the level of alcohol (if any)
* What is the level of proteolysis/lipolysis in the product - fermentation makes food more digestible by degrading complex compounds into simple ones.
* Are there additional ingredients in the food - salt, enzymes, etc.
* Is fermentation mesophilic or thermophilic
* Is there additional aging time and at what temperature. In many food items fermentation is split into short (primary) fermentation, and secondary long fermentation. <br>
Notes on the process can be found in data/Food taxonomy notes.md <br>
**Work on the food taxonomy table was done manually**

## Analysis done as part of the curation
### dereplication of MAGs with dRep
We chose [dRep v3.6.2](https://drep.readthedocs.io/en/latest/index.html) to identify the representative genome at the species and strain level. dRep does clustering based on gANI. For species level we set the threshold to 95% ANI and for strains we set the threshold at 99% ANI. <br>
The command we used is:<br>
`dRep dereplicate drep95_out -g genomes/*.fa -comp 50 -con 55 --genomeInfo genome_info.csv -sa 0.95 -p 12`<br
The --genomInfo flag was used with the completeness and contamination data we had available in the metadata file (skipping the need to run CheckM).<br>


### taxonomic assignment for Bacteria/Archaea with gtdb-tk
Taxonomy was accessed with [gtdb-tk v2.4.1](https://ecogenomics.github.io/GTDBTk/#). The non-redundant set of species level representatives was used as input.
The command we used is:<br>
`gtdbtk classify_wf --genome_dir ../drep/drep95_out/dereplicated_genomes --out_dir gtdb_out/ --cpus 14 --skip_ani_screen -x fa`<br>


Since the program only works for the Bacteria and Archaea domains, Eukaryote taxonomy was based on available data in the metadata table. We did make a few changes (all annotated in the data_wrangling notebook).
