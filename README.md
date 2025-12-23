# Tools

Sammlung von PowerShell-Tools, Code-Snippets und Entwicklungs-Anleitungen.

## Inhalt

### Verzeichnisse

| Verzeichnis | Beschreibung |
|-------------|--------------|
| [Anleitungen](./Anleitungen/) | Workflow-Dokumentationen und Best Practices für die Entwicklung mit Claude Code |
| [ClaudeMD-Manager](./ClaudeMD-Manager/) | PowerShell-Tool zur automatischen Generierung und Aktualisierung von CLAUDE.md Dateien in Git-Repositories |
| [iPhone-To-Samsung-Photos](./iPhone-To-Samsung-Photos/) | PowerShell-Tool zur Konvertierung von iPhone DCIM-Backups für Samsung Galaxy Geräte |
| [Sync AzureDevops-Repos](./Sync%20AzureDevops-Repos/) | PowerShell-Tool zur automatischen Synchronisation aller Git-Repositories eines Azure DevOps Projekts |

### Dateien

| Datei | Beschreibung |
|-------|--------------|
| `Sage 100 Mandantenobjekt erzeugen` | C#-Code-Snippet zur Erstellung eines Sage 100 Mandantenobjekts mit Session-Authentifizierung |

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

### Anleitungen

Enthält den **PRD-to-Code Workflow** - eine strukturierte Anleitung für die Entwicklung mit Claude Code, die von Product Requirements Documents bis zur fertigen Implementierung führt.

## Sage 100 Code-Snippet

C#-Methode zur Erstellung eines Sage 100 Mandantenobjekts:

```csharp
public static Sagede.OfficeLine.Engine.Mandant GetClient(
    string username,
    string password,
    string databaseName,
    short clientId)
```

Erstellt eine Session mit der Sage OfficeLine Engine und gibt ein Mandantenobjekt zurück.
