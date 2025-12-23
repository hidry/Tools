<#
.SYNOPSIS
    Konvertiert iPhone DCIM-Backup fuer Samsung Galaxy S23 kompatible Struktur.

.DESCRIPTION
    Dieses Skript bereitet iPhone-Medien so auf, dass sie auf einem Samsung Galaxy S23
    wie native Aufnahmen erscheinen:
    - Umbenennung nach Samsung-Namenskonvention (YYYYMMDD_HHMMSS)
    - Konvertierung von HEIC zu JPG (optional)
    - Konvertierung von MOV zu MP4 (optional)
    - Samsung-kompatible Ordnerstruktur (DCIM/Camera/)
    - Erhaltung der EXIF-Metadaten

.PARAMETER SourcePath
    Pfad zum iPhone DCIM-Backup-Ordner.

.PARAMETER DestinationPath
    Zielordner fuer die Samsung-kompatiblen Dateien.

.PARAMETER ConvertHEIC
    Konvertiert HEIC-Dateien zu JPG (benoetigt ImageMagick oder Windows HEIC-Codec).

.PARAMETER ConvertMOV
    Konvertiert MOV-Dateien zu MP4 (benoetigt FFmpeg).

.PARAMETER KeepOriginals
    Behaelt Originaldateien zusaetzlich zu konvertierten Dateien.

.PARAMETER PreserveLivePhotos
    Verknuepft Live Photo Video-Komponenten mit den Fotos.

.PARAMETER SimulateOnly
    Keine Aenderungen durchfuehren, nur simulieren.

.EXAMPLE
    .\Convert-iPhoneToSamsung.ps1 -SourcePath "D:\iPhone-Backup\DCIM" -DestinationPath "E:\Samsung-Import"

.EXAMPLE
    .\Convert-iPhoneToSamsung.ps1 -SourcePath ".\DCIM" -DestinationPath ".\Output" -ConvertHEIC -ConvertMOV

.EXAMPLE
    .\Convert-iPhoneToSamsung.ps1 -SourcePath ".\DCIM" -DestinationPath ".\Output" -SimulateOnly

.NOTES
    Autor: Claude
    Version: 1.2
    Datum: 2024-12-23

    Voraussetzungen:
    - PowerShell 5.1 oder hoeher
    - Fuer HEIC-Konvertierung: ImageMagick (magick.exe) oder Windows HEIC-Codec
    - Fuer MOV-Konvertierung: FFmpeg (ffmpeg.exe)
    - Fuer EXIF-Daten: ExifTool (exiftool.exe) - optional aber empfohlen
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, HelpMessage = "Pfad zum iPhone DCIM-Backup-Ordner")]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$SourcePath,

    [Parameter(Mandatory = $true, HelpMessage = "Zielordner fuer Samsung-kompatible Dateien")]
    [string]$DestinationPath,

    [Parameter(HelpMessage = "HEIC zu JPG konvertieren")]
    [switch]$ConvertHEIC,

    [Parameter(HelpMessage = "MOV zu MP4 konvertieren")]
    [switch]$ConvertMOV,

    [Parameter(HelpMessage = "Originaldateien behalten")]
    [switch]$KeepOriginals,

    [Parameter(HelpMessage = "Live Photos verknuepfen")]
    [switch]$PreserveLivePhotos,

    [Parameter(HelpMessage = "Keine Aenderungen durchfuehren, nur simulieren")]
    [switch]$SimulateOnly
)

#region Konfiguration

$script:Config = @{
    # Samsung Ordnerstruktur
    SamsungCameraFolder = "DCIM\Camera"
    SamsungScreenshotFolder = "DCIM\Screenshots"

    # Samsung Dateinamen-Praefixe
    PhotoPrefix = ""  # Samsung verwendet kein Praefix, nur Datum_Zeit
    VideoPrefix = ""
    ScreenshotPrefix = "Screenshot_"

    # Unterstuetzte Dateitypen
    PhotoExtensions = @('.jpg', '.jpeg', '.png', '.heic', '.heif', '.dng', '.raw')
    VideoExtensions = @('.mov', '.mp4', '.m4v', '.avi', '.3gp')

    # Tool-Pfade (werden automatisch gesucht)
    ExifToolPath = $null
    FFmpegPath = $null
    ImageMagickPath = $null

    # Konvertierungs-Flags (werden von Parametern initialisiert)
    DoConvertHEIC = $false
    DoConvertMOV = $false

    # Statistiken
    Stats = @{
        TotalFiles = 0
        ProcessedPhotos = 0
        ProcessedVideos = 0
        ConvertedHEIC = 0
        ConvertedMOV = 0
        Errors = 0
        Skipped = 0
    }
}

# Parameter in Config uebernehmen
$script:Config.DoConvertHEIC = $ConvertHEIC.IsPresent
$script:Config.DoConvertMOV = $ConvertMOV.IsPresent

#endregion

#region Hilfsfunktionen

function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('Info', 'Warning', 'Error', 'Success', 'Debug')]
        [string]$Level = 'Info'
    )

    $colors = @{
        'Info'    = 'Cyan'
        'Warning' = 'Yellow'
        'Error'   = 'Red'
        'Success' = 'Green'
        'Debug'   = 'Gray'
    }

    $prefix = @{
        'Info'    = '[INFO]'
        'Warning' = '[WARN]'
        'Error'   = '[FEHLER]'
        'Success' = '[OK]'
        'Debug'   = '[DEBUG]'
    }

    if ($Level -eq 'Debug' -and -not $VerbosePreference) {
        return
    }

    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] $($prefix[$Level]) $Message" -ForegroundColor $colors[$Level]
}

function Find-ExternalTools {
    <#
    .SYNOPSIS
        Sucht nach externen Tools (ExifTool, FFmpeg, ImageMagick).
    #>

    Write-Log "Suche nach externen Tools..." -Level Info

    # ExifTool suchen
    $exifToolLocations = @(
        "exiftool.exe",
        "exiftool",
        "$env:ProgramFiles\ExifTool\exiftool.exe",
        "$env:LOCALAPPDATA\ExifTool\exiftool.exe",
        "C:\Tools\exiftool.exe"
    )

    foreach ($path in $exifToolLocations) {
        if (Get-Command $path -ErrorAction SilentlyContinue) {
            $script:Config.ExifToolPath = $path
            Write-Log "ExifTool gefunden: $path" -Level Success
            break
        }
    }

    if (-not $script:Config.ExifToolPath) {
        Write-Log "ExifTool nicht gefunden - Datum wird aus Dateiname/Dateidatum extrahiert" -Level Warning
    }

    # FFmpeg suchen
    if ($script:Config.DoConvertMOV) {
        $ffmpegLocations = @(
            "ffmpeg.exe",
            "ffmpeg",
            "$env:ProgramFiles\FFmpeg\bin\ffmpeg.exe",
            "C:\Tools\ffmpeg\bin\ffmpeg.exe"
        )

        foreach ($path in $ffmpegLocations) {
            if (Get-Command $path -ErrorAction SilentlyContinue) {
                $script:Config.FFmpegPath = $path
                Write-Log "FFmpeg gefunden: $path" -Level Success
                break
            }
        }

        if (-not $script:Config.FFmpegPath) {
            Write-Log "FFmpeg nicht gefunden - MOV-Konvertierung deaktiviert" -Level Warning
            $script:Config.DoConvertMOV = $false
        }
    }

    # ImageMagick suchen
    if ($script:Config.DoConvertHEIC) {
        $magickLocations = @(
            "magick.exe",
            "magick",
            "$env:ProgramFiles\ImageMagick-*\magick.exe",
            "C:\Tools\ImageMagick\magick.exe"
        )

        foreach ($path in $magickLocations) {
            $resolved = Resolve-Path $path -ErrorAction SilentlyContinue
            if ($resolved -and (Get-Command $resolved.Path -ErrorAction SilentlyContinue)) {
                $script:Config.ImageMagickPath = $resolved.Path
                Write-Log "ImageMagick gefunden: $($resolved.Path)" -Level Success
                break
            }
        }

        if (-not $script:Config.ImageMagickPath) {
            Write-Log "ImageMagick nicht gefunden - HEIC-Konvertierung deaktiviert" -Level Warning
            $script:Config.DoConvertHEIC = $false
        }
    }
}

function Get-MediaDateTime {
    <#
    .SYNOPSIS
        Extrahiert das Aufnahmedatum aus einer Mediendatei.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    $dateTime = $null

    # Methode 1: ExifTool (genaueste Methode)
    if ($script:Config.ExifToolPath) {
        try {
            # ExifTool aufrufen - kann mehrere Zeilen zurueckgeben
            $exifOutput = & $script:Config.ExifToolPath -DateTimeOriginal -CreateDate -MediaCreateDate -s3 -d "%Y%m%d_%H%M%S" $FilePath 2>$null

            # Falls Array, jede Zeile pruefen und erste gueltige nehmen
            if ($exifOutput) {
                # In Array konvertieren falls noch nicht
                $lines = @($exifOutput)

                foreach ($line in $lines) {
                    $trimmed = "$line".Trim()
                    if ($trimmed -match '^\d{8}_\d{6}$') {
                        $dateTime = $trimmed
                        Write-Log "EXIF-Datum gefunden: $dateTime fuer $(Split-Path $FilePath -Leaf)" -Level Debug
                        return [string]$dateTime
                    }
                }
            }
        }
        catch {
            Write-Log "ExifTool-Fehler fuer $FilePath : $_" -Level Debug
        }
    }

    # Methode 2: .NET Image Klasse fuer Bilder
    $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
    if ($extension -in @('.jpg', '.jpeg', '.png', '.tiff')) {
        try {
            Add-Type -AssemblyName System.Drawing -ErrorAction SilentlyContinue
            $image = [System.Drawing.Image]::FromFile($FilePath)

            # Property ID 36867 = DateTimeOriginal
            try {
                $propItem = $image.GetPropertyItem(36867)
                if ($propItem) {
                    $dateString = [System.Text.Encoding]::ASCII.GetString($propItem.Value).Trim([char]0)
                    # Format: "2023:12:15 14:30:22" -> "20231215_143022"
                    if ($dateString -match '(\d{4}):(\d{2}):(\d{2})\s+(\d{2}):(\d{2}):(\d{2})') {
                        $dateTime = "$($Matches[1])$($Matches[2])$($Matches[3])_$($Matches[4])$($Matches[5])$($Matches[6])"
                    }
                }
            }
            catch {
                # Property nicht vorhanden - ignorieren
            }
            $image.Dispose()

            if ($dateTime) {
                Write-Log ".NET EXIF-Datum gefunden: $dateTime" -Level Debug
                return [string]$dateTime
            }
        }
        catch {
            Write-Log ".NET EXIF-Fehler: $_" -Level Debug
        }
    }

    # Methode 3: iPhone Dateiname parsen (IMG_1234.JPG enthaelt leider kein Datum)
    # Aber einige Backups haben das Datum im Ordnernamen
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)

    # Pruefe auf Datum im Dateinamen (z.B. "Photo 2023-12-15 14-30-22" oder aehnlich)
    if ($fileName -match '(\d{4})[-_]?(\d{2})[-_]?(\d{2})[-_\s]+(\d{2})[-_]?(\d{2})[-_]?(\d{2})') {
        $dateTime = "$($Matches[1])$($Matches[2])$($Matches[3])_$($Matches[4])$($Matches[5])$($Matches[6])"
        return [string]$dateTime
    }

    # Methode 4: Datei-Erstellungsdatum (letzte Option)
    $fileInfo = Get-Item -LiteralPath $FilePath
    $creationTime = $fileInfo.CreationTime
    $lastWriteTime = $fileInfo.LastWriteTime

    # Verwende das aeltere Datum (wahrscheinlicher das Aufnahmedatum)
    $useDate = if ($creationTime -lt $lastWriteTime) { $creationTime } else { $lastWriteTime }
    $dateTime = $useDate.ToString("yyyyMMdd_HHmmss")

    Write-Log "Verwende Dateidatum: $dateTime fuer $(Split-Path $FilePath -Leaf)" -Level Debug
    return [string]$dateTime
}

function Get-SamsungFileName {
    <#
    .SYNOPSIS
        Generiert einen Samsung-kompatiblen Dateinamen.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$DateTime,

        [Parameter(Mandatory)]
        [string]$Extension,

        [string]$Type = "Photo",

        [int]$Counter = 0
    )

    # Samsung Format: YYYYMMDD_HHMMSS.jpg oder 20231215_143022.jpg
    # Bei Duplikaten: YYYYMMDD_HHMMSS_001.jpg

    $baseName = $DateTime

    if ($Counter -gt 0) {
        $baseName = "{0}_{1:D3}" -f $DateTime, $Counter
    }

    # Extension normalisieren
    $ext = $Extension.ToLower()
    if ($ext -eq '.heic' -or $ext -eq '.heif') {
        if ($script:Config.DoConvertHEIC) {
            $ext = '.jpg'
        }
    }
    elseif ($ext -eq '.mov') {
        if ($script:Config.DoConvertMOV) {
            $ext = '.mp4'
        }
    }

    return "$baseName$ext"
}

function Convert-HEICToJPG {
    <#
    .SYNOPSIS
        Konvertiert HEIC/HEIF zu JPG mit Metadaten-Erhaltung.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$SourceFile,

        [Parameter(Mandatory)]
        [string]$DestinationFile
    )

    if (-not $script:Config.ImageMagickPath) {
        return $false
    }

    try {
        Write-Log "Konvertiere HEIC: $(Split-Path $SourceFile -Leaf)" -Level Debug

        # ImageMagick Konvertierung mit Qualitaetserhaltung
        $magickArgs = @(
            "`"$SourceFile`""
            "-quality", "95"
            "-auto-orient"
            "`"$DestinationFile`""
        )

        $process = Start-Process -FilePath $script:Config.ImageMagickPath -ArgumentList $magickArgs -Wait -NoNewWindow -PassThru

        if ($process.ExitCode -eq 0 -and (Test-Path -LiteralPath $DestinationFile)) {
            # EXIF-Daten kopieren wenn ExifTool verfuegbar
            if ($script:Config.ExifToolPath) {
                & $script:Config.ExifToolPath -TagsFromFile $SourceFile -all:all -overwrite_original $DestinationFile 2>$null
            }

            $script:Config.Stats.ConvertedHEIC++
            return $true
        }
    }
    catch {
        Write-Log "HEIC-Konvertierung fehlgeschlagen: $_" -Level Error
    }

    return $false
}

function Convert-MOVToMP4 {
    <#
    .SYNOPSIS
        Konvertiert MOV zu MP4 mit Metadaten-Erhaltung.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$SourceFile,

        [Parameter(Mandatory)]
        [string]$DestinationFile
    )

    if (-not $script:Config.FFmpegPath) {
        return $false
    }

    try {
        Write-Log "Konvertiere MOV: $(Split-Path $SourceFile -Leaf)" -Level Debug

        # FFmpeg Konvertierung - kopiert Streams ohne Reencoding wenn moeglich
        $ffmpegArgs = @(
            "-i", "`"$SourceFile`""
            "-c:v", "copy"
            "-c:a", "aac"
            "-movflags", "+faststart"
            "-map_metadata", "0"
            "-y"
            "`"$DestinationFile`""
        )

        $process = Start-Process -FilePath $script:Config.FFmpegPath -ArgumentList $ffmpegArgs -Wait -NoNewWindow -PassThru -RedirectStandardError "$env:TEMP\ffmpeg_error.log"

        if ($process.ExitCode -eq 0 -and (Test-Path -LiteralPath $DestinationFile)) {
            $script:Config.Stats.ConvertedMOV++
            return $true
        }
        else {
            # Fallback: Re-encode wenn Copy fehlschlaegt
            $ffmpegArgs = @(
                "-i", "`"$SourceFile`""
                "-c:v", "libx264"
                "-preset", "fast"
                "-crf", "18"
                "-c:a", "aac"
                "-b:a", "192k"
                "-movflags", "+faststart"
                "-map_metadata", "0"
                "-y"
                "`"$DestinationFile`""
            )

            $process = Start-Process -FilePath $script:Config.FFmpegPath -ArgumentList $ffmpegArgs -Wait -NoNewWindow -PassThru

            if ($process.ExitCode -eq 0 -and (Test-Path -LiteralPath $DestinationFile)) {
                $script:Config.Stats.ConvertedMOV++
                return $true
            }
        }
    }
    catch {
        Write-Log "MOV-Konvertierung fehlgeschlagen: $_" -Level Error
    }

    return $false
}

function Find-LivePhotoComponents {
    <#
    .SYNOPSIS
        Findet zusammengehoerige Live Photo Komponenten (Bild + Video).
    #>
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo[]]$Files
    )

    $livePhotos = @{}

    foreach ($file in $Files) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $extension = $file.Extension.ToLower()

        # iPhone Live Photos haben gleichnamige JPG/HEIC und MOV Dateien
        if (-not $livePhotos.ContainsKey($baseName)) {
            $livePhotos[$baseName] = @{
                Photo = $null
                Video = $null
            }
        }

        if ($extension -in $script:Config.PhotoExtensions) {
            $livePhotos[$baseName].Photo = $file.FullName
        }
        elseif ($extension -in $script:Config.VideoExtensions) {
            # Kleine MOV-Dateien (< 5MB, < 3 Sekunden) sind wahrscheinlich Live Photo Videos
            if ($file.Length -lt 5MB) {
                $livePhotos[$baseName].Video = $file.FullName
            }
        }
    }

    # Nur Paare zurueckgeben die sowohl Foto als auch Video haben
    return $livePhotos.GetEnumerator() | Where-Object {
        $_.Value.Photo -and $_.Value.Video
    } | ForEach-Object { $_.Value }
}

function Process-MediaFile {
    <#
    .SYNOPSIS
        Verarbeitet eine einzelne Mediendatei.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$SourceFile,

        [Parameter(Mandatory)]
        [string]$DestinationFolder,

        [Parameter(Mandatory)]
        [hashtable]$ProcessedDates,

        [Parameter(Mandatory)]
        [bool]$IsSimulation
    )

    $fileInfo = Get-Item -LiteralPath $SourceFile
    $extension = $fileInfo.Extension.ToLower()

    # Typ bestimmen
    $isPhoto = $extension -in $script:Config.PhotoExtensions
    $isVideo = $extension -in $script:Config.VideoExtensions

    if (-not $isPhoto -and -not $isVideo) {
        Write-Log "Ueberspringe unbekannten Dateityp: $($fileInfo.Name)" -Level Debug
        $script:Config.Stats.Skipped++
        return
    }

    # Aufnahmedatum extrahieren
    $dateTime = Get-MediaDateTime -FilePath $SourceFile

    if (-not $dateTime) {
        Write-Log "Konnte kein Datum ermitteln fuer: $($fileInfo.Name)" -Level Warning
        $dateTime = "19700101_000000"
    }

    # Sicherstellen dass dateTime ein String ist
    $dateTime = [string]$dateTime

    # Duplikat-Zaehler fuer gleiches Datum
    $counter = 0
    while ($ProcessedDates.ContainsKey("${dateTime}_${counter}")) {
        $counter++
    }
    $ProcessedDates["${dateTime}_${counter}"] = $true

    # Ziel-Dateiname generieren
    $targetExtension = $extension
    $needsConversion = $false

    if ($isPhoto -and $extension -in @('.heic', '.heif') -and $script:Config.DoConvertHEIC) {
        $targetExtension = '.jpg'
        $needsConversion = $true
    }
    elseif ($isVideo -and $extension -eq '.mov' -and $script:Config.DoConvertMOV) {
        $targetExtension = '.mp4'
        $needsConversion = $true
    }

    $newFileName = Get-SamsungFileName -DateTime $dateTime -Extension $targetExtension -Counter $counter
    $destinationFile = Join-Path $DestinationFolder $newFileName

    # Simulation Modus
    if ($IsSimulation) {
        Write-Log "[SIMULATION] Wuerde verarbeiten: $($fileInfo.Name) -> $newFileName" -Level Info
        return
    }

    # Verarbeitung
    try {
        if ($needsConversion) {
            if ($isPhoto -and $extension -in @('.heic', '.heif')) {
                $success = Convert-HEICToJPG -SourceFile $SourceFile -DestinationFile $destinationFile
                if (-not $success) {
                    # Fallback: Kopiere Original
                    Copy-Item -LiteralPath $SourceFile -Destination $destinationFile -Force
                }
            }
            elseif ($isVideo -and $extension -eq '.mov') {
                $success = Convert-MOVToMP4 -SourceFile $SourceFile -DestinationFile $destinationFile
                if (-not $success) {
                    # Fallback: Kopiere Original mit neuer Extension
                    $destinationFile = Join-Path $DestinationFolder (Get-SamsungFileName -DateTime $dateTime -Extension '.mov' -Counter $counter)
                    Copy-Item -LiteralPath $SourceFile -Destination $destinationFile -Force
                }
            }
        }
        else {
            Copy-Item -LiteralPath $SourceFile -Destination $destinationFile -Force
        }

        # Dateidatum auf Aufnahmedatum setzen
        if (Test-Path -LiteralPath $destinationFile) {
            try {
                $parsedDate = [DateTime]::ParseExact($dateTime, "yyyyMMdd_HHmmss", $null)
                $destFileInfo = Get-Item -LiteralPath $destinationFile
                $destFileInfo.CreationTime = $parsedDate
                $destFileInfo.LastWriteTime = $parsedDate
            }
            catch {
                Write-Log "Konnte Dateidatum nicht setzen: $_" -Level Debug
            }
        }

        if ($isPhoto) {
            $script:Config.Stats.ProcessedPhotos++
        }
        else {
            $script:Config.Stats.ProcessedVideos++
        }

        Write-Log "Verarbeitet: $($fileInfo.Name) -> $newFileName" -Level Success
    }
    catch {
        Write-Log "Fehler bei $($fileInfo.Name): $_" -Level Error
        $script:Config.Stats.Errors++
    }
}

#endregion

#region Hauptprogramm

function Start-Conversion {
    <#
    .SYNOPSIS
        Hauptfunktion zur Konvertierung.
    #>

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "  iPhone zu Samsung DCIM Konverter" -ForegroundColor Cyan
    Write-Host "  Version 1.2" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""

    # Parameter anzeigen
    Write-Log "Quellordner: $SourcePath" -Level Info
    Write-Log "Zielordner: $DestinationPath" -Level Info
    Write-Log "HEIC konvertieren: $($script:Config.DoConvertHEIC)" -Level Info
    Write-Log "MOV konvertieren: $($script:Config.DoConvertMOV)" -Level Info
    Write-Log "Originale behalten: $KeepOriginals" -Level Info

    if ($SimulateOnly) {
        Write-Log "SIMULATIONSMODUS AKTIV - Keine Aenderungen werden durchgefuehrt" -Level Warning
    }

    Write-Host ""

    # Externe Tools suchen
    Find-ExternalTools

    Write-Host ""

    # Zielordner erstellen
    $cameraFolder = Join-Path $DestinationPath $script:Config.SamsungCameraFolder

    if (-not $SimulateOnly) {
        if (-not (Test-Path -LiteralPath $cameraFolder)) {
            New-Item -Path $cameraFolder -ItemType Directory -Force | Out-Null
            Write-Log "Zielordner erstellt: $cameraFolder" -Level Info
        }
    }

    # Alle Mediendateien sammeln
    Write-Log "Scanne Quellordner..." -Level Info

    $allExtensions = $script:Config.PhotoExtensions + $script:Config.VideoExtensions
    $mediaFiles = Get-ChildItem -LiteralPath $SourcePath -Recurse -File | Where-Object {
        $_.Extension.ToLower() -in $allExtensions
    }

    $script:Config.Stats.TotalFiles = @($mediaFiles).Count
    Write-Log "Gefundene Mediendateien: $($script:Config.Stats.TotalFiles)" -Level Info

    if ($script:Config.Stats.TotalFiles -eq 0) {
        Write-Log "Keine Mediendateien gefunden!" -Level Warning
        return
    }

    Write-Host ""

    # Live Photos identifizieren (optional)
    if ($PreserveLivePhotos) {
        Write-Log "Identifiziere Live Photos..." -Level Info
        $livePhotoPairs = Find-LivePhotoComponents -Files $mediaFiles
        Write-Log "Gefundene Live Photo Paare: $(@($livePhotoPairs).Count)" -Level Info
    }

    # Fortschrittsanzeige
    $processedDates = @{}
    $current = 0
    $total = $script:Config.Stats.TotalFiles

    foreach ($file in $mediaFiles) {
        $current++
        $percentComplete = [math]::Round(($current / $total) * 100, 1)

        Write-Progress -Activity "Verarbeite Mediendateien" -Status "$current von $total - $($file.Name)" -PercentComplete $percentComplete

        Process-MediaFile -SourceFile $file.FullName -DestinationFolder $cameraFolder -ProcessedDates $processedDates -IsSimulation $SimulateOnly.IsPresent
    }

    Write-Progress -Activity "Verarbeite Mediendateien" -Completed

    # Statistiken anzeigen
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "           ZUSAMMENFASSUNG" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Gesamt gefunden:     $($script:Config.Stats.TotalFiles)" -ForegroundColor White
    Write-Host "  Fotos verarbeitet:   $($script:Config.Stats.ProcessedPhotos)" -ForegroundColor Green
    Write-Host "  Videos verarbeitet:  $($script:Config.Stats.ProcessedVideos)" -ForegroundColor Green

    if ($script:Config.DoConvertHEIC) {
        Write-Host "  HEIC konvertiert:    $($script:Config.Stats.ConvertedHEIC)" -ForegroundColor Yellow
    }
    if ($script:Config.DoConvertMOV) {
        Write-Host "  MOV konvertiert:     $($script:Config.Stats.ConvertedMOV)" -ForegroundColor Yellow
    }

    Write-Host "  Uebersprungen:       $($script:Config.Stats.Skipped)" -ForegroundColor Gray
    $errorColor = if ($script:Config.Stats.Errors -gt 0) { 'Red' } else { 'Green' }
    Write-Host "  Fehler:              $($script:Config.Stats.Errors)" -ForegroundColor $errorColor
    Write-Host ""

    if (-not $SimulateOnly) {
        Write-Host "  Ausgabe: $cameraFolder" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Kopiere den Inhalt von '$cameraFolder'" -ForegroundColor Yellow
        Write-Host "  auf dein Samsung unter: Interner Speicher/DCIM/Camera" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
}

# Skript ausfuehren
Start-Conversion

#endregion
