dashboard_sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Inicio",
            tabName = "home", icon = icon("home")),
        menuItem("Catálogo",
            tabName = "catalogo", icon = icon("book")),
        menuItem("Carga de archivos",
            tabName = "carga", icon = icon("upload")),
        menuItem("Consulta de datos",
            icon = icon("bar-chart"), startExpanded = TRUE,
                menuSubItem(
                    "Descriptivos por área",
                    tabName = "infogeneral"),
                menuSubItem(
                    "Bases de datos de áreas",
                    tabName = "consulta")
        ),
        menuItem("Encuesta",
            tabName = "survey", icon = icon("question-circle")
        )
    )
)