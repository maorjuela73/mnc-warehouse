library(RSQLite)
library(tidyverse)

# create a connection to the database called "mcn-relational.db"
con <- dbConnect(RSQLite::SQLite(), "data/db/mnc-relational.db")

# Read the ciiu_actividades_areas table
ciiu_actividades_areas <- dbReadTable(con, "ciiu_actividades_areas") %>%
    select(-area_cualificacion)

# Select the rows where 'clase' is not null
ciiu_clases <- ciiu_actividades_areas %>%
    filter(!is.na(clase)) %>%
    select(-division, -grupo)

# Select the rows where 'grupo' is not null
ciiu_grupos <- ciiu_actividades_areas %>%
    filter(!is.na(grupo)) %>%
    select(-division, -clase)

# Select the rows where 'division' is not null
ciiu_divisiones <- ciiu_actividades_areas %>%
    filter(!is.na(division)) %>%
    select(-grupo, -clase)

# View(ciiu_divisiones)
