server <- function(input, output, session) {

        # ValueBoxOutput to show number of uploaded files, data volume,
        # first upload date, last upload date
        output$num_files <- renderValueBox({
            valueBox(
                value = length(list.files("../data/input/")),
                subtitle = "Número de archivos cargados",
                icon = icon("upload")
            )
        })

        output$data_volume <- renderValueBox({
            valueBox(
                value = paste(round(sum(file.info(
                    list.files("../data/input/",
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
                    list.files("../data/input/",
                    all.files = TRUE,
                    recursive = TRUE,
                    full.names = TRUE),
                    extra_cols = FALSE
            ) %>%
            as_tibble(rownames = NA) %>%
            rownames_to_column("filename") %>%
            select(filename, size, ctime) %>%
            mutate(extension = stri_extract_last_regex(filename, "\\.\\w+$")) %>%
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
            dbGetQuery(
                con, sql_query) %>%
                ggplot() +
                geom_col(aes(
                    x = codigo_area,
                    y = actividades_economicas,
                    fill = codigo_area)) +
                labs(
                    # title = "Número de actividades económicas por área de cualificación",
                    x = "Área de cualificación",
                    y = "Número de actividades económicas (CIIU)"
                ) +
                theme_minimal()
        })
}