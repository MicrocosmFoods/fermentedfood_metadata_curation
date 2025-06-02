library(tidyverse)
library(ggalluvial)
library(RColorBrewer)
library(grid)

# read in most up-to-date genome metadata
genome_metadata <- read_csv("data/intermediate_metadata_files/Food_MAGs_curated_metadata_250502.csv") %>%
  select(mag_id, sample_description, completeness, contamination, contigs, total_length, gc, n50, sample_accession, run_accession, country, project_accession, study_accession, database_origin, Reference, food_name, representative_95id, representative_99id, domain, phylum, class, order, family, genus, species) %>% 
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
  mutate(sample_description_extended = gsub("-", "_", sample_description_extended)) %>% 
  mutate(country = gsub("Genrmany", "Germany", country)) %>% 
  mutate(country = gsub("Korean", "Korea", country)) %>% 
  mutate(country = gsub("hilippines", "Philippines", country)) %>% 
  mutate(country = gsub("Hong Kong", "China", country))


# read in most up-to-date food taxonomy
food_taxonomy <- read_csv("data/food_taxonomy/Metadata_CS_20250519_EAM_modified.csv") %>% 
  distinct() %>% 
  mutate(sample_description_extended = paste0(`Sample Name`, "_", gsub(" ", "_", `Food Name`)))  %>% 
  mutate(sample_description_extended = gsub("-", "_", sample_description_extended))

# join genome metadata with food taxonomy
genome_food_metadata <- left_join(genome_metadata, food_taxonomy, by = "sample_description_extended") %>% 
  filter(!is.na(`Sample Name`)) %>% 
  mutate(taxonomy = paste0(phylum, ";", class, ";", order, ";", family, ";", genus)) %>% 
  select(mag_id, completeness, contamination, contigs, total_length, gc, n50, sample_accession, run_accession, country, project_accession, study_accession, database_origin, Reference, representative_95id, representative_99id, taxonomy, species, `Food Name`, `Sample Name`, `Origin`, `Ingredient Group`, `Main Ingredient`, `Food Type`, `Consistency`, `Alcohol Level`, `Acid Type`, `Fermentation Temp`, `Aging Time`) %>% 
  distinct(mag_id, .keep_all = TRUE)

colnames(genome_food_metadata) <- c("mag_id", "completeness", "contamination", "contigs", "total_length", "gc", "n50", "sample_accession", "run_accession", "country", "project_accession", "study_accession", "database_origin", "reference", "rep_95id", "rep_99id", "taxonomy", "species", "food_name", "sample_name", "origin", "ingredient_group", "main_ingredient", "food_type", "consistency", "alcohol_level", "acid_type", "fermentation_temperature", "aging_time")

write_tsv(genome_food_metadata, "data/2025-05-21-genome-metadata-food-taxonomy.tsv")

# get list of SRA accessions to get runinfo from
run_accession_metadata <- genome_food_metadata %>%
  filter(startsWith(run_accession, "SRR") | startsWith(run_accession, "ERR")) %>%
  separate_rows(run_accession, sep = "[,;]") %>% 
  mutate(run_accession = trimws(run_accession)) %>% 
  select(run_accession, food_name, sample_name, origin, ingredient_group, main_ingredient, food_type) %>% 
  distinct(run_accession, .keep_all = TRUE)

run_accessions <- run_accession_metadata %>% 
  select(run_accession) %>% 
  distinct()

write_tsv(run_accessions, "data/source_tables_for_metadata/2025-05-21-sra-run-accessions-list.txt")

# SRA runinfo results
all_sraruninfos_files <- list.files(path="data/source_tables_for_metadata/sraruninfo", pattern = "-srainfo\\.tsv$", full.names = TRUE)

# read in headers to get all possible column names, then for files that don't have those column names add "NA"
headers <- lapply(all_sraruninfos_files, function(file) {
  names(read_tsv(file, n_max = 0))
})

all_cols <- unique(unlist(headers))

data_list <- lapply(all_sraruninfos_files, function(file) {
  df <- read_tsv(file, col_types = cols(.default = col_character()))
  
  # Add any missing columns as NA
  missing_cols <- setdiff(all_cols, names(df))
  df[missing_cols] <- NA
  
  # Ensure column order is consistent
  df <- df[, all_cols]
  
  return(df)
})

combined_sraruninfo_df <- bind_rows(data_list)

# select only relevant column names
combined_sraruninfo_df_modf <- combined_sraruninfo_df %>% 
  select(run_accession, study_accession, study_title, experiment_accession, experiment_title, library_strategy, library_selection, library_layout, instrument_model, instrument_model_desc, run_total_bases)

# join with food/genome metadata where possible
combined_sraruninfo_metadata <- left_join(combined_sraruninfo_df_modf, run_accession_metadata)

write_tsv(combined_sraruninfo_metadata, "data/2025-05-22-sample-sraruninfo-metadata.tsv")

# stats
genome_food_metadata %>% 
  group_by(food_name) %>% 
  count() %>% 
  arrange(desc(n)) %>% 
  print(n=180)

genome_food_metadata %>% 
  group_by(food_type) %>% 
  count() %>% 
  arrange(desc(n)) %>% 
  print(n=21)

genome_food_metadata %>% 
  group_by(country) %>% 
  count() %>% 
  arrange(desc(n)) %>% 
  print(n=60)

# alluvial plot of genomes and foot categories

food_alluvial <- genome_food_metadata %>%
  filter(!is.na(food_type), !is.na(main_ingredient), !is.na(ingredient_group), !is.na(origin)) %>%
  count(food_type, main_ingredient, ingredient_group, origin, name = "n_genomes") %>%
  mutate(
    food_type = fct_lump_n(food_type, n = 20, w = n_genomes),
    main_ingredient = fct_lump_n(main_ingredient, n = 15, w = n_genomes),
    ingredient_group = fct_lump_n(ingredient_group, n = 10, w = n_genomes),
    origin = fct_lump_n(origin, n = 10, w = n_genomes)
  ) %>%
  mutate(
    food_type = fct_reorder(food_type, n_genomes, .fun = sum),
    main_ingredient = fct_reorder(main_ingredient, n_genomes, .fun = sum),
    ingredient_group = fct_reorder(ingredient_group, n_genomes, .fun = sum),
    origin = fct_reorder(origin, n_genomes, .fun = sum)
  ) %>% 
  mutate(flow_id = paste(food_type, main_ingredient, ingredient_group, origin, sep = " | ")) %>% 
  filter(food_type !=c("cheese"))


food_alluvial_plot <- ggplot(food_alluvial,
       aes(axis1 = food_type,
           axis2 = main_ingredient,
           axis3 = ingredient_group,
           axis4 = origin,
           y = n_genomes)) +
  geom_alluvium(aes(fill = flow_id), width = 1/12, alpha = 0.85, knot.pos = 0.5) +
  geom_stratum(width = 1/10, color = "black", fill = "gray95", radius = unit(3, "pt")) +
  geom_text(stat = "stratum", aes(label = paste0(after_stat(stratum), "\n(", after_stat(count), ")")),
            size = 3, hjust = 0, nudge_x = 0.05) +
  scale_x_discrete(
    limits = c("Food Type", "Main Ingredient", "Ingredient Group", "Origin"),
    expand = c(0.05, 0.05)
  ) +
  scale_fill_manual(values = colorRampPalette(RColorBrewer::brewer.pal(12, "Set3"))(length(unique(food_alluvial$flow_id)))) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "none"  # hide legend if each flow is unique
  ) +
  labs(
    title = "Genome Flows Through Food Categories",
    y = "Number of Genomes",
    x = NULL
  )

ggsave("figures/food-alluvial-plot.png", width=11, height=15, units=c("in"))

food_alluvial_plot
