const express = require('express');
const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static('public'));

// Rutas de datos
const WORKSPACE = process.env.WORKSPACE || '/workspace';
const DATA_DIR = path.join(WORKSPACE, 'data');
const LABS_DIR = path.join(WORKSPACE, 'labs');
const PROGRESS_FILE = path.join(WORKSPACE, '.progress.json');

// Metadatos de labs
const LABS = [
  { id: '01-basics', title: 'SELECT y WHERE', level: 'Principiante', duration: 10 },
  { id: '02-joins', title: 'JOINS y VIEWS', level: 'Intermedio', duration: 15 },
  { id: '03-aggregates', title: 'Funciones de Agregación', level: 'Intermedio-Avanzado', duration: 20 },
];

// Validaciones (replican check.sh)
const CHECKS = {
  '01-basics': [
    { desc: 'Tabla "departments" existe', sql: "SELECT name FROM sqlite_master WHERE type='table' AND name='departments'", expected: 'departments', hint: 'Usa CREATE TABLE departments (...)' },
    { desc: 'departments tiene 3 registros', sql: 'SELECT COUNT(*) FROM departments', expected: '3', hint: 'Debes tener 3 INSERT INTO' },
    { desc: "contiene 'Engineering'", sql: "SELECT COUNT(*) FROM departments WHERE name='Engineering'", expected: '1', hint: "Verifica ortografía: 'Engineering'" },
    { desc: "contiene 'Marketing'", sql: "SELECT COUNT(*) FROM departments WHERE name='Marketing'", expected: '1', hint: "Verifica ortografía: 'Marketing'" },
    { desc: "contiene 'HR'", sql: "SELECT COUNT(*) FROM departments WHERE name='HR'", expected: '1', hint: "Verifica ortografía: 'HR'" },
  ],
  '02-joins': [
    { desc: 'Vista "employee_report" existe', sql: "SELECT name FROM sqlite_master WHERE type='view' AND name='employee_report'", expected: 'employee_report', hint: 'Usa CREATE VIEW employee_report AS ...' },
    { desc: 'Vista tiene 3 columnas', sql: 'SELECT COUNT(*) FROM pragma_table_info("employee_report")', expected: '3', hint: 'Selecciona: name, dept, salary' },
  ],
  '03-aggregates': [
    { desc: 'Tabla "dept_summary" existe', sql: "SELECT name FROM sqlite_master WHERE type='table' AND name='dept_summary'", expected: 'dept_summary', hint: 'Usa CREATE TABLE dept_summary AS ...' },
    { desc: 'dept_summary tiene 4 columnas', sql: 'SELECT COUNT(*) FROM pragma_table_info("dept_summary")', expected: '4', hint: 'Columnas: dept_id, total_employees, avg_salary, max_salary' },
    { desc: 'dept_summary tiene 4 registros', sql: 'SELECT COUNT(*) FROM dept_summary', expected: '4', hint: 'Agrupa por departamento correctamente' },
    { desc: 'Engineering tiene 3 empleados', sql: 'SELECT total_employees FROM dept_summary WHERE dept_id=1', expected: '3', hint: 'Verifica el GROUP BY' },
  ],
};

// Helper: obtener DB
function getDatabase(labId) {
  const dbPath = path.join(DATA_DIR, `${labId}.db`);
  try {
    return new Database(dbPath);
  } catch (err) {
    throw new Error(`No se pudo abrir BD: ${dbPath}`);
  }
}

// Helper: leer progress.json
function getProgress() {
  try {
    if (fs.existsSync(PROGRESS_FILE)) {
      return JSON.parse(fs.readFileSync(PROGRESS_FILE, 'utf8'));
    }
  } catch (err) {
    console.error('Error leyendo progress:', err);
  }
  return { started: new Date().toISOString(), labs: {} };
}

// Helper: escribir progress.json
function saveProgress(data) {
  try {
    fs.writeFileSync(PROGRESS_FILE, JSON.stringify(data, null, 2), 'utf8');
  } catch (err) {
    console.error('Error guardando progress:', err);
  }
}

// ============ RUTAS API ============

// GET /api/labs - Lista de labs con estado
app.get('/api/labs', (req, res) => {
  const progress = getProgress();
  const labs = LABS.map(lab => ({
    ...lab,
    status: progress.labs[lab.id]?.status || 'pending',
  }));
  res.json(labs);
});

// GET /api/labs/:id/content - Instrucciones en Markdown
app.get('/api/labs/:id/content', (req, res) => {
  const filePath = path.join(LABS_DIR, req.params.id, 'instructions.md');
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    res.json({ content });
  } catch (err) {
    res.status(404).json({ error: 'Instrucciones no encontradas' });
  }
});

// POST /api/labs/:id/execute - Ejecutar SQL libre
app.post('/api/labs/:id/execute', (req, res) => {
  const { sql } = req.body;
  if (!sql || !sql.trim()) {
    return res.status(400).json({ error: 'SQL vacío' });
  }

  try {
    const db = getDatabase(req.params.id);
    const stmt = db.prepare(sql);
    const rows = stmt.all();
    db.close();
    res.json({ success: true, rows, count: rows.length });
  } catch (err) {
    res.status(400).json({ success: false, error: err.message });
  }
});

// POST /api/labs/:id/check - Ejecutar validaciones
app.post('/api/labs/:id/check', (req, res) => {
  const labId = req.params.id;
  const checks = CHECKS[labId];

  if (!checks) {
    return res.status(404).json({ error: 'Lab no encontrado' });
  }

  try {
    const db = getDatabase(labId);
    const results = checks.map(check => {
      try {
        const stmt = db.prepare(check.sql);
        const result = stmt.get();
        const actual = result ? Object.values(result)[0]?.toString() : '';
        const passed = actual === check.expected;
        return {
          desc: check.desc,
          passed,
          expected: check.expected,
          actual,
          hint: check.hint,
        };
      } catch (err) {
        return {
          desc: check.desc,
          passed: false,
          expected: check.expected,
          actual: `[Error: ${err.message}]`,
          hint: check.hint,
        };
      }
    });
    db.close();

    const allPassed = results.every(r => r.passed);
    const passCount = results.filter(r => r.passed).length;

    // Actualizar progress
    if (allPassed) {
      const progress = getProgress();
      if (!progress.labs[labId]) {
        progress.labs[labId] = {};
      }
      progress.labs[labId].status = 'completed';
      progress.labs[labId].completed_at = new Date().toISOString();
      if (!progress.labs[labId].attempts) {
        progress.labs[labId].attempts = 0;
      }
      progress.labs[labId].attempts++;
      saveProgress(progress);
    }

    res.json({
      success: allPassed,
      results,
      summary: `${passCount}/${results.length} validaciones pasadas`,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/progress - Leer progress
app.get('/api/progress', (req, res) => {
  res.json(getProgress());
});

// PUT /api/progress/:id - Actualizar progreso de un lab
app.put('/api/progress/:id', (req, res) => {
  const { status, duration_min } = req.body;
  const progress = getProgress();

  if (!progress.labs[req.params.id]) {
    progress.labs[req.params.id] = {};
  }

  if (status) progress.labs[req.params.id].status = status;
  if (duration_min) progress.labs[req.params.id].duration_min = duration_min;

  saveProgress(progress);
  res.json({ success: true, lab: progress.labs[req.params.id] });
});

// ============ SERVIDOR ============

app.listen(PORT, () => {
  console.log(`\n✅ SQL Lab Web UI corriendo en http://localhost:${PORT}`);
  console.log(`📁 Data directory: ${DATA_DIR}`);
  console.log(`\n🧪 Labs disponibles:`);
  LABS.forEach(lab => console.log(`   - ${lab.id}: ${lab.title}`));
});
