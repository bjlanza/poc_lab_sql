// Inicialización de Monaco Editor
let monacoEditor = null;

// Cargar librería AMD de Monaco
require.config({ paths: { vs: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.50.0/min/vs' } });

require(['vs/editor/editor.main'], function() {
  // Tema oscuro personalizado
  monaco.editor.defineTheme('sql-lab-dark', {
    base: 'vs-dark',
    inherit: true,
    rules: [
      { token: 'keyword', foreground: '569cd6' },
      { token: 'string', foreground: 'ce9178' },
      { token: 'comment', foreground: '6a9955', fontStyle: 'italic' },
      { token: 'number', foreground: 'b5cea8' },
    ],
    colors: {
      'editor.background': '#0f3460',
      'editor.foreground': '#e0e0e0',
      'editor.lineNumbersColumn.background': '#16213e',
      'editorCursor.foreground': '#00b4d8',
      'editor.selectionBackground': 'rgba(0, 180, 216, 0.3)',
      'editor.lineHighlightBackground': 'rgba(0, 180, 216, 0.1)',
    },
  });

  // Crear el editor
  monacoEditor = monaco.editor.create(document.getElementById('editor'), {
    value: '-- Escribe tu SQL aquí\nSELECT * FROM employees LIMIT 5;',
    language: 'sql',
    theme: 'sql-lab-dark',
    automaticLayout: true,
    minimap: { enabled: false },
    fontSize: 13,
    fontFamily: '"Monaco", "Menlo", "Ubuntu Mono", monospace',
    tabSize: 2,
    insertSpaces: true,
    wordWrap: 'on',
    lineNumbers: 'on',
    scrollBeyondLastLine: false,
    smoothScrolling: true,
    scrollbar: {
      vertical: 'auto',
      horizontal: 'auto',
    },
  });

  // Keybindings personalizados
  monacoEditor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.Enter, function() {
    const executeBtn = document.getElementById('executeBtn');
    if (executeBtn) executeBtn.click();
  });

  // Evento para saber cuando el editor está listo
  window.monacoReady = true;
  window.dispatchEvent(new Event('monacoReady'));
});

// Helper para obtener SQL del editor
function getSQLCode() {
  if (monacoEditor) {
    return monacoEditor.getValue();
  }
  return '';
}

// Helper para setear SQL en el editor
function setSQLCode(code) {
  if (monacoEditor) {
    monacoEditor.setValue(code);
  }
}

// Helper para limpiar el editor
function clearEditor() {
  setSQLCode('-- Escribe tu SQL aquí\n');
}
