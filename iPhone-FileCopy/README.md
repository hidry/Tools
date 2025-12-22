# iPhone File Copy

PowerShell-Skript zum Kopieren von Dateien vom iPhone auf den lokalen PC.

## Beschreibung

Dieses Skript verwendet die Windows Shell COM-Schnittstelle, um auf ein per USB verbundenes iPhone zuzugreifen und dessen Inhalte auf den lokalen PC zu kopieren. Es funktioniert mit dem MTP-Protokoll (Media Transfer Protocol), das Windows für die iPhone-Kommunikation verwendet.

## Voraussetzungen

- **Windows 10/11**
- **PowerShell 5.0** oder höher
- **iPhone per USB verbunden**
- iPhone muss **entsperrt** sein
- "**Diesem Computer vertrauen**" muss auf dem iPhone bestätigt sein

## Verwendung

### Alle Dateien kopieren

```powershell
.\Copy-iPhoneFiles.ps1 -DestinationPath "D:\iPhone-Backup"
```

### Nur Fotos/Videos kopieren (DCIM-Ordner)

```powershell
.\Copy-iPhoneFiles.ps1 -SourceFolder "DCIM" -DestinationPath "D:\Meine-Fotos"
```

### Mit Fortschrittsanzeige und Überspringen existierender Dateien

```powershell
.\Copy-iPhoneFiles.ps1 -DestinationPath "D:\Backup" -SkipExisting -ShowProgress
```

## Parameter

| Parameter | Beschreibung | Standard |
|-----------|--------------|----------|
| `-DestinationPath` | Zielverzeichnis auf dem lokalen PC | `.\iPhone-Backup` |
| `-SourceFolder` | Nur bestimmten Ordner kopieren (z.B. "DCIM") | (alle Ordner) |
| `-DeviceName` | Name des Geräts zum Suchen | `Apple iPhone` |
| `-SkipExisting` | Überspringt bereits vorhandene Dateien (gleicher Name + Größe) | Aus |
| `-ShowProgress` | Zeigt detaillierten Fortschritt für jede Datei | Aus |

## Fehlerbehandlung

Das Skript versucht jede Datei **3 Mal** zu kopieren bevor sie als fehlgeschlagen markiert wird. Zwischen den Versuchen wird 2 Sekunden gewartet.

### Log-Datei

Alle fehlgeschlagenen Dateien werden in `failed_files.log` im Zielverzeichnis protokolliert:

```
2024-01-15 14:32:05 | D:\Backup\DCIM\IMG_1234.MOV | Datei wurde nicht erstellt (Timeout)
2024-01-15 14:35:12 | D:\Backup\DCIM\IMG_5678.HEIC | Zugriff verweigert
```

So kannst du später gezielt die fehlgeschlagenen Dateien manuell kopieren.

## Typische iPhone-Ordnerstruktur

| Ordner | Inhalt |
|--------|--------|
| `DCIM` | Fotos und Videos (Camera Roll) |
| `Downloads` | Heruntergeladene Dateien |
| `Books` | iBooks/Apple Books Dateien |
| `PhotoData` | Foto-Metadaten |

## Beispiele

### Backup aller iPhone-Inhalte

```powershell
.\Copy-iPhoneFiles.ps1 -DestinationPath "E:\iPhone-Backup-$(Get-Date -Format 'yyyy-MM-dd')" -ShowProgress
```

### Inkrementelles Foto-Backup

```powershell
.\Copy-iPhoneFiles.ps1 -SourceFolder "DCIM" -DestinationPath "D:\Fotos\iPhone" -SkipExisting -ShowProgress
```

## Hinweise

- Der Kopiervorgang kann bei vielen Dateien längere Zeit dauern
- Das iPhone sollte während des Kopiervorgangs nicht getrennt werden
- Bei großen Dateien (Videos) kann es zu kurzen Pausen kommen
- Die `-SkipExisting` Option vergleicht Dateinamen und Größe, nicht den Inhalt

## Fehlerbehebung

### "iPhone nicht gefunden"

1. Stellen Sie sicher, dass das iPhone per USB verbunden ist
2. Entsperren Sie das iPhone
3. Falls gefragt, tippen Sie auf "Vertrauen" auf dem iPhone
4. Prüfen Sie im Windows Explorer, ob das iPhone unter "Dieser PC" sichtbar ist

### "Interner Speicher nicht gefunden"

- Entsperren Sie das iPhone und warten Sie einige Sekunden
- Trennen Sie das iPhone und verbinden Sie es erneut

### Langsame Übertragung

- MTP ist generell langsamer als normale Dateiübertragungen
- Für bessere Performance: iPhone-Fotos über iCloud oder iTunes synchronisieren
