# ClaudeMD-Manager

PowerShell-Tool zur automatischen Generierung und Aktualisierung von CLAUDE.md Dokumentationsdateien in Git-Repositories mittels Claude Code CLI.

## Beschreibung

Dieses Script scannt einen Verzeichnisbaum nach Git-Repositories und erstellt bzw. aktualisiert automatisch CLAUDE.md Dokumentationsdateien. Es nutzt die lokal installierte Claude Code CLI, um intelligente Analysen der Codebases zu erstellen.

## Voraussetzungen

- PowerShell 5.0 oder höher
- Git installiert und im PATH verfügbar
- Claude Code CLI installiert (`claude` Befehl verfügbar)

## Verwendung

```powershell
# Standard-Ausführung im aktuellen Verzeichnis
.\ClaudeMD-Manager.ps1

# Mit angepassten Parametern
.\ClaudeMD-Manager.ps1 -RootPath "C:\Repos" `
                       -MinChangesThreshold 10 `
                       -TopReposCount 3 `
                       -Verbose

# Testlauf ohne Änderungen
.\ClaudeMD-Manager.ps1 -DryRun
```

## Parameter

| Parameter | Beschreibung | Standard |
|-----------|--------------|----------|
| `-RootPath` | Wurzelverzeichnis für Repository-Scan | Aktuelles Verzeichnis |
| `-MinChangesThreshold` | Mindestanzahl Commits seit letztem Update für Aktualisierung | `5` |
| `-TopReposCount` | Anzahl der Repos mit meisten Änderungen, die aktualisiert werden | `5` |
| `-DryRun` | Simulationsmodus ohne tatsächliche Änderungen | - |
| `-Verbose` | Erweiterte Ausgabe für Debugging | - |

## Funktionsweise

1. **Umgebungsprüfung**: Validiert PowerShell-Version, Git und Claude Installation
2. **Repository-Scan**: Findet alle Git-Repositories im Root-Verzeichnis
3. **Priorisierung**:
   - Repositories ohne CLAUDE.md werden immer verarbeitet
   - Repositories mit CLAUDE.md werden nach Anzahl der Commits seit letztem Update sortiert
   - Top N Repositories (nach `-TopReposCount`) werden aktualisiert
4. **Claude-Analyse**: Für jedes ausgewählte Repository:
   - Neue Repos: Vollständige Codebase-Analyse
   - Bestehende: Update basierend auf Änderungen
5. **Root-Verarbeitung**: Optional wird eine übergreifende claude.md im Wurzelverzeichnis erstellt/aktualisiert

## Generierte Dokumentation

Die CLAUDE.md Dateien enthalten typischerweise:
- Overview/Projektbeschreibung
- Projektstruktur
- Wichtige Dateien und deren Rollen
- Build-Anweisungen
- Dependencies
- Verwendungshinweise

## Hinweise

- Timeout pro Repository: 5 Minuten
- Mindestens 100 Zeichen Output von Claude erforderlich
- ANSI-Codes werden automatisch aus dem Output entfernt
