# Git-Branch-Cleanup

PowerShell-Tool zum automatischen Aufräumen von nicht mehr benötigten Git-Branches.

## Beschreibung

Dieses Script identifiziert und löscht Git-Branches, die nicht mehr benötigt werden:
- **Gemergte Branches**: Branches die bereits vollständig in den Main-Branch gemerged wurden
- **Leere Branches**: Branches ohne eigene Commits (nie etwas geändert wurde)
- **Inaktive Branches (Stale)**: Branches die seit langer Zeit (z.B. >365 Tage) nicht mehr geändert wurden

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

### Inaktive Branches (Stale)

```powershell
# Zeigt inaktive Branches (>365 Tage) an, löscht sie aber NICHT
.\Remove-MergedBranches.ps1

# Inaktive Branches (>1 Jahr) auch löschen
.\Remove-MergedBranches.ps1 -IncludeStale

# Schwellenwert anpassen: Branches älter als 180 Tage
.\Remove-MergedBranches.ps1 -IncludeStale -InactiveDays 180

# Schwellenwert in Monaten: Branches älter als 6 Monate
.\Remove-MergedBranches.ps1 -IncludeStale -InactiveMonths 6

# Nur stale Branches anzeigen (Dry-Run)
.\Remove-MergedBranches.ps1 -DryRun -InactiveDays 365
```

### Erweiterte Verwendung

```powershell
# In einem anderen Repository, mit spezifischem Main-Branch
.\Remove-MergedBranches.ps1 -RepositoryPath "C:\Projekte\MeinRepo" -MainBranch "main"

# Eigene Protected Branches definieren
.\Remove-MergedBranches.ps1 -ProtectedBranches @('master', 'main', 'release')

# Kompletter Cleanup: Remote + Lokal + Stale ohne Bestätigung
.\Remove-MergedBranches.ps1 -IncludeRemote -IncludeStale -Force

# Aggressiver Cleanup: Alle >90 Tage inaktiven Branches
.\Remove-MergedBranches.ps1 -IncludeStale -InactiveDays 90 -DryRun
```

## Parameter

| Parameter | Beschreibung | Standard |
|-----------|--------------|----------|
| `-RepositoryPath` | Pfad zum Git-Repository | `.` (aktuelles Verzeichnis) |
| `-MainBranch` | Name des Haupt-Branches | Auto-Erkennung (master/main) |
| `-DryRun` | Nur anzeigen, nichts löschen | `$false` |
| `-IncludeRemote` | Auch Remote-Branches löschen | `$false` |
| `-IncludeStale` | Inaktive Branches auch löschen | `$false` |
| `-InactiveDays` | Schwellenwert für inaktive Branches (in Tagen) | `365` |
| `-InactiveMonths` | Schwellenwert für inaktive Branches (in Monaten, überschreibt InactiveDays) | `0` |
| `-Force` | Ohne Bestätigung löschen | `$false` |
| `-ProtectedBranches` | Array geschützter Branch-Namen | `@('master', 'main', 'develop', 'development', 'staging', 'production', 'current')` |

## Funktionsweise

1. **Validierung**: Prüft ob Git-Repository existiert und Main-Branch vorhanden ist
2. **Auto-Detection**: Ermittelt automatisch den Default-Branch (master/main)
3. **Branch-Analyse**:
   - Identifiziert gemergte Branches: `git branch --merged`
   - Ermittelt leere Branches: `git rev-list --count`
   - Findet inaktive Branches: `git for-each-ref` mit Commit-Datum, Autor und Anzahl
   - Optional: Remote-Branches analysieren
4. **Sicherheitsprüfung**: Schließt geschützte Branches aus
5. **Stale-Branch-Warnung**: Zeigt inaktive Branches immer an, löscht sie nur mit `-IncludeStale`
6. **Bestätigung**: Fragt nach (außer `-Force` oder `-DryRun`)
7. **Löschung**:
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
[12:34:56] [INFO]   Inaktivitäts-Schwellenwert: 365 Tage
[12:34:56] [INFO]   Include Stale: False
[12:34:56] [INFO]   Dry-Run: False

[12:34:56] [INFO] Suche nach Branches die in 'main' gemerged wurden...
[12:34:56] [OK] Gefundene gemergte Branches: 3
[12:34:56] [INFO]   - feature/old-feature (merged)
[12:34:56] [INFO]   - bugfix/fixed-issue (merged)
[12:34:56] [INFO]   - hotfix/emergency-fix (merged)

[12:34:56] [INFO] Suche nach leeren Branches (ohne eigene Commits)...
[12:34:56] [OK] Gefundene leere Branches: 1
[12:34:56] [INFO]   - feature/never-used (empty)

[12:34:56] [INFO] Suche nach inaktiven Branches (>365 Tage)...
[12:34:56] [WARN] Gefundene inaktive Branches: 2
[12:34:56] [WARN]   - feature/ancient-project (245 Commits, letzter von Max Mustermann am 2024-08-20, 520 Tage inaktiv)
[12:34:56] [WARN]   - experiment/old-test (12 Commits, letzter von Anna Schmidt am 2024-11-08, 410 Tage inaktiv)
[12:34:56] [INFO]   -> Inaktive Branches werden NICHT gelöscht (verwenden Sie -IncludeStale zum Löschen)

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

### Stale Branch Warnung

Inaktive Branches werden **immer angezeigt** als Warnung, aber **standardmäßig NICHT gelöscht**.

Dies gibt Ihnen die Möglichkeit, alte Branches zu sichten, bevor Sie entscheiden, sie zu löschen:

```powershell
# Zeigt inaktive Branches an, löscht sie aber nicht
.\Remove-MergedBranches.ps1

# Löscht inaktive Branches (explizit angefordert)
.\Remove-MergedBranches.ps1 -IncludeStale
```

**Wichtig:** Ein Branch kann wichtige experimentelle Arbeit enthalten, auch wenn er seit einem Jahr nicht mehr geändert wurde. Daher die separate Kontrolle via `-IncludeStale`.

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

- Das Script löscht standardmäßig **nur lokale gemergte und leere** Branches
- **Inaktive Branches** werden nur angezeigt, nicht gelöscht (außer mit `-IncludeStale`)
- Bei inaktiven Branches wird angezeigt: Anzahl Commits, letzter Committer, Datum und Tage inaktiv
- Mit `-IncludeRemote` werden auch Remote-Branches auf origin gelöscht
- Remote-Branches werden mit `git push origin --delete` gelöscht (benötigt Schreibrechte)
- Der aktuell ausgecheckte Branch wird automatisch geschützt
- Bei Fehlern wird zunächst `-d` (safe delete) versucht, dann `-D` (force delete)
- Das Script führt vor Remote-Operationen ein `git fetch --prune` aus
- `-InactiveMonths` überschreibt `-InactiveDays` (1 Monat = 30 Tage)
- Die Inaktivität wird anhand des letzten Commits im Branch ermittelt
