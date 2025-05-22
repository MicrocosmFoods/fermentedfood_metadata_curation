library(tidyverse)
library(hunspell)

# read in most up-to-date genome metadata
genome_metadata <- read_csv("data/intermediate_metadata_files/Food_MAGs_curated_metadata_250502.csv") %>%
  select(mag_id, sample_description, completeness, contamination, contigs, total_length, gc, n50, sample_accession, run_accession, country, project_accession, study_accession, database_origin, Reference, food_name) %>% 
  mutate(sample_description = gsub(" ", "_", sample_description)) %>% 
  mutate(sample_description = gsub("[()]", "", sample_description)) %>% 
  mutate(sample_description = gsub(",", "", sample_description)) %>% 
  mutate(sample_description = gsub("__", "", sample_description)) %>% 
  mutate(sample_description = gsub("-", "", sample_description)) %>% 
  mutate(sample_description = gsub("'", "", sample_description)) %>% 
  mutate(sample_description = gsub("dawa_dawa", "dawadawa", sample_description)) %>% 
  mutate(sample_description = gsub("#", "", sample_description)) %>% 
  mutate(sample_description = gsub("cinsoy_s21v1", "cinsoy_s21_v1", sample_description)) %>% 
  mutate(sample_description = gsub("(?<=\\d)([hd])\\b", "_\\1", sample_description, perl = TRUE)) %>% 
  mutate(sample_description = gsub("lemon_and_ginger_gizz", "lemon_and_ginger_fizz", sample_description)) %>% 
  mutate(sample_description = gsub("brukina", "brukina_millet_with_fermented_milk", sample_description)) %>% 
  mutate(sample_description = gsub("queens_sf_lacto_ferm_4%_yellow_peach_8/26/21", "queens_sf_lacto_ferm_4_yellow_peach_82621", sample_description)) %>% 
  mutate(sample_description = gsub("traditional_yogurt", "yogurt", sample_description)) %>% 
  mutate(sample_description = gsub("commercial_grape_wine_undergoing_a_sluggish/stuck_alcoholic_fermentation", "commercial_grape_wine_undergoing_a_sluggishstuck_alcoholic_fermentation", sample_description)) %>% 
  mutate(sample_description = gsub("fermentedbrine_used_for_stinky_tofu_production", "fermented_brine_used_for_stinky_tofu_production", sample_description)) %>% 
  mutate(food_name = gsub("liquir chinese", "liquor chinese", food_name)) %>%
  mutate(food_name = gsub("doenjang", "dajiang_meju", food_name)) %>% 
  mutate(food_name = gsub("pickle serrano peper", "pickle serrano pepper", food_name)) %>% 
  mutate(food_name = gsub("pickle peper", "pickle pepper", food_name)) %>% 
  mutate(sample_description_extended = paste0(sample_description, "_", gsub(" ", "_", food_name))) %>% 
  mutate(sample_description_extended = gsub("-", "_", sample_description_extended))


# read in most up-to-date food taxonomy
food_taxonomy <- read_csv("data/food_taxonomy/Metadata_CS_20250519_EAM_modified.csv.csv") %>% 
  distinct() %>% 
  mutate(sample_description_extended = paste0(`Sample Name`, "_", gsub(" ", "_", `Food Name`)))  %>% 
  mutate(sample_description_extended = gsub("-", "_", sample_description_extended))

# join genome metadata with food taxonomy
genome_food_metadata <- left_join(genome_metadata, food_taxonomy, by = "sample_description_extended") %>% 
  filter(!is.na(`Sample Name`)) %>% 
  select(mag_id, completeness, contamination, contigs, total_length, gc, n50, sample_accession, run_accession, country, project_accession, study_accession, database_origin, Reference, `Food Name`, `Sample Name`, `Origin`, `Ingredient Group`, `Main Ingredient`, `Food Type`, `Consistency`, `Alcohol Level`, `Acid Type`, `Fermentation Temp`, `Aging Time`)
