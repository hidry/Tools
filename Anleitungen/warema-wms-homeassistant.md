# Warema WMS Integration in Home Assistant
## Steuerung von Warema Verdunklungen und Markisen mit dem WMS USB-Stick

---

## Übersicht

Diese Anleitung beschreibt die vollständige Integration von Warema WMS-Geräten (Verdunklungen, Markisen, Raffstores) in Home Assistant über den **Warema WMS USB-Stick** (Standard-Version).

### Was wird benötigt?

- **Hardware:**
  - Warema WMS USB-Stick (Standard-Version, nicht WebControl Pro)
  - USB-Verlängerungskabel (3-5m empfohlen, USB 2.0!)
  - Warema WMS-Geräte (Verdunklungen, Markisen, etc.)
  - Warema WMS-Fernbedienung (für Netzwerkparameter-Auslese)

- **Software:**
  - Home Assistant (installiert auf Proxmox, Raspberry Pi, etc.)
  - MQTT Broker (Mosquitto)
  - Warema WMS Home Assistant Addon

### Architektur

```
WMS Stick (USB) ──→ Home Assistant Addon ──→ MQTT Broker ──→ Home Assistant Entities
                                                                         ↓
                                                                 Automatisierungen
```

### Wichtige Hinweise vorab

⚠️ **USB3-Interferenz:** USB3-Ports können das 2.4 GHz-Funksignal stören!
→ Verwende **USB 2.0-Port** oder ein **USB-Verlängerungskabel** (empfohlen)

⚠️ **Reichweite:** Der WMS Stick hat keine externe Antenne
→ Zentrale Position im Haus wählen (USB-Verlängerung nutzen!)

⚠️ **Mesh-Netzwerk:** Die Mesh-Funktion funktioniert bei direkter Steuerung über den Stick oft nicht zuverlässig
→ Direkte Funkverbindung zu allen Geräten sollte möglich sein

---

## Phase 1: Voraussetzungen prüfen

### 1.1 Proxmox: USB-Stick identifizieren

Verbinde den WMS Stick mit dem Proxmox-Host und identifiziere ihn:

```bash
# Auf dem Proxmox-Host
lsusb
```

Suche nach einem Eintrag wie:
```
Bus 001 Device 005: ID 0403:6001 Future Technology Devices International, Ltd FT232 Serial (UART) IC
```

**Wichtig:** Notiere `Bus` und `Device` (z.B. `001:005`)

### 1.2 Proxmox: USB-Passthrough zur HA-VM einrichten

1. **In Proxmox Web-UI:**
   - VM auswählen → Hardware → Add → USB Device
   - "Use USB Vendor/Device ID" wählen
   - Device auswählen (z.B. `0403:6001`)
   - Hinzufügen

2. **VM neu starten:**
   ```bash
   # Auf dem Proxmox-Host
   qm stop <VM-ID>
   qm start <VM-ID>
   ```

3. **In Home Assistant prüfen:**
   ```bash
   # In Home Assistant (z.B. über Terminal & SSH Addon)
   ls -l /dev/ttyUSB*
   ```

   Erwartete Ausgabe:
   ```
   crw-rw---- 1 root dialout 188, 0 Jan  1 10:00 /dev/ttyUSB0
   ```

   ✅ Falls `/dev/ttyUSB0` existiert → USB-Passthrough erfolgreich!

---

## Phase 2: MQTT Broker installieren (falls nicht vorhanden)

### 2.1 Mosquitto Broker Addon installieren

1. **In Home Assistant:**
   - Settings → Add-ons → Add-on Store
   - Suche nach "Mosquitto broker"
   - Install

2. **Mosquitto Broker konfigurieren:**
   - Configuration-Tab:
   ```yaml
   logins: []
   require_certificate: false
   certfile: fullchain.pem
   keyfile: privkey.pem
   customize:
     active: false
     folder: mosquitto
   ```

3. **Broker starten:**
   - Start
   - "Start on boot" aktivieren

4. **MQTT-Integration hinzufügen:**
   - Settings → Devices & Services → Add Integration
   - Suche "MQTT"
   - Server: `localhost` (oder `core-mosquitto`)
   - Port: `1883`
   - Username/Password: (leer lassen für lokalen Zugriff)
   - Submit

### 2.2 MQTT-User erstellen (empfohlen)

Für bessere Sicherheit einen dedizierten User anlegen:

1. **Mosquitto Broker Addon → Configuration:**
   ```yaml
   logins:
     - username: warema
       password: <dein-sicheres-passwort>
   ```

2. **Addon neu starten**

3. **Credentials notieren** für später!

---

## Phase 3: Warema WMS Addon installieren

### 3.1 Custom Repository hinzufügen

Das Warema WMS Addon ist nicht im offiziellen Add-on Store, sondern muss als Custom Repository hinzugefügt werden.

1. **In Home Assistant:**
   - Settings → Add-ons → Add-on Store
   - Drei-Punkte-Menü (oben rechts) → Repositories

2. **Repository URL hinzufügen:**
   ```
   https://github.com/santam85/addon-warema-wms
   ```

3. **Seite neu laden** (F5)

### 3.2 Warema WMS Addon installieren

1. **Im Add-on Store:**
   - Suche nach "Warema WMS"
   - Install
   - ⏳ Warte, bis Installation abgeschlossen ist

2. **Noch NICHT starten!** → Erst konfigurieren

---

## Phase 4: Netzwerkparameter auslesen (Discovery-Modus)

Der WMS-Stick benötigt die Netzwerkparameter deines Warema-Funknetzes. Diese müssen von der Fernbedienung ausgelesen werden.

### 4.1 Addon in Discovery-Modus starten

1. **Warema WMS Addon → Configuration:**
   ```yaml
   WMS_SERIAL_PORT: /dev/ttyUSB0
   WMS_CHANNEL: 15
   WMS_KEY: "00000000000000000000000000000000"
   WMS_PAN_ID: FFFF
   MQTT_SERVER: localhost:1883
   MQTT_USER: warema
   MQTT_PASSWORD: <dein-passwort>
   LOG_LEVEL: debug
   ```

   **Wichtig:** `WMS_PAN_ID: FFFF` aktiviert den Discovery-Modus!

2. **Addon starten:**
   - Start-Button klicken
   - Log-Tab öffnen

### 4.2 Netzwerkparameter mit Fernbedienung auslesen

1. **Im Log erscheint eine Anleitung wie:**
   ```
   Discovery mode active. Please follow these steps:
   1. Press and hold the "P" button on your WMS remote for 3 seconds
   2. The remote will blink
   3. Press the "UP" button
   4. Check the log for the network parameters
   ```

2. **Fernbedienung:**
   - **P-Taste** 3 Sekunden gedrückt halten
   - Fernbedienung blinkt
   - **UP-Taste** drücken

3. **Im Log erscheinen die Parameter:**
   ```
   Received network parameters:
   Channel: 15
   PanId: 1A2B
   Key: 3F4E5D6C7B8A9F0E1D2C3B4A5968778A
   ```

4. **Parameter notieren!** Diese brauchst du für die finale Konfiguration.

### 4.3 Addon stoppen

- Stop-Button klicken

---

## Phase 5: Finale Konfiguration

### 5.1 Addon mit echten Netzwerkparametern konfigurieren

1. **Warema WMS Addon → Configuration:**
   ```yaml
   WMS_SERIAL_PORT: /dev/ttyUSB0
   WMS_CHANNEL: 15                                    # ← Dein Channel
   WMS_KEY: "3F4E5D6C7B8A9F0E1D2C3B4A5968778A"        # ← Dein Key
   WMS_PAN_ID: 1A2B                                   # ← Deine PAN ID
   MQTT_SERVER: localhost:1883
   MQTT_USER: warema
   MQTT_PASSWORD: <dein-passwort>
   LOG_LEVEL: info
   POLLING_INTERVAL: 30000
   MOVING_INTERVAL: 1000
   ```

   **Parameter-Erklärung:**
   - `POLLING_INTERVAL`: Wie oft wird der Status abgefragt (ms)
   - `MOVING_INTERVAL`: Update-Intervall während Bewegung (ms)
   - `LOG_LEVEL`: `debug` für Fehlersuche, `info` im Normalbetrieb

2. **Optionale Parameter:**
   ```yaml
   IGNORED_DEVICES: "12345,67890"     # Geräte-IDs ausschließen
   FORCE_DEVICES: "11111:blind"       # Gerätetyp erzwingen
   ```

### 5.2 Addon starten und Geräte erkennen

1. **Addon starten:**
   - Start-Button klicken
   - "Start on boot" aktivieren

2. **Log prüfen:**
   ```
   [INFO] Connected to MQTT broker
   [INFO] WMS Stick initialized
   [INFO] Scanning for devices...
   [INFO] Found device: ID=12345, Type=blind, Name=Wintergarten Links
   [INFO] Found device: ID=12346, Type=blind, Name=Wintergarten Rechts
   [INFO] Found device: ID=12347, Type=awning, Name=Terrasse
   [INFO] Device scan complete. 3 devices found.
   ```

3. **Falls keine Geräte gefunden werden:**
   - Prüfe USB-Verbindung: `ls -l /dev/ttyUSB0`
   - Prüfe Netzwerkparameter (Channel, PAN ID, Key)
   - Erhöhe `LOG_LEVEL` auf `debug`
   - Positioniere Stick näher an den Geräten

---

## Phase 6: Geräte in Home Assistant einbinden

### 6.1 MQTT Auto-Discovery

Die Geräte sollten automatisch in Home Assistant erscheinen:

1. **Settings → Devices & Services → MQTT**
   - Es sollten neue "Devices" unter MQTT angezeigt werden
   - Z.B.: "Warema Blind 12345"

2. **Devices prüfen:**
   - Klick auf ein Device
   - Du siehst Entities wie:
     - `cover.warema_blind_12345` (Cover Entity)
     - `sensor.warema_blind_12345_position` (Position)
     - `sensor.warema_blind_12345_tilt` (Neigung, falls vorhanden)

### 6.2 Manuelle Konfiguration (falls Auto-Discovery nicht funktioniert)

Falls Geräte nicht automatisch erscheinen, füge sie manuell hinzu:

**`configuration.yaml`:**
```yaml
mqtt:
  cover:
    - name: "Wintergarten Links"
      command_topic: "warema/12345/set"
      position_topic: "warema/12345/position"
      set_position_topic: "warema/12345/position/set"
      tilt_command_topic: "warema/12345/tilt/set"
      tilt_status_topic: "warema/12345/tilt"
      payload_open: "OPEN"
      payload_close: "CLOSE"
      payload_stop: "STOP"
      position_open: 0
      position_closed: 100
      device_class: blind

    - name: "Terrassen-Markise"
      command_topic: "warema/12347/set"
      position_topic: "warema/12347/position"
      set_position_topic: "warema/12347/position/set"
      payload_open: "OPEN"
      payload_close: "CLOSE"
      payload_stop: "STOP"
      position_open: 0
      position_closed: 100
      device_class: awning
```

**HA neu starten:**
- Developer Tools → YAML → Restart

---

## Phase 7: Geräte umbenennen und organisieren

### 7.1 Friendly Names vergeben

1. **Settings → Devices & Services → MQTT**
2. **Device auswählen** (z.B. "Warema Blind 12345")
3. **Entity auswählen** (z.B. `cover.warema_blind_12345`)
4. **Zahnrad-Symbol** → Settings
5. **Name:** "Wintergarten Links"
6. **Entity ID:** `cover.wintergarten_links` (optional)

### 7.2 Areas zuweisen

1. **Device auswählen**
2. **"Add to Area"**
3. Area wählen oder neue erstellen:
   - "Wintergarten"
   - "Terrasse"

---

## Phase 8: Automatisierungen erstellen

### 8.1 Beispiel: Markise bei Regen einfahren

**Voraussetzung:** Wettersensor (z.B. über Wetterstation oder Integration wie OpenWeatherMap)

**`automations.yaml`:**
```yaml
- id: markise_bei_regen_einfahren
  alias: "Markise bei Regen einfahren"
  description: "Fährt die Terrassenmarkise automatisch ein, wenn es regnet"
  trigger:
    - platform: state
      entity_id: sensor.openweathermap_condition
      to: "rainy"
  condition:
    - condition: state
      entity_id: cover.terrassen_markise
      state: "open"
  action:
    - service: cover.close_cover
      target:
        entity_id: cover.terrassen_markise
    - service: notify.mobile_app
      data:
        message: "Markise wurde wegen Regen eingefahren"
```

### 8.2 Beispiel: Verdunklungen bei Sonnenuntergang schließen

```yaml
- id: verdunklungen_sonnenuntergang
  alias: "Verdunklungen bei Sonnenuntergang"
  description: "Schließt alle Verdunklungen 30 Min nach Sonnenuntergang"
  trigger:
    - platform: sun
      event: sunset
      offset: "00:30:00"
  action:
    - service: cover.close_cover
      target:
        entity_id:
          - cover.wintergarten_links
          - cover.wintergarten_rechts
```

### 8.3 Beispiel: Verdunklungen bei Sonnenaufgang öffnen

```yaml
- id: verdunklungen_sonnenaufgang
  alias: "Verdunklungen bei Sonnenaufgang"
  description: "Öffnet Verdunklungen nach Sonnenaufgang (nur Werktags)"
  trigger:
    - platform: sun
      event: sunrise
      offset: "00:15:00"
  condition:
    - condition: time
      weekday:
        - mon
        - tue
        - wed
        - thu
        - fri
  action:
    - service: cover.open_cover
      target:
        area_id: wintergarten
```

### 8.4 Beispiel: Adaptiver Sonnenschutz (basierend auf Sonnenstand)

```yaml
- id: adaptiver_sonnenschutz
  alias: "Adaptiver Sonnenschutz"
  description: "Schließt Verdunklungen wenn Sonne direkt einfällt (Sommermorgen)"
  trigger:
    - platform: numeric_state
      entity_id: sun.sun
      attribute: elevation
      above: 30
  condition:
    - condition: time
      after: "08:00:00"
      before: "12:00:00"
    - condition: numeric_state
      entity_id: sensor.openweathermap_temperature
      above: 25
  action:
    - service: cover.set_cover_position
      target:
        entity_id: cover.wintergarten_links
      data:
        position: 70  # 70% geschlossen
```

### 8.5 Beispiel: Windschutz für Markise

```yaml
- id: markise_windschutz
  alias: "Markise bei starkem Wind einfahren"
  description: "Schützt die Markise vor Beschädigung bei Wind"
  trigger:
    - platform: numeric_state
      entity_id: sensor.wind_speed
      above: 30  # km/h
  condition:
    - condition: state
      entity_id: cover.terrassen_markise
      state: "open"
  action:
    - service: cover.close_cover
      target:
        entity_id: cover.terrassen_markise
    - service: notify.mobile_app
      data:
        title: "⚠️ Windwarnung"
        message: "Markise wurde wegen starkem Wind eingefahren ({{ states('sensor.wind_speed') }} km/h)"
```

---

## Phase 9: Dashboard-Integration

### 9.1 Einfache Lovelace-Karte

```yaml
type: entities
title: Sonnenschutz Wintergarten
entities:
  - entity: cover.wintergarten_links
    name: Links
  - entity: cover.wintergarten_rechts
    name: Rechts
  - entity: cover.terrassen_markise
    name: Terrasse
```

### 9.2 Erweiterte Steuerung mit Slider

```yaml
type: vertical-stack
cards:
  - type: entities
    title: Wintergarten
    entities:
      - entity: cover.wintergarten_links
        name: Verdunklung Links
        secondary_info: last-changed
      - type: custom:slider-entity-row
        entity: cover.wintergarten_links
        name: Position

  - type: horizontal-stack
    cards:
      - type: button
        entity: cover.wintergarten_links
        name: Öffnen
        icon: mdi:arrow-up
        tap_action:
          action: call-service
          service: cover.open_cover
          service_data:
            entity_id: cover.wintergarten_links

      - type: button
        entity: cover.wintergarten_links
        name: Stopp
        icon: mdi:stop
        tap_action:
          action: call-service
          service: cover.stop_cover
          service_data:
            entity_id: cover.wintergarten_links

      - type: button
        entity: cover.wintergarten_links
        name: Schließen
        icon: mdi:arrow-down
        tap_action:
          action: call-service
          service: cover.close_cover
          service_data:
            entity_id: cover.wintergarten_links
```

---

## Troubleshooting

### Problem: Keine Geräte gefunden

**Ursachen:**
- ❌ Falsche Netzwerkparameter (Channel, PAN ID, Key)
- ❌ USB-Stick nicht verbunden (`/dev/ttyUSB0` fehlt)
- ❌ Stick zu weit entfernt von Geräten
- ❌ USB3-Interferenzen

**Lösungen:**
1. **Netzwerkparameter prüfen:**
   - Discovery-Modus wiederholen
   - Mit Fernbedienung vergleichen

2. **USB-Verbindung prüfen:**
   ```bash
   ls -l /dev/ttyUSB0
   dmesg | grep ttyUSB
   ```

3. **Reichweite verbessern:**
   - USB-Verlängerungskabel verwenden
   - Stick zentral positionieren
   - Näher an Geräte bringen (Test)

4. **USB3-Interferenzen vermeiden:**
   - USB 2.0-Port verwenden
   - Oder 3-5m USB-Verlängerung (weg vom PC/Server)

### Problem: Geräte reagieren nicht auf Befehle

**Ursachen:**
- ❌ MQTT-Verbindung unterbrochen
- ❌ Falsche Topics
- ❌ Geräte außer Reichweite

**Lösungen:**
1. **MQTT-Verbindung prüfen:**
   - Settings → Devices & Services → MQTT
   - Status: "Connected"

2. **Addon-Log prüfen:**
   ```
   [ERROR] Failed to send command to device 12345
   ```

3. **MQTT-Topics testen:**
   - Developer Tools → MQTT
   - Topic: `warema/12345/set`
   - Payload: `OPEN`
   - Publish

4. **Manuelle Steuerung testen:**
   - Mit Fernbedienung prüfen ob Gerät grundsätzlich funktioniert

### Problem: Addon startet nicht

**Ursachen:**
- ❌ Falscher Serial Port
- ❌ MQTT-Broker nicht erreichbar
- ❌ Ungültige Konfiguration

**Lösungen:**
1. **Log analysieren:**
   - Warema WMS Addon → Log-Tab
   - Fehlermeldungen lesen

2. **Häufige Fehler:**
   ```
   [ERROR] Cannot open /dev/ttyUSB0
   → USB-Stick nicht verbunden oder Permissions fehlen

   [ERROR] MQTT connection failed
   → MQTT-Broker prüfen (läuft er? Credentials korrekt?)

   [ERROR] Invalid PAN_ID format
   → PAN_ID muss 4-stellig hexadezimal sein (z.B. 1A2B)
   ```

3. **Konfiguration validieren:**
   - `WMS_PAN_ID`: 4-stellig Hex (z.B. `1A2B`)
   - `WMS_KEY`: 32-stellig Hex
   - `WMS_CHANNEL`: Zahl zwischen 11-26

### Problem: Positionen werden nicht aktualisiert

**Ursachen:**
- ❌ `POLLING_INTERVAL` zu hoch
- ❌ Geräte senden keinen Status zurück

**Lösungen:**
1. **Polling-Intervall anpassen:**
   ```yaml
   POLLING_INTERVAL: 10000  # 10 Sekunden
   ```

2. **Log-Level erhöhen:**
   ```yaml
   LOG_LEVEL: debug
   ```

3. **Status-Topics prüfen:**
   - Developer Tools → MQTT
   - Listen to: `warema/#`
   - Gerät manuell bewegen
   - Prüfen ob Updates kommen

### Problem: USB-Stick wird nach Reboot nicht erkannt

**Ursachen:**
- ❌ Proxmox USB-Passthrough nicht persistent
- ❌ USB-Device ID ändert sich

**Lösungen:**
1. **USB-Passthrough in Proxmox prüfen:**
   - VM → Hardware → USB Device
   - "Use USB Vendor/Device ID" (nicht "Use USB Port")

2. **udev-Regel erstellen (in Home Assistant):**
   ```bash
   # /etc/udev/rules.d/99-wms-stick.rules
   SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", SYMLINK+="wms-stick"
   ```

   Dann in Addon-Config:
   ```yaml
   WMS_SERIAL_PORT: /dev/wms-stick
   ```

---

## Tipps & Best Practices

### Reichweite optimieren

1. **USB-Verlängerungskabel verwenden (3-5m)**
   - Positioniert Stick optimal im Haus
   - Reduziert USB3-Interferenzen
   - Empfehlung: USB 2.0 Verlängerung

2. **Zentrale, erhöhte Position**
   - Nicht im Keller/unter Schreibtisch
   - Möglichst freie Sichtlinie zu Geräten
   - Weg von Metallgegenständen (Server-Racks, Heizkörper)

3. **Bei Reichweitenproblemen:**
   - WMS Plug Receiver Power als Repeater nutzen
   - Mehrere Sticks (jeweils eigenes Netz)

### Sicherheit

1. **MQTT-Zugangsdaten schützen:**
   - Dedizierte MQTT-User verwenden
   - Starke Passwörter
   - Keine Credentials in `configuration.yaml` (nutze `secrets.yaml`)

2. **Netzwerkparameter geheim halten:**
   - WMS_KEY niemals öffentlich teilen
   - Wie WLAN-Passwort behandeln

### Performance

1. **Polling-Intervalle anpassen:**
   - Standard: `POLLING_INTERVAL: 30000` (30s)
   - Bei vielen Geräten: höher (60000+)
   - Bei wenigen Geräten: niedriger (15000)

2. **Unnötige Geräte ignorieren:**
   ```yaml
   IGNORED_DEVICES: "12345,67890"
   ```

### Backup

1. **Addon-Konfiguration sichern:**
   - Settings → Add-ons → Warema WMS → Configuration
   - Konfiguration in Textdatei speichern

2. **Netzwerkparameter sichern:**
   - Channel, PAN ID, Key aufschreiben
   - An sicherem Ort aufbewahren (z.B. Password-Manager)

---

## Erweiterte Szenarien

### Mehrere WMS-Netze

Falls du mehrere unabhängige WMS-Netze hast (z.B. Haus + Garage):

1. **Zweiten WMS-Stick kaufen**
2. **Zweite Addon-Instanz** (nicht möglich → Alternative: Docker-Container)
3. **Oder:** Alle Geräte in ein WMS-Netz migrieren

### Integration mit anderen Smart-Home-Systemen

**Node-RED:**
- MQTT-Nodes nutzen
- Topics: `warema/<device-id>/set` und `warema/<device-id>/position`

**Alexa/Google Assistant:**
- Über Home Assistant Cloud oder Nabu Casa
- Cover-Entities werden als "Blinds" oder "Awnings" erkannt
- Sprachbefehle: "Alexa, öffne Wintergarten Links"

**Apple HomeKit:**
- HomeKit Integration in HA aktivieren
- Cover-Entities werden als Blinds/Awnings integriert

---

## Ressourcen & Links

### Offizielle Dokumentation

- [Warema WMS USB-Stick Produktseite](https://smartbuildings.warema.com/en/control-systems/radio-systems/wms/wms-stick-(usb)/)
- [Warema WMS System Übersicht](https://www.warema.com/en/smart-home/wms/)

### Home Assistant

- [Home Assistant MQTT Integration](https://www.home-assistant.io/integrations/mqtt/)
- [Home Assistant Cover Platform](https://www.home-assistant.io/integrations/cover/)

### Community & Support

- [GitHub - santam85/addon-warema-wms](https://github.com/santam85/addon-warema-wms)
- [Home Assistant Community - Warema WMS Integration Thread](https://community.home-assistant.io/t/warema-wms-integration/272124)

### Verwandte Projekte

- [WaremaWMSApi - Local API for WMS WebControl Pro](https://github.com/MartijnTuinstra/WaremaWMSApi)
- [pywmspro - Python Library for WMS WebControl Pro](https://github.com/mback2k/pywmspro)

---

## Changelog

| Version | Datum | Änderungen |
|---------|-------|------------|
| 1.0     | 2026-01-01 | Initiale Version |

---

## Autor

Erstellt für die Integration von Warema WMS-Geräten in Home Assistant via USB-Stick.

**Getestet mit:**
- Home Assistant 2024.12
- Proxmox VE 8.x
- Warema WMS USB-Stick (Standard)
- Mosquitto MQTT Broker 6.x

---

## Lizenz

Diese Anleitung steht unter der [MIT License](https://opensource.org/licenses/MIT).
