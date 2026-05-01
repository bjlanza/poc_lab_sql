# SQL Lab Web UI

Interfaz web estilo LabEx/DataCamp para SQL Lab.

## Arquitectura

- **Backend**: Express.js + better-sqlite3
- **Frontend**: HTML + CSS vanilla + Monaco Editor (CDN)
- **Markdown**: Marked.js (CDN)

## Instalación Local

### Requisitos

- Node.js 14+ (con npm)
- SQLite 3+

### Setup

```bash
# 1. Instalar dependencias
npm install

# 2. Asegurar que las BDs están inicializadas
cd ..
bash .devcontainer/setup.sh

# 3. Volver a la carpeta web
cd web

# 4. Iniciar servidor
npm start
```

El servidor se abre en `http://localhost:3000`

## Desarrollo

### Rutas API

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/labs` | Lista de labs con metadatos |
| GET | `/api/labs/:id/content` | Instrucciones en Markdown |
| POST | `/api/labs/:id/execute` | Ejecutar SQL libre |
| POST | `/api/labs/:id/check` | Validar ejercicio |
| GET | `/api/progress` | Leer progreso |
| PUT | `/api/progress/:id` | Actualizar progreso |

### Estructura de archivos

```
web/
├── server.js           ← Express server + API routes
├── package.json        ← Dependencias
└── public/
    ├── index.html      ← Layout principal
    ├── css/
    │   └── app.css     ← Estilos DataCamp-dark
    └── js/
        ├── app.js      ← Lógica principal
        ├── ui.js       ← Renderizado de componentes
        └── editor.js   ← Inicialización de Monaco
```

### Variables de entorno

- `WORKSPACE` - Ruta raíz (por defecto `/workspace`)
- `PORT` - Puerto del servidor (por defecto `3000`)

## Sobre Codespaces

En Codespaces, el setup es automático:

1. El DevContainer ejecuta `setup.sh` al crear el contenedor
2. `npm install` se ejecuta automáticamente
3. `npm start` se ejecuta automáticamente
4. La UI está disponible en el puerto 3000 (forwarded)

## Troubleshooting

**Error: "sqlite3 not found"**
```bash
sudo apt-get install -y sqlite3
```

**Error: "better-sqlite3 build failed"**
```bash
npm install --save-optional
# o simplemente ignorar (los módulos opcionales no son críticos)
```

**Puerto 3000 en uso**
```bash
PORT=3001 npm start
```

**Referenciar BDs del contenedor**

Las BDs viven en `/workspace/data/`:
- `/workspace/data/01-basics.db`
- `/workspace/data/02-joins.db`
- `/workspace/data/03-aggregates.db`

En desarrollo local, asegúrate que existen. Si no:
```bash
bash ../. devcontainer/setup.sh
```
