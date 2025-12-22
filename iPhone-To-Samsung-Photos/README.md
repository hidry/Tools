# iPhone zu Samsung DCIM Konverter

PowerShell-Skript zur Aufbereitung von iPhone DCIM-Backups für Samsung Galaxy S23 (und andere Samsung-Geräte).

## Funktionen

- **Samsung-Namenskonvention**: Benennt Dateien im Format `YYYYMMDD_HHMMSS.jpg` um
- **EXIF-Datenextraktion**: Verwendet das Originalaufnahmedatum für die Benennung
- **HEIC zu JPG Konvertierung**: Optional, mit Metadaten-Erhaltung
- **MOV zu MP4 Konvertierung**: Optional, für bessere Kompatibilität
- **Samsung-Ordnerstruktur**: Erstellt `DCIM/Camera/` Struktur
- **Dateidatum-Anpassung**: Setzt Erstellungs- und Änderungsdatum auf Aufnahmedatum

## Voraussetzungen

### Erforderlich
- PowerShell 5.1 oder höher (in Windows 10/11 enthalten)

### Optional (für erweiterte Funktionen)

| Tool | Funktion | Download |
|------|----------|----------|
| **ExifTool** | Präzise EXIF-Datenextraktion | [exiftool.org](https://exiftool.org/) |
| **ImageMagick** | HEIC zu JPG Konvertierung | [imagemagick.org](https://imagemagick.org/script/download.php#windows) |
| **FFmpeg** | MOV zu MP4 Konvertierung | [ffmpeg.org](https://ffmpeg.org/download.html) |

## Installation

1. Lade das Skript herunter
2. Optional: Installiere die zusätzlichen Tools (siehe oben)
3. Stelle sicher, dass die Tools im PATH sind oder lege sie in `C:\Tools\` ab

### Installation der optionalen Tools (empfohlen)

```powershell
# Mit winget (Windows 11 / Windows 10 mit winget)
winget install exiftool
winget install ImageMagick.ImageMagick
winget install Gyan.FFmpeg

# Oder mit Chocolatey
choco install exiftool
choco install imagemagick
choco install ffmpeg
```

## Verwendung

### Grundlegende Verwendung

```powershell
.\Convert-iPhoneToSamsung.ps1 -SourcePath "D:\iPhone-Backup\DCIM" -DestinationPath "E:\Samsung-Import"
```

### Mit HEIC-Konvertierung

```powershell
.\Convert-iPhoneToSamsung.ps1 -SourcePath "D:\DCIM" -DestinationPath "E:\Output" -ConvertHEIC
```

### Mit allen Konvertierungen

```powershell
.\Convert-iPhoneToSamsung.ps1 -SourcePath "D:\DCIM" -DestinationPath "E:\Output" -ConvertHEIC -ConvertMOV
```

### Simulation (keine Änderungen)

```powershell
.\Convert-iPhoneToSamsung.ps1 -SourcePath "D:\DCIM" -DestinationPath "E:\Output" -WhatIf
```

## Parameter

| Parameter | Beschreibung | Erforderlich |
|-----------|-------------|--------------|
| `-SourcePath` | Pfad zum iPhone DCIM-Backup | Ja |
| `-DestinationPath` | Zielordner für die Ausgabe | Ja |
| `-ConvertHEIC` | Konvertiert HEIC zu JPG | Nein |
| `-ConvertMOV` | Konvertiert MOV zu MP4 | Nein |
| `-KeepOriginals` | Behält Originaldateien | Nein |
| `-PreserveLivePhotos` | Verknüpft Live Photo Komponenten | Nein |
| `-WhatIf` | Simulationsmodus | Nein |
| `-Verbose` | Ausführliche Ausgabe | Nein |

## Workflow

1. **iPhone-Backup erstellen**: Sichere dein iPhone DCIM-Verzeichnis auf deinen PC
2. **Skript ausführen**: Führe das Skript mit den gewünschten Optionen aus
3. **Auf Samsung kopieren**: Kopiere den Inhalt von `Output\DCIM\Camera\` auf dein Samsung unter `Interner Speicher\DCIM\Camera\`
4. **Medien-Scan**: Öffne die Samsung Galerie-App - die Fotos sollten automatisch erscheinen

## Dateiformat-Details

### iPhone Struktur (Eingabe)
```
DCIM/
├── 100APPLE/
│   ├── IMG_0001.HEIC
│   ├── IMG_0001.MOV (Live Photo)
│   ├── IMG_0002.JPG
│   └── ...
├── 101APPLE/
│   └── ...
```

### Samsung Struktur (Ausgabe)
```
DCIM/
└── Camera/
    ├── 20231215_143022.jpg
    ├── 20231215_143023.mp4
    ├── 20231216_091500.jpg
    └── ...
```

## Tipps

### Beste Ergebnisse

1. **ExifTool installieren**: Für präzise Datums-Extraktion unbedingt empfohlen
2. **HEIC beibehalten**: Samsung Galaxy S23 unterstützt HEIC nativ - Konvertierung oft nicht nötig
3. **Testlauf**: Verwende `-WhatIf` für einen Testlauf ohne Änderungen

### Fehlerbehebung

**Problem**: Fotos erscheinen nicht in der Samsung Galerie
- **Lösung**: Starte das Gerät neu oder führe einen Medien-Scan durch (Einstellungen > Speicher > Medien scannen)

**Problem**: Falsches Datum bei einigen Fotos
- **Lösung**: Installiere ExifTool für präzise EXIF-Datenextraktion

**Problem**: HEIC-Konvertierung funktioniert nicht
- **Lösung**: Installiere ImageMagick und stelle sicher, dass es im PATH ist

## Hinweise zu Live Photos

iPhone Live Photos bestehen aus zwei Dateien:
- Ein Foto (HEIC/JPG)
- Ein kurzes Video (MOV, 1-3 Sekunden)

Samsung verwendet ein anderes Live Photo Format (Motion Photo). Dieses Skript konvertiert beide Komponenten separat - das Video erscheint als separater Clip in der Galerie.

## Lizenz

Dieses Skript ist frei verwendbar. Keine Garantie für Datenverlust - erstelle immer Backups!

## Changelog

### Version 1.0 (2024-12-22)
- Erste Version
- Unterstützung für HEIC, JPG, PNG, MOV, MP4
- EXIF-basierte Datumsextraktion
- Optionale Konvertierung von HEIC und MOV
