# Scripts de Verificación y Diagnóstico

Tres scripts para verificar y diagnosticar problemas con SQL Lab.

## 1. check-setup.py (Recomendado)

Script Python que verifica todo automáticamente.

```bash
python3 check-setup.py
```

Qué verifica:
- Estructura de carpetas (labs, web, .devcontainer)
- Archivos necesarios en cada lab (instructions.md, hints.json, etc)
- Validez de JSON (hints.json, package.json)
- Node.js instalado
- SQLite instalado
- node_modules existe

Salida:
```
✓ Carpeta 'labs' existe
✓ Lab '01-basics' existe
✓ Lab '02-joins' existe
✓ Lab '03-aggregates' existe
✓ Node.js instalado: v18.16.0
✓ SQLite instalado: 3.42.0
```

O si hay problemas:
```
✗ node_modules NO existe
! Ejecuta: cd web && npm install
```

---

## 2. verify.sh (Detallado)

Script Bash con verificación más exhaustiva.

```bash
bash verify.sh
```

Qué verifica:
- Estructura de carpetas
- Archivos de cada lab
- Validez de JSON
- Node.js y npm
- Archivos públicos (HTML, CSS, JS)
- Puerto 3000 disponible
- SQLite
- BDs en /workspace/data
- .gitignore correcto

Salida:
```
1. Estructura de carpetas
✓ Carpeta 'labs' existe
✓ Carpeta '.devcontainer' existe
✓ Carpeta 'web' existe

2. Labs
✓ Lab '01-basics' existe
  ✓ instructions.md existe
  ✓ init.sql existe
  ✓ check.sh existe
  ✓ hints.json existe
...

=== RESUMEN ===
Errores: 0
Advertencias: 2
```

---

## 3. start.sh (Startup Automático)

Script que arranca el servidor con verificaciones previas.

```bash
bash start.sh
```

Qué hace:
1. Verifica estructura básica
2. Instala npm si no existen dependencias
3. Inicializa BDs si no existen
4. Verifica que puerto 3000 esté disponible
5. Arranca el servidor

Salida:
```
=== SQL Lab Startup ===

Verificando estructura...
OK Estructura encontrada

Instalando dependencias npm...
OK Dependencias instaladas

Inicializando bases de datos...
OK BDs inicializadas

=== Iniciando SQL Lab ===

Servidor en http://localhost:3000
Presiona Ctrl+C para detener
```

---

## Flujo Recomendado

1. Ejecuta `python3 check-setup.py` para diagnóstico rápido
2. Si hay errores, revisa STARTUP.md para soluciones
3. Una vez todo esté OK, usa `bash start.sh` para arrancar

---

## Cambiar Puerto

```bash
PORT=3001 bash start.sh
```

---

## Arreglar Manualmente

Si quieres hacerlo paso a paso:

```bash
# 1. Instalar dependencias
cd web
npm install
cd ..

# 2. Inicializar BDs
bash .devcontainer/setup.sh

# 3. Arrancar servidor
cd web
npm start

# En otra terminal, verifica:
http://localhost:3000
```

---

## En Codespaces

Todo es automático. Solo abre el puerto 3000 en el navegador.

Si algo falla:
```bash
# Ejecuta verificación
python3 check-setup.py

# O reinicia todo
bash .devcontainer/setup.sh
bash start.sh
```

---

## Resumen de Archivos

| Archivo | Propósito | Tipo |
|---------|-----------|------|
| check-setup.py | Verificación rápida | Python |
| verify.sh | Verificación exhaustiva | Bash |
| start.sh | Startup automático | Bash |
| STARTUP.md | Guía de troubleshooting | Documentación |
| SCRIPTS.md | Este archivo | Documentación |

---

## Debugging

Si algo no funciona:

1. Ejecuta `python3 check-setup.py`
2. Lee el output cuidadosamente
3. Busca "Error" o "NO existe"
4. Lee STARTUP.md para la solución

Si la web arranca pero no funciona:
1. Abre DevTools (F12)
2. Revisa Console y Network
3. Revisa terminal donde corre `npm start`

Errores comunes:
- Module not found: ejecuta `cd web && npm install`
- Port in use: usa `PORT=3001 bash start.sh`
- BD not found: ejecuta `bash .devcontainer/setup.sh`
