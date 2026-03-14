// ── DOM Refs ──────────────────────────────────────────
const statusBar    = document.getElementById('statusBar');
const statusIcon   = document.getElementById('statusIcon');
const statusText   = document.getElementById('statusText');
const connInfoEl   = document.getElementById('connInfo');
const btnReconnect = document.getElementById('btnReconnect');
const btnClose     = document.getElementById('btnClose');
const termContainer = document.getElementById('terminal');

// ── xterm.js Setup ────────────────────────────────────
const term = new Terminal({
  cursorBlink: true,
  fontFamily: "'Cascadia Code', 'Fira Code', 'Courier New', monospace",
  fontSize: 14,
  lineHeight: 1.2,
  theme: {
    background:   '#0d0d0d',
    foreground:   '#c9d1d9',
    cursor:       '#58a6ff',
    cursorAccent: '#0d0d0d',
    black:        '#484f58',
    red:          '#ff7b72',
    green:        '#3fb950',
    yellow:       '#d29922',
    blue:         '#58a6ff',
    magenta:      '#bc8cff',
    cyan:         '#39c5cf',
    white:        '#b1bac4',
    brightBlack:  '#6e7681',
    brightRed:    '#ffa198',
    brightGreen:  '#56d364',
    brightYellow: '#e3b341',
    brightBlue:   '#79c0ff',
    brightMagenta:'#d2a8ff',
    brightCyan:   '#56d4dd',
    brightWhite:  '#f0f6fc',
  }
});

const fitAddon = new FitAddon.FitAddon();
term.loadAddon(fitAddon);
term.open(termContainer);

function fitTerminal() {
  fitAddon.fit();
  if (ws && ws.readyState === WebSocket.OPEN) {
    ws.send(JSON.stringify({ type: 'resize', cols: term.cols, rows: term.rows }));
  }
}

window.addEventListener('resize', fitTerminal);

// ── Connection State ──────────────────────────────────
let ws = null;
let hostConfig = null;
let connId = null;
let reconnectTimer = null;

// ── Read Connection Params ────────────────────────────
const params = new URLSearchParams(window.location.search);
connId = params.get('id');

if (!connId) {
  setStatus('error', '✕', 'Kein Verbindungs-ID angegeben.');
} else {
  chrome.storage.local.get([connId, 'settings'], (result) => {
    hostConfig = result[connId];
    const settings = result.settings || {};

    // Clean up after reading (password no longer needed in storage after connect)
    // Keep it for reconnect functionality; remove on tab close via beforeunload
    if (!hostConfig) {
      setStatus('error', '✕', 'Verbindungsdaten nicht gefunden.');
      return;
    }

    const bridgeUrl = settings.bridgeUrl || 'ws://localhost:2222';
    document.title = `SSH – ${hostConfig.username}@${hostConfig.host}`;
    connInfoEl.textContent = `${hostConfig.username}@${hostConfig.host}:${hostConfig.port}`;

    fitTerminal();
    connect(bridgeUrl);
  });
}

// ── Cleanup on Tab Close ──────────────────────────────
window.addEventListener('beforeunload', () => {
  if (connId) chrome.storage.local.remove([connId]);
});

// ── WebSocket Connection ──────────────────────────────
function connect(bridgeUrl) {
  setStatus('connecting', '⟳', 'Verbinde…');
  btnReconnect.style.display = 'none';

  const url = buildWsUrl(bridgeUrl, hostConfig);

  try {
    ws = new WebSocket(url);
    ws.binaryType = 'arraybuffer';
  } catch (e) {
    setStatus('error', '✕', `Ungültige Bridge-URL: ${e.message}`);
    return;
  }

  ws.onopen = () => {
    setStatus('connected', '✓', 'Verbunden');
    term.focus();
    fitTerminal();
    // Clear any previous terminal content on reconnect
  };

  ws.onmessage = (event) => {
    if (typeof event.data === 'string') {
      // JSON control message from bridge
      try {
        const msg = JSON.parse(event.data);
        if (msg.type === 'error') {
          setStatus('error', '✕', `Fehler: ${msg.message}`);
          term.writeln(`\r\n\x1b[31m[SSH-Fehler] ${msg.message}\x1b[0m\r\n`);
          btnReconnect.style.display = '';
        } else if (msg.type === 'status' && msg.status === 'connected') {
          setStatus('connected', '✓', 'Verbunden');
        }
      } catch {
        // Plain text
        term.write(event.data);
      }
    } else {
      // Binary terminal data
      term.write(new Uint8Array(event.data));
    }
  };

  ws.onclose = (event) => {
    if (event.code === 1000 || event.code === 1001) {
      setStatus('disconnected', '○', 'Verbindung getrennt');
    } else {
      setStatus('disconnected', '○', `Verbindung getrennt (${event.code})`);
    }
    term.writeln('\r\n\x1b[33m[Verbindung getrennt]\x1b[0m\r\n');
    btnReconnect.style.display = '';
    ws = null;
  };

  ws.onerror = () => {
    setStatus('error', '✕', 'Bridge nicht erreichbar – läuft der Docker-Container?');
    term.writeln('\r\n\x1b[31m[Verbindungsfehler] SSH-Bridge nicht erreichbar.\x1b[0m');
    term.writeln('\x1b[90mStarte die Bridge mit: cd ssh-bridge && docker compose up -d\x1b[0m\r\n');
    btnReconnect.style.display = '';
  };
}

// ── Terminal Input → WebSocket ────────────────────────
term.onData((data) => {
  if (ws && ws.readyState === WebSocket.OPEN) {
    ws.send(data);
  }
});

// ── Buttons ───────────────────────────────────────────
btnClose.addEventListener('click', () => {
  if (ws) ws.close(1000);
  window.close();
});

btnReconnect.addEventListener('click', () => {
  if (ws) ws.close();
  term.clear();
  chrome.storage.local.get(['settings'], ({ settings }) => {
    const bridgeUrl = settings?.bridgeUrl || 'ws://localhost:2222';
    connect(bridgeUrl);
  });
});

// ── Helpers ───────────────────────────────────────────
function buildWsUrl(bridgeUrl, cfg) {
  // Append query params (password in URL is OK for localhost-only bridge)
  const base = bridgeUrl.replace(/\/$/, '');
  const p = new URLSearchParams({
    host: cfg.host,
    port: cfg.port,
    user: cfg.username,
    pass: cfg.password || ''
  });
  return `${base}?${p.toString()}`;
}

function setStatus(type, icon, text) {
  statusBar.className = `status-bar status-${type}`;
  statusIcon.textContent = icon;
  statusText.textContent = text;
}
