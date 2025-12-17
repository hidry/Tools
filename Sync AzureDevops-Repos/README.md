# Sync AzureDevops-Repos

PowerShell-Tool zur automatischen Synchronisation aller Git-Repositories eines Azure DevOps Projekts.

## Beschreibung

Dieses Script verbindet sich mit einem Azure DevOps Server, listet alle Repositories eines Projekts auf und synchronisiert diese lokal. Bestehende Repositories werden aktualisiert (fetch/pull), neue werden geklont.

## Voraussetzungen

- PowerShell 5.0 oder höher
- Git installiert und im PATH verfügbar
- Azure DevOps Personal Access Token (PAT) mit Repository-Leserechten

## Verwendung

```powershell
.\Sync-Repos.ps1 -Organization "https://myAzureDevOpsServer/tfs/myCollection/" `
                 -Project "myProject" `
                 -Token "myPAT" `
                 -BasePath "C:\myBasePath"
```

## Parameter

| Parameter | Beschreibung | Standard |
|-----------|--------------|----------|
| `-Organization` | URL zur Azure DevOps Organisation/Collection | `https://myAzureDevOpsServer/tfs/myCollection/` |
| `-Project` | Name des Azure DevOps Projekts | `myProject` |
| `-Token` | Personal Access Token für Authentifizierung | `myPAT` |
| `-BasePath` | Lokaler Pfad für geklonte Repositories | `C:\myBasePath` |

## Funktionsweise

1. Authentifizierung mittels PAT gegen Azure DevOps REST API (v7.0)
2. Abruf aller Repositories des angegebenen Projekts
3. Für jedes Repository:
   - **Existiert lokal**: `git fetch` + `git pull` auf Default-Branch
   - **Existiert nicht**: `git clone --single-branch` mit Default-Branch
4. Ausgabe einer Zusammenfassung mit Erfolgs-/Fehlerstatistik

## Ausgabe

Das Script gibt farbcodierte Statusmeldungen aus:
- **Grün**: Erfolgreiche Operationen
- **Gelb**: Warnungen (z.B. Fetch-Fehler)
- **Rot**: Fehler

## Hinweise

- Das Script verwendet `--single-branch` beim Klonen, um nur den Default-Branch zu laden
- Bestehende, nicht-initialisierte Verzeichnisse werden vor dem Klonen gelöscht
- Der Default-Branch wird automatisch aus den Repository-Metadaten ermittelt
