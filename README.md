# Tools

Sammlung von PowerShell-Tools, Code-Snippets und Entwicklungs-Anleitungen.

## Inhalt

### Verzeichnisse

| Verzeichnis | Beschreibung |
|-------------|--------------|
| [Anleitungen](./Anleitungen/) | Workflow-Dokumentationen und Best Practices für die Entwicklung mit Claude Code |
| [ClaudeMD-Manager](./ClaudeMD-Manager/) | PowerShell-Tool zur automatischen Generierung und Aktualisierung von CLAUDE.md Dateien in Git-Repositories |
| [Git-Branch-Cleanup](./Git-Branch-Cleanup/) | PowerShell-Tool zum automatischen Aufräumen von gemergten, leeren und inaktiven Git-Branches |
| [iPhone-To-Samsung-Photos](./iPhone-To-Samsung-Photos/) | PowerShell-Tool zur Konvertierung von iPhone DCIM-Backups für Samsung Galaxy Geräte |
| [PowerShell-Android-Sync](./PowerShell-Android-Sync/) | PowerShell-Tool zum Übertragen von Fotos/Videos auf Android-Geräte via ADB mit Timestamp-Erhaltung und Validierung |
| [Sage100-Mandant](./Sage100-Mandant/) | C#-Code-Snippet zur Erstellung eines Sage 100 Mandantenobjekts mit Session-Authentifizierung |
| [Sync AzureDevops-Repos](./Sync%20AzureDevops-Repos/) | PowerShell-Tool zur automatischen Synchronisation aller Git-Repositories eines Azure DevOps Projekts |
| [iPhone-FileCopy](./iPhone-FileCopy/) | PowerShell-Tool zum Kopieren von Dateien vom iPhone (MTP) auf den lokalen PC |

## Voraussetzungen

Die meisten Tools in diesem Repository benötigen:
- **PowerShell 5.0** oder höher
- **Git** installiert und im PATH verfügbar

Weitere tool-spezifische Voraussetzungen sind in den jeweiligen Unterverzeichnis-READMEs dokumentiert.

## Tools im Überblick

### ClaudeMD-Manager

Scannt Verzeichnisbäume nach Git-Repositories und erstellt/aktualisiert automatisch CLAUDE.md Dokumentationsdateien mittels Claude Code CLI.

**Zusätzliche Voraussetzung:** Claude Code CLI installiert

```powershell
.\ClaudeMD-Manager\ClaudeMD-Manager.ps1 -RootPath "C:\Repos" -DryRun
```

### Sync AzureDevops-Repos

Synchronisiert alle Repositories eines Azure DevOps Projekts lokal. Bestehende Repositories werden aktualisiert, neue werden geklont.

**Zusätzliche Voraussetzung:** Azure DevOps Personal Access Token (PAT)

```powershell
".\Sync AzureDevops-Repos\Sync-Repos.ps1" -Organization "https://server/tfs/collection/" -Project "myProject" -Token "myPAT"
```

### iPhone-To-Samsung-Photos

Konvertiert iPhone DCIM-Backups für Samsung Galaxy Geräte. Benennt Dateien nach Samsung-Namenskonvention um (YYYYMMDD_HHMMSS), extrahiert EXIF-Daten und erstellt die passende Ordnerstruktur.

**Optionale Voraussetzungen:** ExifTool (für präzise Datumsextraktion), ImageMagick (HEIC-Konvertierung), FFmpeg (MOV-Konvertierung)

```powershell
.\iPhone-To-Samsung-Photos\Convert-iPhoneToSamsung.ps1 -SourcePath "D:\iPhone\DCIM" -DestinationPath "E:\Samsung" -SimulateOnly
```

### PowerShell-Android-Sync

Überträgt Fotos und Videos von Windows direkt auf Android-Geräte via ADB (Android Debug Bridge). Mit Retry-Mechanismus, Dateivalidierung, Timestamp-Erhaltung und automatischer Galerie-Integration.

**Zusätzliche Voraussetzung:** ADB (Android Debug Bridge) installiert, USB-Debugging am Android-Gerät aktiviert

```powershell
.\PowerShell-Android-Sync\Sync-AndroidMedia.ps1 -SourcePath "C:\Fotos\Urlaub" -DestinationPath "/sdcard/DCIM/Urlaub"
```

### iPhone-FileCopy

Kopiert Dateien vom iPhone (per USB/MTP verbunden) auf den lokalen PC. Unterstützt selektives Kopieren einzelner Ordner (z.B. nur DCIM für Fotos).

```powershell
.\iPhone-FileCopy\Copy-iPhoneFiles.ps1 -SourceFolder "DCIM" -DestinationPath "D:\Fotos" -SkipExisting
```

### Git-Branch-Cleanup

Identifiziert und löscht automatisch nicht mehr benötigte Git-Branches (gemergte, leere und inaktive Branches). Zeigt immer eine Warnung bei Branches die seit über einem Jahr nicht geändert wurden. Mit Sicherheitsfeatures wie geschützten Branches, Dry-Run Modus und Bestätigungsabfragen.

```powershell
# Dry-Run: Zeigt nur was gelöscht würde
.\Git-Branch-Cleanup\Remove-MergedBranches.ps1 -DryRun

# Lokale gemergte/leere Branches löschen (zeigt inaktive nur an)
.\Git-Branch-Cleanup\Remove-MergedBranches.ps1

# Auch inaktive Branches (>365 Tage) löschen
.\Git-Branch-Cleanup\Remove-MergedBranches.ps1 -IncludeStale

# Inkl. Remote-Branches und inaktiven >6 Monaten
.\Git-Branch-Cleanup\Remove-MergedBranches.ps1 -IncludeRemote -IncludeStale -InactiveMonths 6 -Force
```

### Anleitungen

Enthält den **PRD-to-Code Workflow** - eine strukturierte Anleitung für die Entwicklung mit Claude Code, die von Product Requirements Documents bis zur fertigen Implementierung führt.
