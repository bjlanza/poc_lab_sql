# SQL Lab - Setup Simple

## Instalación (Primer Uso)

```bash
bash init
```

Espera a que termine.

## Arrancar Servidor

```bash
cd web
npm start
```

Abre: http://localhost:3000

---

## Verificar

```bash
bash check
```

Muestra qué está bien/mal.

---

## Si No Funcionan los Labs

En navegador, abre F12 (DevTools) y mira Console.

Si ves error de fetch a `/api/labs`:
- El servidor no está corriendo
- O está en otro puerto

Solución:
```bash
# Terminal 1: Instalar
bash init

# Terminal 2: Arrancar
cd web
npm start

# Terminal 3: Verificar
bash check
```

---

## En Codespaces

Todo automático. Solo espera a que termine setup y abre http://localhost:3000

---

## Scripts Disponibles

- `init` - Instala todo
- `check` - Verifica estado
- `reset-dbs.sh` - Reinicializa BDs
- `lab-runner.sh` - CLI interactivo

---

## Problemas Rápidos

| Problema | Solución |
|----------|----------|
| npm not found | `bash init` |
| No aparecen labs | F12 → Console → busca error → `bash check` |
| Port 3000 in use | `PORT=3001 npm start` |
| BDs not found | `bash init` |

---

## Eso es todo.
