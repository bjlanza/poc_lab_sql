# SQL Lab - Inicialización

## Un Comando. Listo.

### Opción 1: Python (Recomendado)

```bash
python3 init.py
```

Eso es todo. Instala todo.

### Opción 2: Bash

```bash
bash init.sh
```

Instala todo.

---

## Qué Hace

1. Instala Node.js
2. Instala SQLite
3. Instala npm dependencies
4. Inicializa todas las BDs
5. Arranca el servidor en http://localhost:3000

Todo automático. Sin intervención.

---

## Si Algo Falla

El error aparecerá en la terminal. Léelo y:

```bash
# Reintentar
python3 init.py
```

O verifica:

```bash
node --version   # Debe mostrar versión
npm --version    # Debe mostrar versión
sqlite3 --version # Debe mostrar versión
```

Si algo no está instalado, puedes hacerlo manualmente:

```bash
# Ubuntu/Debian
sudo apt-get install nodejs npm sqlite3
```

---

## En Codespaces

Todo es automático. El Codespace:

1. Ejecuta `python3 init.py` al crear
2. Ejecuta `npm start` al arrancar
3. Abre http://localhost:3000

Sin intervención manual.

---

## Web UI

Una vez que veas:

```
> npm start
SQL Lab Web UI corriendo en http://localhost:3000
```

Abre http://localhost:3000 en el navegador.

---

## Parar

Presiona `Ctrl+C` en la terminal donde corre `npm start`.

---

## Reiniciar BDs

Si quieres resetear las BDs:

```bash
# Ctrl+C para parar npm start

# Luego:
bash reset-dbs.sh

# Luego vuelve a iniciar:
cd web
npm start
```

---

## Archivos Principales

- `init.py` - Script de inicio (Python)
- `init.sh` - Script de inicio (Bash)
- `web/` - Servidor web y UI
- `labs/` - Laboratorios SQL
- `.devcontainer/` - Configuración Codespaces

---

## Troubleshooting Rápido

```bash
# Si ves "npm: command not found"
# Es que Node.js no se instaló. Reinstala:
python3 init.py

# Si ves "sqlite3: command not found"
# SQLite no se instaló. Instala manualmente:
sudo apt-get install sqlite3

# Si ves "Port 3000 already in use"
# Otra app usa el puerto. Usa otro:
PORT=3001 npm start
```

---

## Estado Final

Si todo funciona, deberías ver:

```
✓ Linux detectado
✓ Node.js v18.x instalado
✓ SQLite 3.x instalado
✓ npm dependencies instaladas
✓ BDs inicializadas (3 tablas)

SQL Lab Web UI corriendo en http://localhost:3000
```

Abre http://localhost:3000 y disfruta!
