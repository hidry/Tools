<#
.SYNOPSIS
    Kopiert Dateien vom iPhone (MTP-Gerät) auf den lokalen PC.

.DESCRIPTION
    Dieses Skript verwendet die Windows Shell COM-Schnittstelle, um auf das iPhone
    zuzugreifen, das über USB verbunden ist. Es kopiert rekursiv alle Dateien
    oder nur bestimmte Ordner (z.B. DCIM für Fotos) auf den lokalen PC.

.PARAMETER DestinationPath
    Zielverzeichnis auf dem lokalen PC. Standard: .\iPhone-Backup

.PARAMETER SourceFolder
    Optional: Nur einen bestimmten Ordner kopieren (z.B. "DCIM" für Fotos).
    Wenn nicht angegeben, wird der gesamte Inhalt kopiert.

.PARAMETER DeviceName
    Name des Geräts. Standard: "Apple iPhone"

.PARAMETER SkipExisting
    Überspringt bereits existierende Dateien (basierend auf Dateiname und Größe).

.PARAMETER ShowProgress
    Zeigt detaillierten Fortschritt an.

.EXAMPLE
    .\Copy-iPhoneFiles.ps1 -DestinationPath "D:\iPhone-Backup"
    Kopiert alle Dateien vom iPhone nach D:\iPhone-Backup

.EXAMPLE
    .\Copy-iPhoneFiles.ps1 -SourceFolder "DCIM" -DestinationPath "D:\Fotos"
    Kopiert nur den DCIM-Ordner (Fotos/Videos) nach D:\Fotos

.EXAMPLE
    .\Copy-iPhoneFiles.ps1 -SkipExisting -ShowProgress
    Kopiert mit Fortschrittsanzeige und überspringt bereits vorhandene Dateien

.NOTES
    Autor: Claude Code
    Voraussetzungen:
    - iPhone muss per USB verbunden sein
    - iPhone muss entsperrt sein und "Diesem Computer vertrauen" bestätigt haben
    - Windows 10/11
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$DestinationPath = ".\iPhone-Backup",

    [Parameter()]
    [string]$SourceFolder = "",

    [Parameter()]
    [string]$DeviceName = "Apple iPhone",

    [Parameter()]
    [switch]$SkipExisting,

    [Parameter()]
    [switch]$ShowProgress
)

# Statistik-Variablen
$script:TotalFiles = 0
$script:CopiedFiles = 0
$script:SkippedFiles = 0
$script:FailedFiles = 0
$script:TotalBytes = 0
$script:LogFilePath = ""
$script:MaxRetries = 3
$script:RetryWaitSeconds = 2

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("Info", "Success", "Warning", "Error")]
        [string]$Level = "Info"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "Info"    { "White" }
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error"   { "Red" }
    }

    Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
    Write-Host $Message -ForegroundColor $color
}

function Write-FailedFileLog {
    param(
        [string]$FilePath,
        [string]$ErrorMessage
    )

    if ($script:LogFilePath) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntry = "$timestamp | $FilePath | $ErrorMessage"
        Add-Content -Path $script:LogFilePath -Value $logEntry -Encoding UTF8
    }
}

function Get-ShellFolder {
    param(
        [object]$Shell,
        [string]$Path
    )

    # Dieser PC = Shell:MyComputerFolder oder ssfDRIVES (17)
    $myComputer = $Shell.NameSpace(17)

    if (-not $myComputer) {
        throw "Konnte 'Dieser PC' nicht öffnen"
    }

    return $myComputer
}

function Find-MTPDevice {
    param(
        [object]$MyComputer,
        [string]$DeviceName
    )

    Write-Log "Suche nach Gerät: $DeviceName..." -Level Info

    foreach ($item in $MyComputer.Items()) {
        if ($item.Name -like "*$DeviceName*" -or $item.Name -like "*iPhone*") {
            Write-Log "Gerät gefunden: $($item.Name)" -Level Success
            return $item
        }
    }

    # Liste alle verfügbaren Geräte auf
    Write-Log "Verfügbare Geräte unter 'Dieser PC':" -Level Warning
    foreach ($item in $MyComputer.Items()) {
        Write-Log "  - $($item.Name)" -Level Info
    }

    return $null
}

function Get-InternalStorage {
    param(
        [object]$Device
    )

    $deviceFolder = $Device.GetFolder
    if (-not $deviceFolder) {
        throw "Konnte Geräteordner nicht öffnen"
    }

    foreach ($item in $deviceFolder.Items()) {
        if ($item.Name -like "*Internal Storage*" -or $item.Name -like "*Interner Speicher*") {
            Write-Log "Interner Speicher gefunden: $($item.Name)" -Level Success
            return $item
        }
    }

    # Fallback: Erstes Element nehmen
    $firstItem = $deviceFolder.Items() | Select-Object -First 1
    if ($firstItem) {
        Write-Log "Verwende: $($firstItem.Name)" -Level Warning
        return $firstItem
    }

    return $null
}

function Copy-MTPItem {
    param(
        [object]$SourceItem,
        [string]$DestPath,
        [object]$Shell
    )

    $itemName = $SourceItem.Name
    $isFolder = $SourceItem.IsFolder

    if ($isFolder) {
        # Ordner erstellen und rekursiv durchlaufen
        $newDestPath = Join-Path $DestPath $itemName

        if (-not (Test-Path $newDestPath)) {
            New-Item -ItemType Directory -Path $newDestPath -Force | Out-Null
        }

        if ($ShowProgress) {
            Write-Log "Ordner: $itemName" -Level Info
        }

        $folder = $SourceItem.GetFolder
        if ($folder) {
            foreach ($subItem in $folder.Items()) {
                Copy-MTPItem -SourceItem $subItem -DestPath $newDestPath -Shell $Shell
            }
        }
    }
    else {
        # Datei kopieren
        $script:TotalFiles++
        $destFile = Join-Path $DestPath $itemName

        # Dateigröße ermitteln (Extended Property)
        $size = $SourceItem.ExtendedProperty("Size")
        if ($size) {
            $script:TotalBytes += $size
        }

        # Prüfen ob Datei bereits existiert
        if ($SkipExisting -and (Test-Path $destFile)) {
            $existingFile = Get-Item $destFile
            if ($size -and $existingFile.Length -eq $size) {
                $script:SkippedFiles++
                if ($ShowProgress) {
                    Write-Log "Übersprungen (existiert): $itemName" -Level Warning
                }
                return
            }
        }

        # Retry-Logik: 3 Versuche
        $copySuccess = $false
        $lastError = ""

        for ($attempt = 1; $attempt -le $script:MaxRetries; $attempt++) {
            try {
                # Zielordner als Shell-Objekt
                $destFolder = $Shell.NameSpace($DestPath)

                if (-not $destFolder) {
                    throw "Zielordner konnte nicht geöffnet werden: $DestPath"
                }

                # Kopieren mit Shell (FOF_SILENT = 4, FOF_NOCONFIRMATION = 16, FOF_NOERRORUI = 1024)
                # 4 + 16 + 1024 = 1044
                $destFolder.CopyHere($SourceItem, 1044)

                # Kurz warten damit die Kopie abgeschlossen wird
                Start-Sleep -Milliseconds 100

                # Warten bis Datei vollständig kopiert ist
                $timeout = 300 # 5 Minuten max pro Datei
                $waited = 0
                while (-not (Test-Path $destFile) -and $waited -lt $timeout) {
                    Start-Sleep -Seconds 1
                    $waited++
                }

                if (Test-Path $destFile) {
                    # Größenvalidierung: Prüfe ob Datei vollständig kopiert wurde
                    $localFile = Get-Item $destFile
                    $localSize = $localFile.Length

                    if ($size -and $localSize -ne $size) {
                        # Datei unvollständig - löschen und erneut versuchen
                        Remove-Item $destFile -Force -ErrorAction SilentlyContinue
                        throw "Größe stimmt nicht überein (erwartet: $size, kopiert: $localSize)"
                    }

                    # Erfolgreich kopiert und validiert
                    $script:CopiedFiles++
                    if ($ShowProgress) {
                        $sizeStr = if ($size) { " ({0:N2} MB)" -f ($size / 1MB) } else { "" }
                        $retryInfo = if ($attempt -gt 1) { " (Versuch $attempt)" } else { "" }
                        Write-Log "Kopiert: $itemName$sizeStr$retryInfo" -Level Success
                    }
                    $copySuccess = $true
                    break
                }
                else {
                    throw "Datei wurde nicht erstellt (Timeout)"
                }
            }
            catch {
                $lastError = $_.Exception.Message

                if ($attempt -lt $script:MaxRetries) {
                    if ($ShowProgress) {
                        Write-Log "Versuch $attempt fehlgeschlagen für: $itemName - Retry in $($script:RetryWaitSeconds)s..." -Level Warning
                    }
                    Start-Sleep -Seconds $script:RetryWaitSeconds
                }
            }
        }

        # Nach 3 Versuchen fehlgeschlagen
        if (-not $copySuccess) {
            $script:FailedFiles++
            $relativePath = Join-Path $DestPath $itemName
            Write-Log "Fehler nach $($script:MaxRetries) Versuchen: $itemName - $lastError" -Level Error
            Write-FailedFileLog -FilePath $relativePath -ErrorMessage $lastError
        }
    }
}

function Copy-FromMTP {
    param(
        [object]$SourceFolder,
        [string]$DestPath,
        [object]$Shell,
        [string]$FilterFolder = ""
    )

    $folder = $SourceFolder.GetFolder
    if (-not $folder) {
        throw "Konnte Quellordner nicht öffnen"
    }

    if ($FilterFolder) {
        # Nur bestimmten Unterordner kopieren
        $found = $false
        foreach ($item in $folder.Items()) {
            if ($item.Name -eq $FilterFolder -or $item.Name -like "*$FilterFolder*") {
                Write-Log "Kopiere Ordner: $($item.Name)" -Level Info
                Copy-MTPItem -SourceItem $item -DestPath $DestPath -Shell $Shell
                $found = $true
                break
            }
        }

        if (-not $found) {
            Write-Log "Ordner '$FilterFolder' nicht gefunden. Verfügbare Ordner:" -Level Error
            foreach ($item in $folder.Items()) {
                Write-Log "  - $($item.Name)" -Level Info
            }
        }
    }
    else {
        # Alles kopieren
        foreach ($item in $folder.Items()) {
            Copy-MTPItem -SourceItem $item -DestPath $DestPath -Shell $Shell
        }
    }
}

# Hauptprogramm
try {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "   iPhone File Copy Tool" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    # Zielverzeichnis erstellen
    $DestinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DestinationPath)

    if (-not (Test-Path $DestinationPath)) {
        Write-Log "Erstelle Zielverzeichnis: $DestinationPath" -Level Info
        New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    }

    Write-Log "Zielverzeichnis: $DestinationPath" -Level Info

    # Log-Datei für fehlgeschlagene Dateien initialisieren
    $script:LogFilePath = Join-Path $DestinationPath "failed_files.log"

    # Shell COM-Objekt erstellen
    $shell = New-Object -ComObject Shell.Application

    # Dieser PC öffnen
    $myComputer = Get-ShellFolder -Shell $shell -Path "MyComputer"

    # iPhone finden
    $device = Find-MTPDevice -MyComputer $myComputer -DeviceName $DeviceName

    if (-not $device) {
        throw "iPhone nicht gefunden. Bitte stellen Sie sicher, dass:`n  - Das iPhone per USB verbunden ist`n  - Das iPhone entsperrt ist`n  - Sie 'Diesem Computer vertrauen' bestätigt haben"
    }

    # Internal Storage finden
    $storage = Get-InternalStorage -Device $device

    if (-not $storage) {
        throw "Interner Speicher nicht gefunden"
    }

    # Dateien kopieren
    $startTime = Get-Date
    Write-Host ""
    Write-Log "Starte Kopiervorgang..." -Level Info
    Write-Host ""

    Copy-FromMTP -SourceFolder $storage -DestPath $DestinationPath -Shell $shell -FilterFolder $SourceFolder

    $endTime = Get-Date
    $duration = $endTime - $startTime

    # Zusammenfassung
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "   Zusammenfassung" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Log "Dauer: $($duration.ToString('hh\:mm\:ss'))" -Level Info
    Write-Log "Dateien gefunden: $script:TotalFiles" -Level Info
    Write-Log "Erfolgreich kopiert: $script:CopiedFiles" -Level Success

    if ($script:SkippedFiles -gt 0) {
        Write-Log "Übersprungen: $script:SkippedFiles" -Level Warning
    }

    if ($script:FailedFiles -gt 0) {
        Write-Log "Fehlgeschlagen: $script:FailedFiles" -Level Error
        Write-Log "Details siehe: $script:LogFilePath" -Level Warning
    }

    if ($script:TotalBytes -gt 0) {
        Write-Log "Gesamtgröße: $("{0:N2} GB" -f ($script:TotalBytes / 1GB))" -Level Info
    }

    Write-Host ""
    Write-Log "Dateien wurden nach '$DestinationPath' kopiert." -Level Success
}
catch {
    Write-Log "Fehler: $($_.Exception.Message)" -Level Error
    exit 1
}
finally {
    # COM-Objekt freigeben
    if ($shell) {
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null
    }
}
