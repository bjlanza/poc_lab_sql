// Aplicación principal

let currentLab = null;
let allLabs = [];

// ============ INICIALIZACIÓN ============

document.addEventListener('DOMContentLoaded', async () => {
  // Esperar a Monaco
  if (!window.monacoReady) {
    await new Promise(resolve => window.addEventListener('monacoReady', resolve));
  }

  // Cargar labs
  await loadAllLabs();

  // Event listeners
  setupEventListeners();

  // Cargar primer lab por defecto
  if (allLabs.length > 0) {
    window.loadLab(allLabs[0].id);
  }
});

// ============ API CALLS ============

async function loadAllLabs() {
  try {
    console.log('Cargando labs desde /api/labs...');
    const response = await fetch('/api/labs');

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    allLabs = await response.json();
    console.log('Labs cargados:', allLabs);

    if (!allLabs || allLabs.length === 0) {
      console.error('No hay labs!');
      document.getElementById('instructionsPanel').innerHTML =
        '<p style="color:red;">Error: No se cargaron los labs. Revisa la consola.</p>';
      return;
    }

    // Renderizar UI
    window.UI.renderLabsList(allLabs);
    window.UI.renderHeaderNav(allLabs);
  } catch (err) {
    console.error('Error cargando labs:', err);
    document.getElementById('instructionsPanel').innerHTML =
      `<p style="color:red;">Error cargando labs: ${err.message}</p>`;
  }
}

async function loadLab(labId) {
  try {
    // Obtener metadata del lab
    const lab = allLabs.find(l => l.id === labId);
    if (!lab) return;

    currentLab = labId;

    // Cargar instrucciones
    const response = await fetch(`/api/labs/${labId}/content`);
    const { content } = await response.json();

    // Renderizar UI
    window.UI.renderLabTitle(lab);
    window.UI.renderLabMeta(lab);
    window.UI.renderInstructions(content);
    window.UI.clearResults();
    window.UI.clearValidation();

    // Restaurar estado de hints desde localStorage
    restoreHintsState(labId);

    // Limpiar y resetear editor
    setSQLCode('-- Escribe tu SQL aquí\n');

    // Actualizar nav
    document.querySelectorAll('.nav-btn').forEach(btn => {
      if (btn.dataset.labId === labId) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });
  } catch (err) {
    console.error('Error cargando lab:', err);
    document.getElementById('resultsPanel').innerHTML = `<div class="error-message">Error cargando lab: ${err.message}</div>`;
  }
}

async function executeSql() {
  if (!currentLab) {
    alert('Selecciona un lab primero');
    return;
  }

  const sql = getSQLCode().trim();
  if (!sql) {
    alert('Escribe una consulta SQL');
    return;
  }

  window.UI.showLoading('Ejecutando consulta...');

  try {
    const response = await fetch(`/api/labs/${currentLab}/execute`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ sql }),
    });

    const data = await response.json();
    window.UI.renderResults(data);
  } catch (err) {
    window.UI.renderResults({ error: err.message });
  }
}

async function checkLab() {
  if (!currentLab) {
    alert('Selecciona un lab primero');
    return;
  }

  window.UI.showLoading('Verificando solución...');

  try {
    const response = await fetch(`/api/labs/${currentLab}/check`, {
      method: 'POST',
    });

    const data = await response.json();

    if (data.results) {
      window.UI.renderValidation(data.results);
    }

    // Mostrar resumen en resultados
    const summary = `<div class="${data.success ? 'success-message' : 'error-message'}">
      ${data.summary}
    </div>`;

    const panel = document.getElementById('resultsPanel');
    panel.innerHTML = summary + panel.innerHTML;
  } catch (err) {
    window.UI.renderValidation([]);
    window.UI.showLoading();
  }
}

// ============ EVENT LISTENERS ============

function setupEventListeners() {
  // Botón ejecutar SQL
  document.getElementById('executeBtn').addEventListener('click', executeSql);

  // Botón verificar
  document.getElementById('checkBtn').addEventListener('click', checkLab);

  // Botón limpiar resultados
  document.getElementById('clearResultsBtn').addEventListener('click', () => {
    window.UI.clearResults();
  });

  // Botón resetear
  document.getElementById('resetBtn').addEventListener('click', async () => {
    if (confirm('¿Resetear todas las bases de datos? Se perderán los cambios locales.')) {
      try {
        // Llamar al backend para resetear
        const response = await fetch('/api/labs/reset', { method: 'POST' });
        if (response.ok) {
          alert('✅ BDs reseteadas');
          // Recargar la página
          location.reload();
        }
      } catch (err) {
        alert('Error al resetear: ' + err.message);
      }
    }
  });

  // Toggle de validación
  document.getElementById('toggleValidationBtn').addEventListener('click', () => {
    const section = document.getElementById('validationSection');
    const btn = document.getElementById('toggleValidationBtn');
    if (section.style.display === 'flex') {
      section.style.display = 'none';
      btn.textContent = '+';
    } else {
      section.style.display = 'flex';
      btn.textContent = '−';
    }
  });
}

// ============ HINTS STATE MANAGEMENT ============

function saveHintsState(labId, taskId, level) {
  const key = `hints_${labId}_${taskId}`;
  localStorage.setItem(key, level);
}

function getHintLevel(labId, taskId) {
  const key = `hints_${labId}_${taskId}`;
  return parseInt(localStorage.getItem(key)) || 1;
}

function restoreHintsState(labId) {
  // Restaurar estado de todos los botones de hints
  setTimeout(() => {
    const buttons = document.querySelectorAll('.hint-btn');
    buttons.forEach(btn => {
      const taskId = btn.dataset.taskId;
      const savedLevel = getHintLevel(labId, taskId);

      if (savedLevel > 1) {
        btn.dataset.currentLevel = savedLevel;
        // Recargar el hint último
        if (savedLevel > 1) {
          window.UI.requestHint(taskId);
        }
      }
    });
  }, 100);
}

// ============ GLOBALS (para acceso desde HTML/evento) ============

window.loadLab = loadLab;
window.getSQLCode = getSQLCode;
window.setSQLCode = setSQLCode;
window.clearEditor = clearEditor;
window.saveHintsState = saveHintsState;
window.getHintLevel = getHintLevel;
