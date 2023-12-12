library(RSQLite)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(stringi)
library(reactable)
library(jsonlite)

# load the kobo.R file
source("kobo.R")

# create a connection to the database called "mcn-relational.db"
con <- dbConnect(RSQLite::SQLite(), "data/db/mnc-relational.db")

areas_cualificacion <- dbReadTable(con, "areas_cualificacion")

shinyServer(function(input, output, session) {

        # ValueBoxOutput to show number of uploaded files, data volume,
        # first upload date, last upload date
        output$num_files <- renderValueBox({
            valueBox(
                value = length(list.files("data/input/")),
                subtitle = "Número de archivos cargados",
                icon = icon("upload")
            )
        })

        output$data_volume <- renderValueBox({
            valueBox(
                value = paste(round(sum(file.info(
                    list.files("data/input/",
                    all.files = TRUE,
                    recursive = TRUE,
                    full.names = TRUE))$size) / 1000000, 1), "MB"),
                subtitle = "Volumen de datos cargados",
                icon = icon("database")
            )
        })

        output$first_upload_date <- renderValueBox({
            valueBox(
                value = Sys.Date(), # TOFIX: make this the first upload datetime
                subtitle = "Fecha de la primera carga",
                icon = icon("calendar")
            )
        })

        output$last_upload_date <- renderValueBox({
            valueBox(
                value = Sys.Date(), # TOFIX: make this the last upload datetime
                subtitle = "Fecha de la última carga",
                icon = icon("calendar")
            )
        })

        output$file_catalog <- renderReactable(
            file.info(
                    list.files("data/input/",
                    all.files = TRUE,
                    recursive = TRUE,
                    full.names = TRUE),
                    extra_cols = FALSE
            ) %>%
            as_tibble(rownames = NA) %>%
            rownames_to_column("filename") %>%
            select(filename, size, ctime) %>%
            mutate(
                extension = stri_extract_last_regex(filename, "\\.\\w+$")
            ) %>%
            reactable(
                columns = list(
                    filename = colDef(
                        name = "Nombre del archivo (click para descargar)",
                        cell = function(value) gsub(
                            "../data/input//", " ", value, fixed = TRUE),
                        minWidth = 250,
                    ),
                    size = colDef(
                        name = "Tamaño (MB)",
                        align = "center",
                        cell = function(value) {
                            paste0(
                            round(value / 1000000, 1))
                        },
                        maxWidth = 100
                    ),
                    ctime = colDef(
                        name = "Fecha de carga"
                    ),
                    extension = colDef(
                        name = "Extensión"
                    )
                ),
                bordered = TRUE,
                highlight = TRUE
            )
        )

        output$areas_catalog <- renderReactable(
            areas_cualificacion %>%
            reactable(
                columns = list(
                    codigo_area = colDef(
                        name = "Código de área",
                        align = "center",
                        maxWidth = 120,
                        filterable = TRUE
                    ),
                    nombre_area = colDef(
                        name = "Área de cualificación",
                        filterable = TRUE
                    )
                ),
                bordered = TRUE,
                highlight = TRUE,
                selection = "multiple",
                onClick = "select",
                defaultPageSize = 5,
                rowStyle = list(cursor = "pointer"),
                pageSizeOptions = c(5, 10, 15),
                showPageSizeOptions = TRUE
            )
        )

        output$tabla_ciiu <- renderReactable({
            selected <- getReactableState("areas_catalog", "selected")
            req(selected)
            ids_selected <- toString(
                sprintf("'%s'", areas_cualificacion[selected, ]$codigo_area)
                )
            sql_template <- "
                SELECT codigo_area, area_cualificacion, clase, descripcion
                FROM ciiu_actividades_areas
                WHERE codigo_area IN (%s) AND clase IS NOT NULL
                ;"
            sql_query <- sprintf(sql_template, ids_selected)
            dbGetQuery(
                con, sql_query) %>%
            reactable(
                columns = list(
                    codigo_area = colDef(
                        name = "Código de área",
                        align = "center",
                        maxWidth = 120,
                        filterable = TRUE
                    ),
                    area_cualificacion = colDef(
                        name = "Área de cualificación",
                        filterable = TRUE
                    ),
                    clase = colDef(
                        name = "Clase",
                        align = "center",
                        maxWidth = 120,
                        filterable = TRUE
                    ),
                    descripcion = colDef(
                        name = "Descripción",
                        filterable = TRUE
                    )
                ),
                bordered = TRUE,
                highlight = TRUE,
                defaultPageSize = 5,
                rowStyle = list(cursor = "pointer"),
                pageSizeOptions = c(5, 10, 15),
                showPageSizeOptions = TRUE
            )
        })

        output$tabla_cuoc <- renderReactable({
            selected <- getReactableState("areas_catalog", "selected")
            req(selected)
            ids_selected <- toString(
                sprintf("'%s'", areas_cualificacion[selected, ]$codigo_area)
                )
            sql_template <- "
                SELECT codigo_area, area_cualificacion, indice_numerico, denominaciones
                FROM cuoc_index_2022
                WHERE codigo_area IN (%s)
                ;"
            sql_query <- sprintf(sql_template, ids_selected)
            dbGetQuery(
                con, sql_query)  %>%
            reactable(
                columns = list(
                    codigo_area = colDef(
                        name = "Código de área",
                        align = "center",
                        maxWidth = 120,
                        filterable = TRUE
                    ),
                    area_cualificacion = colDef(
                        name = "Área de cualificación",
                        filterable = TRUE
                    ),
                    indice_numerico = colDef(
                        name = "Índice numérico",
                        align = "center",
                        maxWidth = 120,
                        filterable = TRUE
                    ),
                    denominaciones = colDef(
                        name = "Denominaciones",
                        filterable = TRUE
                    )
                ),
                bordered = TRUE,
                highlight = TRUE,
                defaultPageSize = 5,
                rowStyle = list(cursor = "pointer"),
                pageSizeOptions = c(5, 10, 15),
                showPageSizeOptions = TRUE
            )
        })

        output$tabla_cine <- renderReactable({
            selected <- getReactableState("areas_catalog", "selected")
            req(selected)
            ids_selected <- toString(
                sprintf("'%s'", areas_cualificacion[selected, ]$codigo_area)
                )
            sql_template <- "
                SELECT *
                FROM cine_actividades_areas
                WHERE codigo_area IN (%s)
                ;"
            sql_query <- sprintf(sql_template, ids_selected)
            dbGetQuery(
                con, sql_query) %>%
            reactable(
                columns = list(
                    codigo_area = colDef(
                        name = "Código de área",
                        align = "center",
                        maxWidth = 120,
                        filterable = TRUE
                    ),
                    area_cualificacion = colDef(
                        name = "Área de cualificación",
                        filterable = TRUE
                    ),
                    codigo_cine_2011_ac = colDef(
                        name = "Código CINE",
                        align = "center",
                        maxWidth = 120,
                        filterable = TRUE
                    ),
                    campos_detallado = colDef(
                        name = "Campos Detallado",
                        filterable = TRUE
                    )
                ),
                bordered = TRUE,
                highlight = TRUE,
                defaultPageSize = 5,
                rowStyle = list(cursor = "pointer"),
                pageSizeOptions = c(5, 10, 15),
                showPageSizeOptions = TRUE
            )
        })

        output$selected_row_details <- renderText({
            selected <- getReactableState("areas_catalog", "selected")
            req(selected)
            # print the selected rows in the console which ids are in selected
            areas_cualificacion[selected, ]$codigo_area
        })

        output$actividades_areas_plot <- renderPlot({
            selected <- getReactableState("areas_catalog", "selected")
            req(selected)
            ids_selected <- toString(
                sprintf("'%s'", areas_cualificacion[selected, ]$codigo_area)
                )
            sql_template <- "
                SELECT codigo_area, COUNT(clase) AS actividades_economicas
                FROM ciiu_actividades_areas
                WHERE clase IS NOT NULL AND codigo_area IN (%s)
                GROUP BY codigo_area;"
            sql_query <- sprintf(sql_template, ids_selected)
            data <- dbGetQuery(con, sql_query)
            data %>%
                ggplot() +
                geom_col(aes(
                    x = codigo_area,
                    y = actividades_economicas,
                    fill = codigo_area)) +
                # put the labels on top of the bars rotate 90 degrees and with the bar color
                geom_text(aes(
                    x = codigo_area,
                    y = actividades_economicas,
                    label = actividades_economicas,
                    color = codigo_area),
                    vjust = -0.5,
                    size = 8,
                    fontface = "bold") +
                labs(
                    # title = "Número de actividades económicas por área de cualificación",
                    x = "Área de cualificación",
                    y = "Número de actividades económicas (CIIU)"
                ) +
                # change the y max limit to the highest bar plus 10
                scale_y_continuous(
                    limits = c(0, max(data$actividades_economicas) + 10)
                ) +
                theme_minimal()
        })

        output$ocupaciones_areas_plot <- renderPlot({
            selected <- getReactableState("areas_catalog", "selected")
            req(selected)
            ids_selected <- toString(
                sprintf("'%s'", areas_cualificacion[selected, ]$codigo_area)
                )
            sql_template <- "
                SELECT codigo_area, COUNT(indice_numerico) AS denominaciones
                FROM cuoc_index_2022
                WHERE codigo_area IN (%s)
                GROUP BY codigo_area;"
            sql_query <- sprintf(sql_template, ids_selected)
            data <- dbGetQuery(con, sql_query)
            data %>%
                ggplot() +
                geom_col(aes(
                    x = codigo_area,
                    y = denominaciones,
                    fill = codigo_area)) +
                # put the labels on top of the bars rotate 90 degrees and with the bar color
                geom_text(aes(
                    x = codigo_area,
                    y = denominaciones,
                    label = denominaciones,
                    color = codigo_area),
                    vjust = -0.5,
                    size = 8,
                    fontface = "bold") +
                labs(
                    # title = "Número de actividades económicas por área de cualificación",
                    x = "Área de cualificación",
                    y = "Número de denominaciones (CUOC)"
                ) +
                # change the y max limit to the highest bar plus 10
                scale_y_continuous(
                    limits = c(0, max(data$denominaciones) + 100)
                ) +
                theme_minimal()
        })

        output$cine_areas_plot <- renderPlot({
            selected <- getReactableState("areas_catalog", "selected")
            req(selected)
            ids_selected <- toString(
                sprintf("'%s'", areas_cualificacion[selected, ]$codigo_area)
                )
            sql_template <- "
                SELECT 
                codigo_area, COUNT(codigo_cine_2011_ac) AS campo_detallado
                FROM cine_actividades_areas
                WHERE codigo_area IN (%s)
                GROUP BY codigo_area;"
            sql_query <- sprintf(sql_template, ids_selected)
            data <- dbGetQuery(con, sql_query)
            data %>%
                ggplot() +
                geom_col(aes(
                    x = codigo_area,
                    y = campo_detallado,
                    fill = codigo_area)) +
                # put the labels on top of the bars rotate 90 degrees and with the bar color
                geom_text(aes(
                    x = codigo_area,
                    y = campo_detallado,
                    label = campo_detallado,
                    color = codigo_area),
                    vjust = -0.5,
                    size = 8,
                    fontface = "bold") +
                labs(
                    # title = "Número de actividades económicas por área de cualificación",
                    x = "Área de cualificación",
                    y = "Número de campos detallados (CINE)"
                ) +
                # change the y max limit to the highest bar plus 10
                scale_y_continuous(
                    limits = c(0, max(data$campo_detallado) + 3)
                ) +
                theme_minimal()
        })

        output$joined_table <- renderReactable(
            dbGetQuery(
                con, "
                SELECT 
                --ciiu.division,
                --ciiu.grupo,
                ciiu.clase,
                ciiu.descripcion,
                cine.codigo_area,
                cine.area_cualificacion,
                cine.codigo_cine_2011_ac,
                cine.campos_detallado
                FROM ciiu_actividades_areas ciiu
                JOIN areas_cualificacion areas USING (codigo_area)
                JOIN cine_actividades_areas cine USING (codigo_area)
                WHERE ciiu.clase IS NOT NULL
                ;"
            ) %>%
            as_tibble() %>%
            select(input$general_variables) %>%
            reactable(
                bordered = TRUE,
                highlight = TRUE,
                filterable = TRUE, minRows = 10
            )
        )

        output$survey_table <- renderReactable(
            datos %>%
            select(
                c("cap_A/a1.4", "cap_A/a1.ub", "cap_A/a1.5",
                  "cap_C/C1", "cap_C/C2", "cap_C/C3", "cap_C/C4",
                  "cap_C/C3S1", "cap_C/C3_other",
                  "cap_d/d2", "cap_d/d3", "cap_d/d4", "cap_d/d5", "cap_d/d6",
                  "cap_d/d7", "cap_d/d71", "cap_d/d51", "cap_d/d61",
                  "Misionales/B21", "Misionales/B21S1A", "Misionales/B21S1B")
            ) %>%
            reactable(
                filterable = TRUE, minRows = 10
            )
        )
})