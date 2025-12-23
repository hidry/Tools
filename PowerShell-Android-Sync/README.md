# PowerShell Android Media Sync

PowerShell-Skript zum zuverlässigen Übertragen von Fotos und Videos von Windows auf Android-Geräte (z.B. Samsung Galaxy S23) mit ADB (Android Debug Bridge).

## ✨ Features

- ✅ **Timestamp-Erhaltung**: Behält das Änderungsdatum der Originaldateien bei
- ✅ **Retry-Mechanismus**: 3 Wiederholungsversuche pro Datei mit exponentiellem Backoff (2s, 4s, 8s)
- ✅ **Dateivalidierung**: Überprüft Dateigröße nach der Übertragung
- ✅ **Galerie-Integration**: Triggert automatisch den Android Media Scanner
- ✅ **Detailliertes Logging**: Erstellt eine Log-Datei mit allen Übertragungen und Fehlern
- ✅ **Zusammenfassung**: Zeigt Statistiken nach der Übertragung an
- ✅ **Rekursive Übertragung**: Optional mit Unterordner-Struktur
- ✅ **Datei-Filter**: Nur bestimmte Dateitypen übertragen

## 📋 Voraussetzungen

### 1. ADB (Android Debug Bridge) installieren

**Option A: Platform Tools von Google (empfohlen)**
1. Herunterladen von: https://developer.android.com/tools/releases/platform-tools
2. ZIP-Datei entpacken (z.B. nach `C:\platform-tools`)
3. Zum PATH hinzufügen:
   - Windows-Taste drücken und "Umgebungsvariablen" eingeben
   - "Umgebungsvariablen für dieses Konto bearbeiten"
   - Bei "Path" auf "Bearbeiten" klicken
   - "Neu" klicken und Pfad einfügen (z.B. `C:\platform-tools`)
   - Alles mit "OK" bestätigen
   - PowerShell/CMD neu starten

**Option B: Chocolatey (falls installiert)**
```powershell
choco install adb
```

**Option C: Scoop (falls installiert)**
```powershell
scoop install adb
```

**Überprüfung:**
```powershell
adb version
```

### 2. Android-Gerät vorbereiten (Samsung Galaxy S23 / Android 16)

#### USB-Debugging aktivieren:

1. **Entwickleroptionen aktivieren:**
   - Einstellungen → "Über das Telefon" → "Software-Informationen"
   - 7x auf "Build-Nummer" tippen
   - Meldung: "Entwicklermodus wurde aktiviert"

2. **USB-Debugging einschalten:**
   - Einstellungen → "Entwickleroptionen"
   - "USB-Debugging" aktivieren
   - Bestätigen mit "OK"

3. **Gerät per USB verbinden:**
   - USB-Kabel anschließen
   - Pop-up am Handy: "USB-Debugging zulassen?"
   - ✅ "Immer von diesem Computer zulassen" ankreuzen
   - "Zulassen" drücken

4. **Verbindung testen:**
   ```powershell
   adb devices
   ```

   Sollte anzeigen:
   ```
   List of devices attached
   RF8XXXXXXXXX    device
   ```

   Falls "unauthorized" erscheint → USB-Debugging-Popup am Handy nochmal prüfen

## 🚀 Verwendung

### Basis-Beispiel

Alle Bilder aus einem Ordner auf das Handy kopieren:

```powershell
.\Sync-AndroidMedia.ps1 -SourcePath "C:\Users\MeinName\Pictures\Urlaub2024"
```

### Mit eigenem Zielordner

```powershell
.\Sync-AndroidMedia.ps1 -SourcePath "C:\Bilder\Hochzeit" -DestinationPath "/sdcard/DCIM/Hochzeit"
```

### Nur bestimmte Dateitypen

```powershell
# Nur JPG-Dateien
.\Sync-AndroidMedia.ps1 -SourcePath "C:\Fotos" -FileFilter "*.jpg"

# Nur Videos
.\Sync-AndroidMedia.ps1 -SourcePath "C:\Videos" -FileFilter "*.mp4"
```

### Rekursiv mit Unterordnern

```powershell
.\Sync-AndroidMedia.ps1 -SourcePath "C:\Bilder" -Recursive
```

### Alle Parameter

```powershell
.\Sync-AndroidMedia.ps1 `
    -SourcePath "C:\Users\MeinName\Pictures\Urlaub2024" `
    -DestinationPath "/sdcard/DCIM/Urlaub2024" `
    -FileFilter "*.jpg" `
    -Recursive `
    -MaxRetries 5 `
    -LogPath "C:\Logs\android-sync.log"
```

## 📊 Ausgabe-Beispiel

```
========================================
Android Media Sync Started
========================================
Source: C:\Users\John\Pictures\Vacation
Destination: /sdcard/DCIM/Vacation
File Filter: *
========================================
[INFO] ADB is available: Android Debug Bridge version 1.0.41
[SUCCESS] Android device connected and authorized
[INFO] Found 150 media files to transfer
========================================

[1/150] Processing file...
[INFO] Processing: IMG_1234.jpg (4.5 MB)
[INFO] Transferring file (attempt 1/3)...
[SUCCESS] File size validated: 4718592 bytes
[SUCCESS] Timestamp set to: 2024-08-15 14:30:22
[SUCCESS] Media scanner triggered
[SUCCESS] ✓ Successfully transferred: IMG_1234.jpg

...

========================================
SYNC SUMMARY
========================================
Total Files Processed: 150
Successfully Transferred: 148
Failed: 2
Duration: 00:12:45
========================================
```

## 🎯 Unterstützte Dateiformate

Das Skript filtert automatisch nach gängigen Medienformaten:

**Bilder:**
- `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.heic`

**Videos:**
- `.mp4`, `.mov`, `.avi`, `.mkv`, `.3gp`, `.webm`

## 📝 Parameter-Übersicht

| Parameter | Pflicht | Standard | Beschreibung |
|-----------|---------|----------|--------------|
| `-SourcePath` | Ja | - | Quellordner auf Windows |
| `-DestinationPath` | Nein | `/sdcard/DCIM/Camera` | Zielordner auf Android |
| `-FileFilter` | Nein | `*` | Filter für Dateien (z.B. `*.jpg`) |
| `-Recursive` | Nein | `false` | Unterordner einbeziehen |
| `-MaxRetries` | Nein | `3` | Anzahl Wiederholungsversuche |
| `-LogPath` | Nein | `.\Sync-AndroidMedia-Log.txt` | Pfad zur Log-Datei |

## 🔍 Wie funktioniert die Timestamp-Erhaltung?

### Wichtig zu verstehen:

1. **Windows hat 3 Zeitstempel:**
   - Creation Time (Erstellungsdatum)
   - Last Write Time (Änderungsdatum)
   - Last Access Time (Zugriffsdatum)

2. **Android/Linux hat nur 2 Zeitstempel:**
   - Modified Time (Änderungsdatum)
   - Access Time (Zugriffsdatum)
   - ❌ Kein "Creation Time" im Dateisystem

3. **Was macht das Skript:**
   - Kopiert das **Last Write Time** (Änderungsdatum) von Windows
   - Setzt es als **Modified Time** auf Android
   - Die Android-Galerie nutzt primär **EXIF-Daten** aus den Bildern selbst

4. **EXIF-Daten (wichtig für die Galerie):**
   - Bleiben beim Kopieren vollständig erhalten
   - Enthalten das eigentliche "Aufnahmedatum"
   - Die Galerie sortiert nach EXIF "Date Taken" (wenn vorhanden)
   - Falls keine EXIF-Daten: Galerie nutzt Modified Time

**Ergebnis:** Ihre Bilder erscheinen in der Galerie mit dem korrekten Aufnahmedatum!

## 🛠️ Troubleshooting

### Problem: "ADB is not installed or not in PATH"

**Lösung:**
1. ADB installieren (siehe Voraussetzungen)
2. PowerShell/CMD neu starten
3. `adb version` testen

### Problem: "No Android device detected"

**Lösungen:**
1. USB-Kabel überprüfen (manche Kabel können nur laden, nicht Daten übertragen)
2. USB-Debugging am Handy aktiviert? (siehe Voraussetzungen)
3. USB-Debugging-Popup am Handy bestätigt?
4. Anderer USB-Anschluss am PC versuchen
5. `adb devices` ausführen → sollte Gerät anzeigen

### Problem: "unauthorized" bei `adb devices`

**Lösung:**
1. USB-Kabel abziehen und wieder anstecken
2. Pop-up am Handy sollte erscheinen: "USB-Debugging zulassen?"
3. "Immer von diesem Computer zulassen" ankreuzen
4. "Zulassen" drücken

### Problem: Dateien werden nicht in der Galerie angezeigt

**Lösungen:**
1. Das Skript triggert automatisch den Media Scanner
2. Manuell: Handy neu starten
3. Manuell: Galerie-App → Einstellungen → "Nach Medien suchen"
4. Überprüfen ob Zielordner korrekt ist (sollte in `/sdcard/DCIM/...` sein)

### Problem: "File size mismatch"

**Ursachen:**
- Verbindungsprobleme
- Wenig Speicherplatz auf dem Handy
- Beschädigtes USB-Kabel

**Lösung:**
- Das Skript wiederholt automatisch 3x
- Speicherplatz am Handy prüfen
- USB-Kabel tauschen

### Problem: Sehr langsame Übertragung

**Tipps:**
- USB 3.0 Anschluss am PC verwenden (blau)
- USB 3.0 Kabel verwenden
- Handy entsperren während der Übertragung
- Andere USB-Anschlüsse ausprobieren
- USB 2.0 Modus am Handy deaktivieren

## 📁 Log-Datei

Das Skript erstellt automatisch eine detaillierte Log-Datei (Standard: `Sync-AndroidMedia-Log.txt`):

```
[2024-12-23 15:30:00] [INFO] Android Media Sync Started
[2024-12-23 15:30:01] [SUCCESS] ADB is available
[2024-12-23 15:30:01] [SUCCESS] Android device connected
[2024-12-23 15:30:05] [INFO] Found 150 media files
[2024-12-23 15:30:06] [INFO] Processing: IMG_1234.jpg (4.5 MB)
[2024-12-23 15:30:08] [SUCCESS] ✓ Successfully transferred: IMG_1234.jpg
[2024-12-23 15:30:10] [ERROR] ✗ Failed to transfer: IMG_CORRUPT.jpg
...
```

## 🔒 Sicherheitshinweise

- USB-Debugging ist ein Sicherheitsrisiko wenn das Handy an nicht-vertrauenswürdige Computer angeschlossen wird
- Nur am eigenen PC aktivieren
- Pop-up am Handy immer prüfen bevor "Zulassen" gedrückt wird
- Nach der Nutzung kann USB-Debugging wieder deaktiviert werden

## 🤝 Beitragen

Feedback und Verbesserungsvorschläge sind willkommen!

## 📄 Lizenz

Frei verwendbar für private und kommerzielle Zwecke.

## ❓ Häufige Fragen

### Funktioniert das auch mit anderen Android-Geräten?

Ja! Das Skript funktioniert mit allen Android-Geräten (nicht nur Samsung), solange USB-Debugging unterstützt wird.

### Kann ich das auch drahtlos (WiFi) nutzen?

Ja, ADB kann auch über WiFi verbunden werden:

```powershell
# Am PC (Handy muss im gleichen Netzwerk sein)
adb tcpip 5555
adb connect 192.168.1.100:5555  # IP des Handys

# Dann Skript normal ausführen
```

### Werden die Originaldateien gelöscht?

Nein, das Skript kopiert nur. Die Originaldateien auf dem PC bleiben unverändert.

### Was passiert wenn eine Datei bereits existiert?

ADB überschreibt die Datei. Falls Sie das nicht wollen, können Sie das Skript anpassen.

### Kann ich auch vom Handy zum PC kopieren?

Für die Gegenrichtung müsste man `adb pull` statt `adb push` verwenden. Das Skript ist aktuell nur für PC → Android optimiert.
