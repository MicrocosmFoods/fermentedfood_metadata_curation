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
  mutate(food_name = gsub("liquir chinese", "liquor chinese", food_name)) %>% 
  mutate(sample_description_extended = paste0(sample_description, "_", gsub(" ", "_", food_name)))


# read in most up-to-date food taxonomy
food_taxonomy <- read_csv("data/food_taxonomy/Metadata_CS_20250519.csv") %>% 
  distinct() %>% 
  mutate(sample_description_extended = paste0(`Sample Name`, "_", gsub(" ", "_", `Food Name`))) 

# join genome metadata with food taxonomy
genome_food_metadata <- left_join(genome_metadata, food_taxonomy, by = "sample_description_extended")

genome_food_metadata %>% 
  filter(is.na(`Sample Name`)) %>% 
  group_by(sample_description) %>% 
  count() %>% 
  arrange(desc(n))
