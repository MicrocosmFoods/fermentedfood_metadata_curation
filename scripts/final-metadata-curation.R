library(tidyverse)
library(RColorBrewer)
library(grid)
library(patchwork)
library(cowplot)
library(viridis)
library(colorspace)
library(MetBrewer)
library(ggbreak)
library(rnaturalearth)
library(sf)

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

# bar graphs of food categories and taxonomy 

# group genomes in phyla less than 500 in an "other" group
phylum_counts <- genome_food_metadata %>%
  mutate(phylum = sub(";.*", "", taxonomy)) %>%
  count(phylum)

genome_clean <- genome_food_metadata %>%
  mutate(phylum = sub(";.*", "", taxonomy)) %>%
  left_join(phylum_counts, by = "phylum") %>%
  mutate(phylum = ifelse(n < 500, "Other", phylum),
         phylum = fct_rev(fct_infreq(phylum)))

# main taxonomy plot
main_plot <- genome_clean %>%
  ggplot(aes(y = phylum, fill = phylum)) +
  geom_bar(show.legend = FALSE) +
  scale_fill_met_d("Cassatt2") +  # Softer, food-friendly palette
  labs(
    title = "Number of Genomes by Phylum \n",
    y = "Phylum",
    x = "Number of Genomes"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    axis.text = element_text(size = 10, color = "black"),
    axis.title.x = element_text(
      size = 14, face = "bold", color = "black",
      margin = margin(t = 10)  # Adds space above x-axis title
    ),
    axis.title.y = element_text(
      size = 14, face = "bold", color = "black",
      margin = margin(r = 10)  # Adds space to the right of y-axis title
    ),
    plot.title = element_text(size = 14, face = "bold", color = "black")
  ) +
  scale_x_continuous(expand=c(0,0))

# inset plot for Bacillota families
bacillota_families <- genome_food_metadata %>%
  filter(grepl("^Bacillota;", taxonomy)) %>%
  mutate(family = sub("^[^;]*;[^;]*;[^;]*;([^;]*);.*", "\\1", taxonomy)) %>%
  count(family, sort = TRUE)

bacillota_families <- bacillota_families %>%
  mutate(family = ifelse(n < 100, "Other Bacillota", family)) %>%
  group_by(family) %>%
  summarise(n = sum(n)) %>%
  arrange(desc(n))

tax_inset_plot <- ggplot(bacillota_families, aes(x = fct_reorder(family, n), y = n)) +
  geom_col(fill = "#2C4B27") +  # Softer green tone
  coord_flip() +
  labs(title="Families within Bacillota") + 
  theme_minimal(base_size = 9) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    axis.text = element_text(size = 9, color = "black"),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    plot.title = element_text(face="italic", size = 8, color="black")
  ) +
  scale_y_continuous(expand=c(0,0))

# Combine with inset
taxonomy_plot_with_inset <- ggdraw() +
  draw_plot(main_plot) +
  draw_plot(tax_inset_plot, x = 0.45, y = 0.15, width = 0.50, height = 0.55)

taxonomy_plot_with_inset

# food type bar graph
food_data <- genome_food_metadata %>%
  count(food_type, sort = TRUE) %>%
  mutate(food_type = str_to_title(food_type),
         food_type = ifelse(n < 75, "Other Foods", food_type)) %>%
  group_by(food_type) %>%
  summarise(n = sum(n), .groups = "drop") %>%
  mutate(food_type = factor(food_type, levels = unique(food_type)))

# inset plot for beverage food category
beverage_groups <- genome_food_metadata %>%
  filter(food_type == "beverage") %>%
  mutate(
    sample_name = str_to_title(sample_name),
    sample_name = gsub("_", " ", sample_name),
    sample_name = case_when(
      sample_name %in% c("Water kefir", "Kefir") ~ "Kefir",
      TRUE ~ sample_name
    )
  ) %>%
  count(sample_name, sort = TRUE)

beverage_counts <- beverage_groups %>% 
  mutate(sample_name = ifelse(n < 65, "Other Beverages", sample_name)) %>% 
  group_by(sample_name) %>% 
  summarise(n = sum(n)) %>% 
  arrange(desc(n))

beverage_inset_plot <- ggplot(beverage_counts, aes(x = fct_reorder(sample_name, n), y = n)) +
  geom_col(fill = "#ED90A4") +
  coord_flip() +
  labs(title="Specific Beverages") +
  theme_minimal(base_size = 9) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    axis.text = element_text(size = 8, color = "black"),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    plot.title = element_text(face="italic", size=9, color="black", hjust=0.5)) +
  scale_y_continuous(expand=c(0,0))

# Generate a palette with correct number of colors
n_colors <- nlevels(food_data$food_type)
palette_food <- qualitative_hcl(n_colors, palette = "Set 2")

main_food_plot <- ggplot(food_data, aes(x = fct_reorder(food_type, n), y = n, fill = food_type)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Number of Genomes by Food Type \n",
    x = "Food Type",
    y = "Number of Genomes"
  ) +
  scale_fill_manual(values = palette_food) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    axis.text = element_text(size = 10, color = "black"),
    axis.title.x = element_text(size = 14, face = "bold", color = "black", margin = margin(t = 10)),
    axis.title.y = element_text(size = 14, face = "bold", color = "black", margin = margin(r = 10)),
    plot.title = element_text(size = 14, face = "bold", color = "black")
  ) +
  scale_y_continuous(expand=c(0,0))

# combined food plot with inset beverage plot

food_plot_with_inset <- ggdraw() +
  draw_plot(main_food_plot) +
  draw_plot(beverage_inset_plot, x = 0.30, y = 0.15, width = 0.60, height = 0.60)

food_plot_with_inset

# world map of # genomes

country_counts <- genome_food_metadata %>%
  filter(!is.na(country)) %>%
  mutate(country = ifelse(country == "USA", "United States of America", country)) %>%
  count(country, sort = TRUE)

world_centroids <- ne_countries(scale = "medium", returnclass = "sf") %>%
  st_centroid() %>%
  st_transform(crs = 4326) %>%  # WGS84 lat/lon
  select(name, geometry) %>%
  mutate(
    longitude = st_coordinates(geometry)[, 1],
    latitude = st_coordinates(geometry)[, 2]
  )

country_plot_data <- country_counts %>%
  left_join(world_centroids, by = c("country" = "name")) %>%
  filter(!is.na(longitude)) 

world_map <- ne_countries(scale = "medium", returnclass = "sf") %>%
  filter(name != "Antarctica")

genomes_map <- ggplot() +
  geom_sf(data = world_map, fill = "gray95", color = "gray80") +
  geom_point(
    data = country_plot_data,
    aes(x = longitude, y = latitude, size = n),
    color = "#1f78b4", alpha = 0.8
  ) +
  scale_size_continuous(range = c(2, 10), name = "Number of Genomes") +
  theme_void() +
  labs(
    title = "Geographic Distribution of Genomes by Country of Origin \n",
    x = NULL, y = NULL
  ) +
  theme(
    panel.grid = element_blank(),
    legend.position = c(0.15, 0.40),
    plot.title = element_text(size = 14, face = "bold")
  )

genomes_map

# create subset europe map
europe_map <- ne_countries(scale = "medium", returnclass = "sf") %>%
  filter(region_un == "Europe")

# Join with centroids as before (optional: recompute centroids for cleaner Europe view)
europe_centroids <- europe_map %>%
  st_centroid(of_largest_polygon = TRUE) %>%
  st_transform(crs = 4326) %>%
  mutate(
    longitude = st_coordinates(geometry)[, 1],
    latitude = st_coordinates(geometry)[, 2]
  ) %>%
  select(name, longitude, latitude)

# Join genome counts and subset only European countries
europe_data <- country_counts %>%
  inner_join(europe_centroids, by = c("country" = "name"))

europe_map_plot <- ggplot() +
  geom_sf(data = europe_map, fill = "gray95", color = "gray80") +
  geom_point(
    data = europe_data,
    aes(x = longitude, y = latitude, size = n),
    color = "#1f78b4", alpha = 0.8
  ) +
  scale_size_continuous(range = c(2, 10), name = "Number of Genomes") +
  coord_sf(xlim = c(-25, 45), ylim = c(34, 72), expand = FALSE) +
  theme_void() +
  labs(
    title = NULL,
    x = NULL, y = NULL
  ) +
  theme(
    panel.grid = element_blank(),
    legend.position = "right"
  )

europe_map_plot


# save figures
ggsave("figures/genomes-map.png", genomes_map, width=11, height=8, units=c("in"))
ggsave("figures/food-counts.png", food_plot, width=11, height=8, units=c("in"))
ggsave("figures/taxonomy-counts.png", taxonomy_plot, width=11, height=8, units=c("in"))

# combine all 3 together
combined_plot <- ((genomes_map | europe_map_plot) / plot_spacer() / (food_plot_with_inset | taxonomy_plot_with_inset)) +
  plot_layout(heights = c(1, 0.03, 1.1))

combined_plot

ggsave("figures/combined-grid-plot.png", combined_plot, height=8, width=15, units=c("in"))
ggsave("figures/combined-grid-plot.pdf", combined_plot, height=9, width=15, units=c("in"))
