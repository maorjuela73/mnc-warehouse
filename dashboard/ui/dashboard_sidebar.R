dashboard_sidebar <- dashboardSidebar(
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
)