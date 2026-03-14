'use strict';

const { WebSocketServer } = require('ws');
const { Client }          = require('ssh2');
const { URL }             = require('url');

const PORT = parseInt(process.env.PORT || '2222', 10);

const wss = new WebSocketServer({ port: PORT });

console.log(`SSH Bridge läuft auf Port ${PORT}`);
console.log('Warte auf Verbindungen von der Chrome Extension…\n');

wss.on('connection', (ws, req) => {
  // ── Parse query params ───────────────────────────
  let params;
  try {
    params = new URL(req.url, `http://localhost`).searchParams;
  } catch {
    ws.close(1008, 'Ungültige URL');
    return;
  }

  const host = params.get('host');
  const port = parseInt(params.get('port') || '22', 10);
  const user = params.get('user');
  const pass = params.get('pass') || '';

  // Ping-Test (von options.js)
  if (params.get('ping') === '1') {
    ws.close(1000, 'pong');
    return;
  }

  if (!host || !user) {
    ws.close(1008, 'Fehlende Parameter: host oder user');
    return;
  }

  const label = `${user}@${host}:${port}`;
  console.log(`[+] Verbindungsversuch: ${label}`);

  // ── SSH Client ───────────────────────────────────
  const ssh = new Client();

  ssh.on('ready', () => {
    console.log(`[✓] SSH verbunden: ${label}`);
    ws.send(JSON.stringify({ type: 'status', status: 'connected' }));

    ssh.shell(
      { term: 'xterm-256color', cols: 80, rows: 24 },
      (err, stream) => {
        if (err) {
          console.error(`[!] Shell-Fehler: ${err.message}`);
          ws.send(JSON.stringify({ type: 'error', message: `Shell-Fehler: ${err.message}` }));
          ws.close();
          return;
        }

        // ── SSH → WebSocket ──────────────────────
        stream.on('data', (data) => {
          if (ws.readyState === ws.OPEN) {
            ws.send(data);
          }
        });

        stream.stderr.on('data', (data) => {
          if (ws.readyState === ws.OPEN) {
            ws.send(data);
          }
        });

        stream.on('close', () => {
          console.log(`[-] SSH-Shell geschlossen: ${label}`);
          ws.close(1000, 'SSH-Shell geschlossen');
        });

        // ── WebSocket → SSH ──────────────────────
        ws.on('message', (msg) => {
          // Try to parse resize message
          if (typeof msg === 'string' || Buffer.isBuffer(msg)) {
            const str = msg.toString();
            if (str.startsWith('{')) {
              try {
                const json = JSON.parse(str);
                if (json.type === 'resize' && json.cols && json.rows) {
                  stream.setWindow(json.rows, json.cols, 0, 0);
                  return;
                }
              } catch {
                // Not JSON → forward as-is
              }
            }
          }
          // Forward raw data to SSH
          if (stream.writable) {
            stream.write(msg);
          }
        });

        ws.on('close', () => {
          console.log(`[-] WebSocket getrennt: ${label}`);
          stream.close();
          ssh.end();
        });
      }
    );
  });

  ssh.on('error', (err) => {
    console.error(`[!] SSH-Fehler (${label}): ${err.message}`);
    if (ws.readyState === ws.OPEN) {
      ws.send(JSON.stringify({ type: 'error', message: err.message }));
      ws.close();
    }
  });

  // ── Connect ─────────────────────────────────────
  const connectConfig = {
    host,
    port,
    username: user,
    readyTimeout: 15000,
    keepaliveInterval: 30000,
  };

  if (pass) {
    connectConfig.password = pass;
  } else {
    // Try agent or keyboard-interactive as fallback
    connectConfig.tryKeyboard = true;
  }

  ssh.connect(connectConfig);

  ws.on('error', (err) => {
    console.error(`[!] WebSocket-Fehler: ${err.message}`);
    ssh.end();
  });
});

wss.on('error', (err) => {
  console.error(`[!!] Server-Fehler: ${err.message}`);
  process.exit(1);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('\nBridge wird beendet…');
  wss.close(() => process.exit(0));
});

process.on('SIGINT', () => {
  console.log('\nBridge wird beendet…');
  wss.close(() => process.exit(0));
});
