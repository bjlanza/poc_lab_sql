# SQL Lab en GitHub Codespaces

Configuración automática en Codespaces.

## Flujo Automático

Cuando creas un Codespace:

1. **postCreateCommand** (Una sola vez al crear)
   ```
   python3 init.py
   ```
   Instala:
   - Node.js
   - SQLite
   - npm dependencies
   - Inicializa BDs
   - Crea .progress.json

2. **postStartCommand** (Cada vez que arrancas)
   ```
   cd /workspace/web && npm start
   ```
   Arranca el servidor en http://localhost:3000

---

## Tiempo Total

- **Primera vez**: 3-5 minutos (instala todo)
- **Siguientes veces**: 30 segundos (solo arranca servidor)

---

## Qué Ver en la Terminal

### Paso 1: Creando Codespace (2-3 min)

```
[0/5] Cloning repository...
[1/5] Starting container...
[2/5] Running postCreateCommand...

1. Instalando Node.js...
> apt-get update
> apt-get install -y nodejs npm

2. Instalando SQLite...
> apt-get install -y sqlite3

3. Creando directorios...
   OK: /workspace/data

4. Instalando dependencias npm...
> npm install

5. Inicializando bases de datos...
   Creando /workspace/data/01-basics.db...
   Creando /workspace/data/02-joins.db...
   Creando /workspace/data/03-aggregates.db...

6. Creando progress file...
   OK: /workspace/.progress.json

7. Verificando instalación...
   npm@9.x

==================================================
LISTO!
==================================================

Inicializacion completada correctamente.
El servidor se arrancara automaticamente.

Abre en el navegador: http://localhost:3000
```

### Paso 2: Arrancando Servidor (30 seg)

```
> npm start

> sql-lab-web@1.0.0 start
> node server.js

✓ SQL Lab Web UI corriendo en http://localhost:3000
📁 Data directory: /workspace/data
  📚 Labs disponibles:
     - 01-basics: SELECT y WHERE
     - 02-joins: JOINS y VIEWS
     - 03-aggregates: Funciones de Agregación
```

---

## Si Ve un Botón de Puerto

Codespaces detecta automáticamente que el puerto 3000 está abierto.

Verá un botón tipo:
```
http://localhost:3000
```

Click ahí → Se abre SQL Lab en navegador.

---

## Si Algo Falla

Si postCreateCommand falla, verá error en la terminal.

Solución:

1. Abre terminal nueva en Codespaces
2. Ejecuta manualmente:
   ```bash
   python3 init.py
   ```
3. Luego:
   ```bash
   cd web
   npm start
   ```

---

## Reiniciar Servidor

Si quieres reiniciar durante el desarrollo:

```bash
# En la terminal donde corre npm start:
# Presiona Ctrl+C

# Luego:
cd web
npm start
```

---

## Reinicializar BDs

Si quieres limpiar BDs y empezar de nuevo:

```bash
bash reset-dbs.sh
```

Luego reinicia el servidor:

```bash
cd web
npm start
```

---

## Archivos de Configuración

El automático está configurado en:

```
.devcontainer/devcontainer.json
  ├── postCreateCommand: python3 init.py
  └── postStartCommand: cd /workspace/web && npm start
```

Esos comandos se ejecutan automáticamente.

---

## Sin Intervención Manual

Todo está automatizado. Desde crear el Codespace hasta que veas http://localhost:3000 funcionando:

1. Crear Codespace
2. Esperar 3-5 minutos
3. Abre http://localhost:3000
4. Listo

Sin ejecutar ningún comando manualmente.
