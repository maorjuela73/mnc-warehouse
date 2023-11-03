tab_home <- tabItem(
    tabName = "home",
    fluidRow(
        box(
            title = "Bienvenido",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            "Bienvenido a la bodega de datos del MNC Colombia. 
            En esta aplicación podrá consultar los datos de la 
            bodega de datos del MNC Colombia, así como cargar 
            nuevos datos a la bodega de datos."
        )
    ),
    fluidRow(
        # ValueBoxOutput to show number of uploaded files, data volume,
        # first upload date, last upload date
        valueBoxOutput("num_files"),
        valueBoxOutput("data_volume"),
        valueBoxOutput("first_upload_date"),
        valueBoxOutput("last_upload_date")
    )
)

tab_catalogo <- tabItem(
    tabName = "catalogo",
    fluidRow(
        box(
            title = "Catálogo de archivos",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            "En esta sección podrá consultar el catálogo de 
            datos de la bodega de datos del MNC Colombia."
        )
    ),
    fluidRow(
        box(
            title = "Filtros",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            fluidRow(
                column(3,
                    textInput("filename", "Nombre del archivo", "")
                ),
                column(3,
                    textInput("size", "Tamaño del archivo", "")
                ),
                column(3,
                    textInput(
                        "ctime", "Fecha de creación del archivo", ""
                    )
                ),
                column(3,
                    textInput("extension", "Extensión del archivo", "")
                )
            ),
            fluidRow(
                column(12,
                    actionButton(
                        "clear_filters", "Limpiar filtros",
                        icon = icon("eraser"),
                        style = "color: #fff; background-color: 
                        #d9534f; border-color: #d43f3a;"),
                    actionButton(
                        "apply_filters", "Aplicar filtros",
                        icon = icon("filter"),
                        style = "color: #fff; background-color:
                        #5cb85c; border-color: #4cae4c;")
                )
            )
        )
    ),
    fluidRow(
        column(12,
            # Reactable with the catalog table
            reactableOutput("file_catalog")
        )
    )
)

tab_carga <- tabItem(
    tabName = "carga",
    fluidRow(
        box(
            title = "Carga de archivos",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            "En esta sección podrá cargar nuevos datos a la 
            bodega de datos del MNC Colombia."
        )
    ),
    fluidRow(
        column(12,
            # FileInput to upload files
            fileInput(
                "file_upload", "Seleccione los archivos a cargar",
                multiple = TRUE
            )
        )
    )
)

tab_consulta <- tabItem(
    tabName = "consulta",
    fluidRow(
        box(
            title = "Consulta de datos",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            "En esta sección podrá consultar los datos de la 
            bodega de datos del MNC Colombia."
        )
    ),
    fluidRow(
        column(12,
            h3("Selección de Áreas de cualificación"),
            # Reactable with the catalog table
            reactableOutput("areas_catalog"),
            br(),
            verbatimTextOutput("selected_row_details")
        )
    ),
    fluidRow(
        column(12,
            h3("Actividades económicas CIIU relacionadas"),
        )
    ),
    fluidRow(
        column(6,
            # Reactable with the ciiu table
            reactableOutput("tabla_ciiu")
        ),
        column(6,
            plotOutput("actividades_areas_plot")
        )
    ),
    fluidRow(
        column(12,
            h3("Ocupaciones CUOC relacionadas"),
        )
    ),
    fluidRow(
        column(6,
            # Reactable with the cuoc table
            reactableOutput("tabla_cuoc")
        ),
        column(6,
            plotOutput("ocupaciones_areas_plot")
        )
    ),
    fluidRow(
        column(12,
            h3("Información CINE relacionada"),
        )
    ),
    fluidRow(
        column(6,
            # Reactable with the cine table
            reactableOutput("tabla_cine")
        ),
        column(6,
            plotOutput("cine_areas_plot")
        )
    )
)
