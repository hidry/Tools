# SSH Manager Bridge

WebSocket-to-SSH Bridge als Docker-Container für die [SSH Manager Chrome Extension](../SSH-Chrome-Extension/).

## Starten

```bash
docker compose up -d
```

## Stoppen

```bash
docker compose down
```

## Logs anzeigen

```bash
docker compose logs -f
```

## Konfiguration

| Umgebungsvariable | Standard | Beschreibung |
|---|---|---|
| `PORT` | `2222` | WebSocket-Port der Bridge |

Port anpassen in `docker-compose.yml`:
```yaml
ports:
  - "127.0.0.1:DEIN_PORT:2222"
environment:
  - PORT=2222
```

Dann Bridge-URL in den Extension-Einstellungen anpassen: `ws://localhost:DEIN_PORT`

## Protokoll

Die Bridge empfängt WebSocket-Verbindungen mit folgenden Query-Parametern:

| Parameter | Beschreibung |
|---|---|
| `host` | SSH-Hostname oder IP |
| `port` | SSH-Port (Standard: 22) |
| `user` | SSH-Benutzername |
| `pass` | SSH-Passwort (optional) |

Nachrichten vom Client:
- **Binär/Text** → direkt an SSH-Shell weitergeleitet
- **JSON `{"type":"resize","cols":N,"rows":N}`** → Terminal-Größe anpassen

Nachrichten an den Client:
- **Binär** → SSH-Ausgabe (Terminal-Daten)
- **JSON `{"type":"status","status":"connected"}`** → Verbindung aufgebaut
- **JSON `{"type":"error","message":"..."}`** → Fehler
