// UI Rendering y helpers

const UI = {
  // Renderizar lista de labs en sidebar
  renderLabsList: async (labs) => {
    const labsList = document.getElementById('labsList');
    labsList.innerHTML = '';

    for (const lab of labs) {
      const item = document.createElement('button');
      item.className = 'lab-item';
      item.dataset.labId = lab.id;

      const badge = UI.getStatusBadge(lab.status);

      item.innerHTML = `
        <span class="lab-item-title">${lab.id.split('-')[1].toUpperCase()}</span>
        <span class="lab-item-badge">${badge}</span>
      `;

      item.title = `${lab.title} (${lab.level}, ${lab.duration} min)`;

      item.addEventListener('click', () => {
        // Cambiar active
        document.querySelectorAll('.lab-item').forEach(el => el.classList.remove('active'));
        item.classList.add('active');

        // Cargar lab
        window.loadLab(lab.id);
      });

      labsList.appendChild(item);
    }
  },

  // Renderizar header con nav de labs
  renderHeaderNav: (labs) => {
    const headerNav = document.getElementById('headerNav');
    headerNav.innerHTML = '';

    for (const lab of labs) {
      const btn = document.createElement('button');
      btn.className = 'nav-btn';
      btn.dataset.labId = lab.id;
      btn.textContent = lab.id.replace('-', ' ').toUpperCase();

      btn.addEventListener('click', () => {
        // Activar en sidebar
        document.querySelectorAll('.lab-item').forEach(el => {
          if (el.dataset.labId === lab.id) el.classList.add('active');
          else el.classList.remove('active');
        });
        document.querySelectorAll('.nav-btn').forEach(el => el.classList.remove('active'));
        btn.classList.add('active');

        // Cargar lab
        window.loadLab(lab.id);
      });

      headerNav.appendChild(btn);
    }
  },

  // Renderizar instrucciones en Markdown
  renderInstructions: (markdown) => {
    const panel = document.getElementById('instructionsPanel');
    const html = marked.parse(markdown);
    panel.innerHTML = html;

    // Agregar botones de hints a cada h3 (tarea)
    const taskElements = panel.querySelectorAll('h3');
    taskElements.forEach((h3, index) => {
      const taskId = index + 1;
      const hintBtn = document.createElement('button');
      hintBtn.className = 'hint-btn';
      hintBtn.textContent = 'Pedir ayuda';
      hintBtn.dataset.taskId = taskId;
      hintBtn.dataset.currentLevel = 1;
      hintBtn.addEventListener('click', () => UI.requestHint(taskId));

      const hintDiv = document.createElement('div');
      hintDiv.className = 'hint-display';
      hintDiv.style.display = 'none';
      hintDiv.dataset.taskId = taskId;

      h3.parentNode.insertBefore(hintBtn, h3.nextSibling);
      h3.parentNode.insertBefore(hintDiv, hintBtn.nextSibling);
    });
  },

  // Solicitar hint progresivo
  requestHint: async (taskId) => {
    const labId = window.currentLab;
    const hintBtn = document.querySelector(`button[data-taskId="${taskId}"]`);
    const hintDiv = document.querySelector(`div[data-taskId="${taskId}"]`);

    if (!hintBtn || !hintDiv) return;

    const currentLevel = parseInt(hintBtn.dataset.currentLevel) || 1;

    try {
      const res = await fetch(`/api/labs/${labId}/hints/${taskId}/${currentLevel}`);
      const data = await res.json();

      if (data.error) {
        hintDiv.innerHTML = `<div class="hint-error">Error: ${data.error}</div>`;
      } else {
        hintDiv.innerHTML = `<div class="hint-content">${data.hint}</div>`;
        hintDiv.style.display = 'block';

        const nextLevel = data.nextLevel || data.maxLevel;
        hintBtn.dataset.currentLevel = nextLevel;

        // Guardar en localStorage
        window.saveHintsState(labId, taskId, nextLevel);

        if (!data.canAskMore) {
          hintBtn.disabled = true;
          hintBtn.textContent = 'Sin mas ayuda';
          hintBtn.style.opacity = '0.5';
        } else {
          hintBtn.textContent = `Mas ayuda (${data.level}/${data.maxLevel})`;
        }
      }
    } catch (err) {
      hintDiv.innerHTML = `<div class="hint-error">Error al cargar hint: ${err.message}</div>`;
      hintDiv.style.display = 'block';
    }
  },

  // Renderizar metadata del lab
  renderLabMeta: (lab) => {
    const meta = document.getElementById('labMeta');
    meta.textContent = `${lab.level} • ${lab.duration} minutos`;
  },

  // Renderizar título del lab
  renderLabTitle: (lab) => {
    const title = document.getElementById('labTitle');
    title.textContent = lab.title;
  },

  // Renderizar resultados (tabla o error)
  renderResults: (data) => {
    const panel = document.getElementById('resultsPanel');

    if (data.error) {
      panel.innerHTML = `<div class="error-message">❌ Error: ${data.error}</div>`;
      return;
    }

    if (!data.rows || data.rows.length === 0) {
      panel.innerHTML = '<div class="info-message">ℹ️ Consulta ejecutada sin resultados</div>';
      return;
    }

    // Crear tabla
    const rows = data.rows;
    const columns = rows.length > 0 ? Object.keys(rows[0]) : [];

    let html = `
      <div class="success-message">✅ ${rows.length} fila(s) retornada(s)</div>
      <table class="results-table">
        <thead>
          <tr>
            ${columns.map(col => `<th>${col}</th>`).join('')}
          </tr>
        </thead>
        <tbody>
          ${rows.map(row => `
            <tr>
              ${columns.map(col => `<td>${row[col] ?? 'NULL'}</td>`).join('')}
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;

    panel.innerHTML = html;
  },

  // Renderizar validaciones
  renderValidation: (results) => {
    const panel = document.getElementById('validationPanel');
    const section = document.getElementById('validationSection');

    let allPassed = true;
    let html = '';

    for (const result of results) {
      const passed = result.passed;
      if (!passed) allPassed = false;

      const icon = passed ? '✅' : '❌';
      const className = passed ? 'pass' : 'fail';

      html += `
        <div class="check-item ${className}">
          <div class="check-item-title">
            ${icon} ${result.desc}
          </div>
          ${!passed ? `
            <div class="check-item-details">
              <strong>Esperado:</strong> ${result.expected}<br>
              <strong>Obtenido:</strong> ${result.actual}
            </div>
            <div class="check-item-hint">💡 ${result.hint}</div>
          ` : ''}
        </div>
      `;
    }

    panel.innerHTML = html;
    section.style.display = 'flex';

    // Si todas pasan, mostrar success
    if (allPassed) {
      const summary = document.createElement('div');
      summary.className = 'success-message';
      summary.style.marginBottom = 'var(--spacing-lg)';
      summary.innerHTML = '🎉 ¡Todas las validaciones pasaron! Puedes pasar al siguiente lab.';
      panel.insertBefore(summary, panel.firstChild);
    }
  },

  // Badge de estado
  getStatusBadge: (status) => {
    const badges = {
      completed: '✅',
      in_progress: '🔵',
      pending: '⬜',
    };
    return badges[status] || '⬜';
  },

  // Mostrar loading
  showLoading: (message = 'Cargando...') => {
    const panel = document.getElementById('resultsPanel');
    panel.innerHTML = `<div class="info-message">${message}</div>`;
  },

  // Limpiar resultados
  clearResults: () => {
    const panel = document.getElementById('resultsPanel');
    panel.innerHTML = '<p class="placeholder">Ejecuta una consulta para ver resultados</p>';
  },

  // Limpiar validación
  clearValidation: () => {
    const section = document.getElementById('validationSection');
    const panel = document.getElementById('validationPanel');
    section.style.display = 'none';
    panel.innerHTML = '';
  },
};

// Exportar para acceso global
window.UI = UI;
