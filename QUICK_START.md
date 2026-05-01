# SQL Lab - Quick Start

## Un Comando (Recomendado)

### Opción 1: Python (Más Portable)

```bash
python3 setup.py
```

Luego:
```bash
cd web
npm start
```

Abre: http://localhost:3000

### Opción 2: Bash (Solo Linux/Mac)

```bash
bash install.sh
```

---

## En GitHub Codespaces

Todo automático. Solo espera a que diga:

```
npm start
> SQL Lab Web UI corriendo en http://localhost:3000
```

Haz click en el puerto 3000.

---

## Si Algo Falla

```bash
# Verifica qué falta
python3 check-setup.py

# O reinstala todo
python3 setup.py
```

---

## Pasos Manuales (Si Prefieres)

```bash
# 1. Instalar dependencias
cd web
npm install
cd ..

# 2. Inicializar BDs
python3 setup.py

# 3. Arrancar
cd web
npm start
```

---

## Troubleshooting Rápido

```bash
# npm no instalado
sudo apt-get install nodejs npm

# sqlite3 no instalado
sudo apt-get install sqlite3

# Puerto 3000 en uso
PORT=3001 npm start
```

---

## Scripts Disponibles

| Script | Propósito | Tipo |
|--------|-----------|------|
| `setup.py` | Instalación completa (recomendado) | Python |
| `install.sh` | Instalación completa (bash) | Bash |
| `check-setup.py` | Verifica que todo esté bien | Python |
| `reset-dbs.sh` | Reinicializa BDs | Bash |
| `start.sh` | Arranca con verificación | Bash |

---

## En Codespaces - Solo

1. Espera `postCreateCommand`
2. Abre terminal nueva
3. Ejecuta `cd web && npm start`
4. Click puerto 3000
5. Listo

---

## Dirección Final

http://localhost:3000

Selecciona un lab. Listo!
