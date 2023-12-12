library(httr)
library(jsonlite)
library(tidyverse)
# library(dotenv)

# load_dot_env()

token_brechas <- ("0ec70f3fc55780976cd45766fa6914d8cefbbbcc")

url <- "https://eu.kobotoolbox.org/"
instrument <- "aEVEuUEh9GJqJCjFWTmp5q"
endpoint <- paste0("assets/", instrument, "/submissions/?format=json")

full_address <- paste0(url, endpoint)
headers <- c(Authorization = paste("token", token_brechas))
response <- GET(full_address, add_headers(headers))

print(response)
data <- content(response, as = "text", encoding = "UTF-8")

datos <- fromJSON(data) %>% as_tibble()

# View(datos)

# get datos headers in a list
colnames <- names(datos)
