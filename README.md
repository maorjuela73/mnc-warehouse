mcn-warehouse/
│
├── app.R              # Archivo principal de Shiny
│
├── data/
│   ├── datos.xlsx     # Archivo Excel con los datos
│   ├── datos.sqlite   # Base de datos SQLite para el modelo relacional
│   └── scripts/
│       ├── carga_datos.R  # Script para cargar datos desde Excel a SQLite
│       └── consultas.sql  # Archivo con las consultas SQL
│
├── dashboard/
│   ├── ui.R           # Archivo de definición de la interfaz de usuario
│   ├── server.R       # Archivo de lógica del servidor
│   └── funciones.R    # Archivo con funciones auxiliares
│
├── www/               # Carpeta para recursos web estáticos (CSS, imágenes, etc.)
│
└── README.md          # Documentación del proyecto
