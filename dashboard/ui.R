ui <- dashboardPage(
  dashboardHeader(
    title = "MNC Colombia -  Bodega de Datos",
    titleWidth = 450
  ),
  dashboardSidebar(
    sidebarMenu(
        menuItem("Inicio",
            tabName = "home", icon = icon("home")),
        menuItem("Catálogo",
            tabName = "catalogo", icon = icon("book")),
        menuItem("Carga de archivos",
            tabName = "carga", icon = icon("upload")),
        menuItem("Consulta de datos",
            tabName = "consulta", icon = icon("search"))
    )
  ),
  dashboardBody(
    tabItems(
        tabItem(
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
        ),
        tabItem(
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
        ),
        tabItem(
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
        ),
        tabItem(
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
                    # Reactable with the catalog table
                    reactableOutput("areas_catalog"),
                    br(),
                    verbatimTextOutput("selected_row_details")
                )
            ),
            fluidRow(
                column(12,
                    plotOutput("actividades_areas_plot")
                )
            )
        )
    )
  )
)
