const bridgeUrlInput = document.getElementById('bridgeUrl');
const btnSave = document.getElementById('btnSave');
const btnTest = document.getElementById('btnTest');
const statusEl = document.getElementById('status');

function showStatus(msg, type) {
  statusEl.textContent = msg;
  statusEl.className = `status ${type}`;
  setTimeout(() => { statusEl.className = 'status'; }, 3000);
}

// Load saved settings
chrome.storage.local.get(['settings'], ({ settings }) => {
  bridgeUrlInput.value = settings?.bridgeUrl || 'ws://localhost:2222';
});

btnSave.addEventListener('click', () => {
  const bridgeUrl = bridgeUrlInput.value.trim() || 'ws://localhost:2222';
  chrome.storage.local.get(['settings'], ({ settings }) => {
    const updated = { ...(settings || {}), bridgeUrl };
    chrome.storage.local.set({ settings: updated }, () => {
      showStatus('Einstellungen gespeichert.', 'success');
    });
  });
});

btnTest.addEventListener('click', () => {
  const url = bridgeUrlInput.value.trim() || 'ws://localhost:2222';
  statusEl.textContent = 'Verbinde...';
  statusEl.className = 'status success';

  try {
    const ws = new WebSocket(url + '?ping=1');
    const timer = setTimeout(() => {
      ws.close();
      showStatus('Timeout – Bridge nicht erreichbar.', 'error');
    }, 4000);

    ws.onopen = () => {
      clearTimeout(timer);
      ws.close();
      showStatus('Verbindung erfolgreich!', 'success');
    };

    ws.onerror = () => {
      clearTimeout(timer);
      showStatus('Fehler – Bridge nicht erreichbar. Läuft docker compose up -d?', 'error');
    };
  } catch (e) {
    showStatus(`Ungültige URL: ${e.message}`, 'error');
  }
});
