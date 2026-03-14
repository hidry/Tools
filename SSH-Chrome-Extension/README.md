# SSH Manager – Chrome Extension

Eine Chrome Extension zum Verwalten und Aufbauen von SSH-Verbindungen direkt aus dem Browser.

## Features

- **Host-Verwaltung** – Hosts hinzufügen, bearbeiten und löschen (gespeichert in `chrome.storage.local`)
- **Suchfunktion** – schnelle Filterung der Host-Liste
- **In-Browser-Terminal** – vollwertiges SSH-Terminal mit xterm.js (256-Farben, Resize-Support)
- **Passwort-Authentifizierung** – Passwörter werden lokal im Browserprofil gespeichert
- **Deutsche Benutzeroberfläche**
- **Reconnect** – bei Verbindungsabbruch einfach erneut verbinden

## Voraussetzungen

1. **Chrome-Browser** (oder Chromium)
2. **Docker** – für die SSH-Bridge (einmalig starten)

## Setup

### 1. SSH-Bridge starten (Docker)

```bash
cd ssh-bridge
docker compose up -d
```

Die Bridge läuft dann dauerhaft im Hintergrund und startet automatisch mit Docker neu.

**Stoppen:**
```bash
docker compose down
```

### 2. Extension in Chrome laden

1. Chrome öffnen → `chrome://extensions/`
2. **Entwicklermodus** oben rechts aktivieren
3. **„Entpackte Erweiterung laden"** klicken
4. Den Ordner `SSH-Chrome-Extension/` auswählen

Das SSH-Symbol erscheint in der Chrome-Toolbar.

## Benutzung

### Host hinzufügen

1. Extension-Icon klicken → Popup öffnet sich
2. **＋** klicken
3. Felder ausfüllen:
   - **Bezeichnung** – eigener Name (z.B. „Produktions-Server")
   - **Hostname / IP** – Adresse des SSH-Servers
   - **Port** – Standard: `22`
   - **Benutzername** – SSH-Login
   - **Passwort** – Passwort (optional bei Key-Auth auf dem Server nicht nötig wenn leer gelassen)
4. **Speichern** klicken

### Verbinden

- **Verbinden** klicken → neuer Tab öffnet sich mit dem SSH-Terminal
- Tippen beginnen sobald der grüne Status „Verbunden" erscheint
- Tab schließen zum Trennen

### Einstellungen

Rechtsklick auf Extension → **Optionen** (oder Zahnrad-Icon im Popup):

- **Bridge-URL** anpassen (Standard: `ws://localhost:2222`)
- **Verbindung testen** prüft ob die Bridge erreichbar ist

## Netzwerk-Hinweise

Die Bridge im Docker-Container kann alle SSH-Server erreichen, die auch vom Host-System aus erreichbar sind.

**Lokale Netzwerk-Hosts (z.B. `192.168.x.x`):**

Unter **Linux**: In `docker-compose.yml` `network_mode: host` aktivieren (Zeile auskommentieren) – dann entfällt das Port-Mapping.

Unter **Windows/Mac** (Docker Desktop): Externe Hosts im Netz sind direkt erreichbar. Nur `localhost` des Host-Systems ist über `host.docker.internal` ansprechbar.

## Sicherheit

- Die Bridge hört **nur auf `127.0.0.1:2222`** (keine externe Erreichbarkeit)
- Passwörter werden **im Arbeitsspeicher** der Bridge gehalten und nicht gespeichert
- Verbindungsparameter werden **nur während der aktiven Session** in `chrome.storage.local` gehalten und nach Schließen des Tabs gelöscht
- Chrome-Browserprofil verschlüsselt den lokalen Speicher (OS-abhängig)

## Projektstruktur

```
SSH-Chrome-Extension/
├── manifest.json         Manifest V3
├── popup.html/css/js     Host-Verwaltung (Popup)
├── terminal.html/css/js  SSH-Terminal (xterm.js)
├── options.html/js       Einstellungen
├── background.js         Service Worker
├── lib/
│   ├── xterm.js          xterm.js v5
│   ├── xterm-addon-fit.js
│   └── xterm.css
└── icons/                Extension-Icons

ssh-bridge/
├── Dockerfile
├── docker-compose.yml
├── server.js             WebSocket → SSH Bridge (Node.js)
└── package.json
```
