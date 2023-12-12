tab_home <- tabItem(
    tabName = "home",
    fluidRow(
        box(
            title = "Bienvenido",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            "Bienvenido al Sistema de Gestión de datos del MNC Colombia. 
            En esta aplicación podrá consultar los datos de la 
            Sistema de Gestión de datos del MNC Colombia, así como cargar 
            nuevos datos al Sistema de Gestión de datos."
        )
    ),
    fluidRow(
        # ValueBoxOutput to show number of uploaded files, data volume,
        # first upload date, last upload date
        # valueBoxOutput("num_files"),
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
            datos del Sistema de Gestión de datos del MNC Colombia."
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
            Sistema de Gestión de datos del MNC Colombia."
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
            Sistema de Gestión de datos del MNC Colombia."
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

tab_infogeneral <- tabItem(
    tabName = "infogeneral",
    fluidRow(
        box(
            title = "Bases de datos de áreas",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            "En esta sección podrá consultar las bases de datos de 
            áreas del Sistema de Gestión de datos del MNC Colombia."
        )
    ),
    fluidRow(
        column(2,
            h3("Variables a mostrar"),
            checkboxGroupInput(
                "general_variables", "Variables",
                choices = c(
                    "Clase" = "clase",
                    "Descripción" = "descripcion",
                    "Código de área" = "codigo_area",
                    "Area de cualificación" = "area_cualificacion",
                    "Código CINE" = "codigo_cine_2011_ac",
                    "Campos detallados" = "campos_detallado"
                ),
                selected = c(
                    "clase",
                    "descripcion",
                    "codigo_area",
                    "area_cualificacion",
                    "codigo_cine_2011_ac",
                    "campos_detallado"
                )
            )
        ),
        column(10,
            h3("Tabla general de consulta"),
            # Reactable with the catalog table
            reactableOutput("joined_table")
        )
    )
)

tab_survey <- tabItem(
    tabName = "survey",
    fluidRow(
        box(
            title = "Encuesta",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            "En esta sección podrá ver los resultados de la Encuesta
            de Demanda Laboral."
        )
    ),
    fluidRow(
        column(3,
            h3("Variables a mostrar"),
            # Reactable with the catalog table
            # make a checkboxGroupInput with the names of the variables present in the dataframe datos
            # "_id"                   "formhub/uuid"          "start"                
            # "today"                 "end"                   "intro/cons_1"         
            # cap_B/cant"            "Cargos_criticos_count" "Cargos_criticos"      
            # "cap_C/C1"              "cap_C/C2"              "cap_C/C3"             
            # "cap_C/C4"              "__version__"           "meta/instanceID"      
            # "_xform_id_string"      "_uuid"                 "_attachments"         
            # "_status"               "_geolocation"          "_submission_time"     
            # "_tags"                 "_notes"                "_validation_status"   
            # "_submitted_by"         "cap_A/a2.1"            "cap_A/a2.2"           
            # "cap_A/a2.2.1"          "cap_A/a2.4"            "cap_A/a1.2"           
            # "cap_A/a1.4"            "cap_A/a1.ub"           "cap_A/a1.5"           
            # "cap_A/a2.3"            "cap_A/a1.4a"           "cap_B/Cargos_cant"    
            # "Misionales/B21"        "Misionales/B21S1A"     "cap_C/C3S1"           
            # "cap_d/d2"              "cap_d/d3"              "cap_d/d4"             
            # "cap_d/d5"              "cap_d/d6"              "cap_d/d7"             
            # "cap_d/d71"             "intro/area"            "cap_d/d51"            
            # "cap_d/d61"             "Misionales/B21S1B"     "cap_e/e1"             
            # "cap_A/a2.2.1_other"    "cap_A/a1.4_other"      "Misionales/B21S1C"    
            # "cap_C/C3_other"       

            checkboxGroupInput(
                "survey_variables", "Variables",
                choices = c(
                    "Nombres y apellidos" = "cap_A/a2.1",
                    "Cargo" = "cap_A/a2.2",
                    "Area de desempeño" = "cap_A/a2.2.1",
                    "Correo" = "cap_A/a2.4",
                    "Razón social" = "cap_A/a1.2",
                    "Actividad económica" = "cap_A/a1.4",
                    "Departamento" = "cap_A/a1.ub",
                    "Tamaño empresa" = "cap_A/a1.5",
                    "Teléfono" = "cap_A/a2.3",
                    "NIT" = "cap_A/a1.4a",
                    "Cargos en empresa" = "cap_B/Cargos_cant",
                    "Misionales/B21" = "Misionales/B21",
                    "Misionales/B21S1A" = "Misionales/B21S1A",
                    "cap_C/C3S1" = "cap_C/C3S1",
                    "cap_d/d2" = "cap_d/d2",
                    "cap_d/d3" = "cap_d/d3",
                    "cap_d/d4" = "cap_d/d4",
                    "cap_d/d5" = "cap_d/d5",
                    "cap_d/d6" = "cap_d/d6",
                    "cap_d/d7" = "cap_d/d7",
                    "cap_d/d71" = "cap_d/d71",
                    "intro/area" = "intro/area",
                    "cap_d/d51" = "cap_d/d51",
                    "cap_d/d61" = "cap_d/d61",
                    "Misionales/B21S1B" = "Misionales/B21S1B",
                    "cap_e/e1" = "cap_e/e1",
                    "cap_A/a2.2.1_other" = "cap_A/a2.2.1_other",
                    "cap_A/a1.4_other" = "cap_A/a1.4_other"
                )
            )
        ),
        column(9,
            reactableOutput("survey_table")
        )
    )
)
