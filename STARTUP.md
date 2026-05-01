# SQL Lab - Guía de Startup

Si la web no arranca, sigue estos pasos.

## Paso 1: Verificar Setup

Ejecuta el script de verificación:

```bash
python3 check-setup.py
```

O en Windows (PowerShell):

```powershell
python check-setup.py
```

Esto te dirá qué falta y qué está mal.

## Paso 2: Instalar Dependencias

Si falta `node_modules`:

```bash
cd web
npm install
cd ..
```

## Paso 3: Inicializar Bases de Datos

```bash
bash .devcontainer/setup.sh
```

Verifica que se crean los archivos:
- `/workspace/data/01-basics.db`
- `/workspace/data/02-joins.db`
- `/workspace/data/03-aggregates.db`

## Paso 4: Arrancar

Opción A (Automático con verificación):

```bash
bash start.sh
```

Opción B (Manual):

```bash
cd web
npm start
```

Debería ver:

```
✓ SQL Lab Web UI corriendo en http://localhost:3000
```

Abre http://localhost:3000 en el navegador.

---

## Troubleshooting

### Error: "npm: command not found"

Node.js no está instalado.

```bash
# macOS
brew install node

# Ubuntu/Debian
sudo apt-get install nodejs npm

# Windows
# Descarga de https://nodejs.org/
```

### Error: "sqlite3: command not found"

SQLite no está instalado.

```bash
# macOS
brew install sqlite

# Ubuntu/Debian
sudo apt-get install sqlite3

# Windows
# Descarga de https://www.sqlite.org/download.html
```

### Error: "Port 3000 already in use"

El puerto 3000 está ocupado.

```bash
# Usa otro puerto:
PORT=3001 bash start.sh

# O mata el proceso:
lsof -i :3000
kill -9 <PID>
```

### Error: "Cannot find module 'express'"

Las dependencias npm no están instaladas.

```bash
cd web
npm install
cd ..
bash start.sh
```

### Error: "Parse error: no such table: employees"

La BD existe pero no fue inicializada.

```bash
bash reset-dbs.sh
```

O manualmente:
```bash
sqlite3 /workspace/data/01-basics.db < labs/01-basics/init.sql
sqlite3 /workspace/data/02-joins.db < labs/02-joins/init.sql
sqlite3 /workspace/data/03-aggregates.db < labs/03-aggregates/init.sql
```

Verifica que funcionó:
```bash
sqlite3 /workspace/data/01-basics.db "SELECT * FROM employees;"
```

### Error: "Error: ENOENT: no such file or directory"

Las BDs no existen.

```bash
bash reset-dbs.sh
```

O si prefieres usar setup.sh:
```bash
bash .devcontainer/setup.sh
```

### Web UI no carga (página en blanco)

Revisa la consola del navegador (F12):
- Errores de JavaScript
- Errores de CORS
- Errores de red

Revisa la terminal del servidor:
- Mensajes de error de Express
- Errores al cargar archivos

---

## Scripts Disponibles

| Script | Propósito |
|--------|-----------|
| `check-setup.py` | Verifica que todo está en orden |
| `verify.sh` | Verificación detallada (bash) |
| `start.sh` | Arranca el servidor (automático) |

---

## En Codespaces (Automático)

Si usas GitHub Codespaces, todo debería ser automático:

1. El DevContainer arranca
2. `setup.sh` se ejecuta automáticamente
3. `npm install` se ejecuta automáticamente
4. `npm start` se ejecuta automáticamente
5. El puerto 3000 se forwarda automáticamente

Solo abre http://localhost:3000 en el navegador.

---

## Estado de Checklist

Ejecuta `python3 check-setup.py` y asegúrate de que ves:

```
✓ Carpeta 'labs' existe
✓ Carpeta '.devcontainer' existe
✓ Carpeta 'web' existe
✓ Lab '01-basics' existe
✓ Lab '02-joins' existe
✓ Lab '03-aggregates' existe
✓ Node.js instalado
✓ SQLite instalado
✓ node_modules existe (dependencias instaladas)

=== RESUMEN ===

Todo correcto - Puedes arrancar con: bash start.sh
```

Si algo falta, revisa los pasos arriba.
