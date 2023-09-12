library(RSQLite)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(reactable)

# create a connection to the database called "mcn-relational.db"
con <- dbConnect(RSQLite::SQLite(), "data/db/mnc-relational.db")

areas_cualificacion <- dbReadTable(con, "areas_cualificacion")
runApp("dashboard")
