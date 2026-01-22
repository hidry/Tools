# Git-Branch-Cleanup

PowerShell-Tool zum automatischen Aufräumen von nicht mehr benötigten Git-Branches.

## Beschreibung

Dieses Script identifiziert und löscht Git-Branches, die nicht mehr benötigt werden:
- **Gemergte Branches**: Branches die bereits vollständig in den Main-Branch gemerged wurden
- **Leere Branches**: Branches ohne eigene Commits (nie etwas geändert wurde)

Das Tool bietet umfangreiche Sicherheitsmechanismen wie geschützte Branches, Dry-Run Modus und Bestätigungsabfragen.

## Voraussetzungen

- PowerShell 5.0 oder höher
- Git installiert und im PATH verfügbar
- Ausführung innerhalb eines Git-Repositories

## Verwendung

### Grundlegende Verwendung

```powershell
# Dry-Run: Zeigt nur was gelöscht würde
.\Remove-MergedBranches.ps1 -DryRun

# Lokale gemergte/leere Branches löschen (mit Bestätigung)
.\Remove-MergedBranches.ps1

# Auch Remote-Branches löschen
.\Remove-MergedBranches.ps1 -IncludeRemote

# Ohne Bestätigung löschen
.\Remove-MergedBranches.ps1 -Force
```

### Erweiterte Verwendung

```powershell
# In einem anderen Repository, mit spezifischem Main-Branch
.\Remove-MergedBranches.ps1 -RepositoryPath "C:\Projekte\MeinRepo" -MainBranch "main"

# Eigene Protected Branches definieren
.\Remove-MergedBranches.ps1 -ProtectedBranches @('master', 'main', 'release')

# Kompletter Cleanup: Remote + Lokal ohne Bestätigung
.\Remove-MergedBranches.ps1 -IncludeRemote -Force
```

## Parameter

| Parameter | Beschreibung | Standard |
|-----------|--------------|----------|
| `-RepositoryPath` | Pfad zum Git-Repository | `.` (aktuelles Verzeichnis) |
| `-MainBranch` | Name des Haupt-Branches | Auto-Erkennung (master/main) |
| `-DryRun` | Nur anzeigen, nichts löschen | `$false` |
| `-IncludeRemote` | Auch Remote-Branches löschen | `$false` |
| `-Force` | Ohne Bestätigung löschen | `$false` |
| `-ProtectedBranches` | Array geschützter Branch-Namen | `@('master', 'main', 'develop', 'development', 'staging', 'production', 'current')` |

## Funktionsweise

1. **Validierung**: Prüft ob Git-Repository existiert und Main-Branch vorhanden ist
2. **Auto-Detection**: Ermittelt automatisch den Default-Branch (master/main)
3. **Branch-Analyse**:
   - Identifiziert gemergte Branches: `git branch --merged`
   - Ermittelt leere Branches: `git rev-list --count`
   - Optional: Remote-Branches analysieren
4. **Sicherheitsprüfung**: Schließt geschützte Branches aus
5. **Bestätigung**: Fragt nach (außer `-Force` oder `-DryRun`)
6. **Löschung**:
   - Lokale Branches: `git branch -d/-D`
   - Remote-Branches: `git push origin --delete`

## Ausgabe

Das Script gibt farbcodierte Statusmeldungen aus:
- **Grün**: Erfolgreiche Löschungen
- **Gelb**: Warnungen, Dry-Run Meldungen
- **Rot**: Fehler beim Löschen
- **Weiß**: Informationen, Zusammenfassungen

### Beispiel-Ausgabe

```
================================================================
  Git Branch Cleanup Tool
================================================================

[12:34:56] [INFO] Konfiguration:
[12:34:56] [INFO]   Repository: .
[12:34:56] [INFO]   Main-Branch: main
[12:34:56] [INFO]   Protected Branches: master, main, develop, ...
[12:34:56] [INFO]   Dry-Run: False

[12:34:56] [INFO] Suche nach Branches die in 'main' gemerged wurden...
[12:34:56] [OK] Gefundene gemergte Branches: 3
[12:34:56] [INFO]   - feature/old-feature (merged)
[12:34:56] [INFO]   - bugfix/fixed-issue (merged)
[12:34:56] [INFO]   - hotfix/emergency-fix (merged)

[12:34:56] [INFO] Suche nach leeren Branches (ohne eigene Commits)...
[12:34:56] [OK] Gefundene leere Branches: 1
[12:34:56] [INFO]   - feature/never-used (empty)

================================================================
[12:34:56] [WARN] Es werden 4 Branch(es) gelöscht:
[12:34:56] [WARN]   Lokale Branches: 4
================================================================

[12:34:57] [INFO] Lösche lokale Branches...
[12:34:57] [OK]   -> Gelöscht: feature/old-feature
[12:34:57] [OK]   -> Gelöscht: bugfix/fixed-issue
[12:34:57] [OK]   -> Gelöscht: hotfix/emergency-fix
[12:34:57] [OK]   -> Gelöscht: feature/never-used

================================================================
[12:34:57] [OK] Cleanup abgeschlossen!
[12:34:57] [OK]   Erfolgreich gelöscht: 4
[12:34:57] [OK]   Fehler: 0
================================================================
```

## Sicherheitsfeatures

### Geschützte Branches

Folgende Branches werden **niemals** gelöscht:
- master
- main
- develop
- development
- staging
- production
- current

Diese Liste kann über den Parameter `-ProtectedBranches` angepasst werden.

### Dry-Run Modus

Mit `-DryRun` kann man sicher testen, welche Branches gelöscht würden:

```powershell
.\Remove-MergedBranches.ps1 -DryRun
```

Es wird nichts gelöscht, nur angezeigt.

### Bestätigung

Ohne `-Force` fragt das Script vor dem Löschen nach Bestätigung:

```
Möchten Sie fortfahren? (J/N):
```

## Hinweise

- Das Script löscht standardmäßig **nur lokale** Branches
- Mit `-IncludeRemote` werden auch Remote-Branches auf origin gelöscht
- Remote-Branches werden mit `git push origin --delete` gelöscht (benötigt Schreibrechte)
- Der aktuell ausgecheckte Branch wird automatisch geschützt
- Bei Fehlern wird zunächst `-d` (safe delete) versucht, dann `-D` (force delete)
- Das Script führt vor Remote-Operationen ein `git fetch --prune` aus
