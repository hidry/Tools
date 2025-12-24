<#
.SYNOPSIS
    Synchronizes media files from Windows to Android device via ADB with validation and retry mechanism.

.DESCRIPTION
    This script copies photos and videos from a Windows PC to a Samsung Galaxy device (or any Android device)
    using ADB (Android Debug Bridge). It preserves timestamps, validates file transfers, includes retry logic,
    and triggers the Android Media Scanner so files appear correctly in the Gallery app.

.PARAMETER SourcePath
    The source directory on Windows containing files to transfer.

.PARAMETER DestinationPath
    The destination path on the Android device (e.g., /sdcard/DCIM/Camera).
    Default: /sdcard/DCIM/Camera

.PARAMETER FileFilter
    File filter pattern (e.g., *.jpg, *.mp4). Default: * (all files)

.PARAMETER Recursive
    If specified, processes subdirectories recursively.

.PARAMETER MaxRetries
    Maximum number of retry attempts per file. Default: 3

.PARAMETER LogPath
    Path for the log file. Default: .\Sync-AndroidMedia-Log.txt

.EXAMPLE
    .\Sync-AndroidMedia.ps1 -SourcePath "C:\Users\John\Pictures\Vacation" -DestinationPath "/sdcard/DCIM/Vacation"

.EXAMPLE
    .\Sync-AndroidMedia.ps1 -SourcePath "C:\Photos" -Recursive -FileFilter "*.jpg"

.NOTES
    Requirements:
    - ADB must be installed and in PATH
    - USB Debugging must be enabled on Android device
    - Device must be connected via USB and authorized
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path $_ -PathType Container})]
    [string]$SourcePath,

    [Parameter(Mandatory = $false)]
    [string]$DestinationPath = "/sdcard/DCIM/Camera",

    [Parameter(Mandatory = $false)]
    [string]$FileFilter = "*",

    [Parameter(Mandatory = $false)]
    [switch]$Recursive,

    [Parameter(Mandatory = $false)]
    [int]$MaxRetries = 3,

    [Parameter(Mandatory = $false)]
    [string]$LogPath = ".\Sync-AndroidMedia-Log.txt"
)

# Initialize counters and collections
$script:SuccessCount = 0
$script:FailureCount = 0
$script:SkippedCount = 0
$script:FailedFiles = @()
$script:StartTime = Get-Date

# Initialize log file
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO", "SUCCESS", "WARNING", "ERROR")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    # Write to console with color
    switch ($Level) {
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        "WARNING" { Write-Host $logMessage -ForegroundColor Yellow }
        "ERROR"   { Write-Host $logMessage -ForegroundColor Red }
        default   { Write-Host $logMessage }
    }

    # Write to log file
    Add-Content -Path $LogPath -Value $logMessage
}

# Check if ADB is available
function Test-AdbAvailable {
    try {
        $adbVersion = & adb version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "ADB is available: $($adbVersion[0])" -Level "SUCCESS"
            return $true
        }
    }
    catch {
        Write-Log "ADB is not installed or not in PATH. Please install ADB and add it to your PATH environment variable." -Level "ERROR"
        return $false
    }
    return $false
}

# Check if Android device is connected
function Test-DeviceConnected {
    $devices = & adb devices 2>&1
    $deviceLines = $devices | Select-String -Pattern "device$" | Where-Object { $_ -notmatch "List of devices" }

    if ($deviceLines) {
        Write-Log "Android device connected and authorized" -Level "SUCCESS"
        return $true
    }
    else {
        Write-Log "No Android device detected. Please connect your device and ensure USB Debugging is enabled and authorized." -Level "ERROR"
        return $false
    }
}

# Get file size on Android device
function Get-AndroidFileSize {
    param([string]$FilePath)

    try {
        $output = & adb shell "if [ -f '$FilePath' ]; then stat -c%s '$FilePath'; else echo 'NOTFOUND'; fi" 2>&1
        if ($output -eq "NOTFOUND" -or [string]::IsNullOrWhiteSpace($output)) {
            return -1
        }
        return [long]$output.Trim()
    }
    catch {
        return -1
    }
}

# Convert DateTime to Android touch format (YYYYMMDDhhmm.ss)
function ConvertTo-AndroidTimestamp {
    param([DateTime]$DateTime)
    return $DateTime.ToString("yyyyMMddHHmm.ss")
}

# Transfer file with retry mechanism
function Copy-FileToAndroid {
    param(
        [System.IO.FileInfo]$File,
        [string]$AndroidDestPath
    )

    $fileName = $File.Name
    $androidFilePath = "$AndroidDestPath/$fileName".Replace('\', '/')
    $sourceSize = $File.Length

    Write-Log "Processing: $fileName ($([math]::Round($sourceSize / 1MB, 2)) MB)"

    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        try {
            if ($attempt -gt 1) {
                $waitTime = [math]::Pow(2, $attempt - 1)
                Write-Log "Retry attempt $attempt/$MaxRetries after ${waitTime}s delay..." -Level "WARNING"
                Start-Sleep -Seconds $waitTime
            }

            # Push file to Android
            Write-Log "Transferring file (attempt $attempt/$MaxRetries)..."
            $pushOutput = & adb push "$($File.FullName)" "$androidFilePath" 2>&1

            if ($LASTEXITCODE -ne 0) {
                Write-Log "ADB push failed with exit code $LASTEXITCODE" -Level "WARNING"
                continue
            }

            # Validate file size
            Start-Sleep -Milliseconds 500  # Small delay to ensure file is written
            $androidSize = Get-AndroidFileSize -FilePath $androidFilePath

            if ($androidSize -eq $sourceSize) {
                Write-Log "File size validated: $androidSize bytes" -Level "SUCCESS"

                # Set timestamp (use LastWriteTime as Android doesn't have creation time)
                $timestamp = ConvertTo-AndroidTimestamp -DateTime $File.LastWriteTime
                $touchOutput = & adb shell "touch -t $timestamp '$androidFilePath'" 2>&1

                if ($LASTEXITCODE -eq 0) {
                    Write-Log "Timestamp set to: $($File.LastWriteTime)" -Level "SUCCESS"
                }
                else {
                    Write-Log "Warning: Could not set timestamp" -Level "WARNING"
                }

                # Trigger Media Scanner
                $scanOutput = & adb shell "am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file://$androidFilePath" 2>&1
                Write-Log "Media scanner triggered for Gallery integration" -Level "SUCCESS"

                $script:SuccessCount++
                Write-Log "[OK] Successfully transferred: $fileName" -Level "SUCCESS"
                return $true
            }
            elseif ($androidSize -eq -1) {
                Write-Log "File not found on Android device after transfer" -Level "WARNING"
                continue
            }
            else {
                Write-Log "File size mismatch! Source: $sourceSize bytes, Android: $androidSize bytes" -Level "WARNING"
                # Delete corrupted file
                & adb shell "rm '$androidFilePath'" 2>&1 | Out-Null
                continue
            }
        }
        catch {
            Write-Log "Error during transfer: $($_.Exception.Message)" -Level "WARNING"
            continue
        }
    }

    # All retries failed
    $script:FailureCount++
    $script:FailedFiles += [PSCustomObject]@{
        FileName = $fileName
        SourcePath = $File.FullName
        Reason = "Failed after $MaxRetries attempts"
    }
    Write-Log "[FAILED] Failed to transfer: $fileName" -Level "ERROR"
    return $false
}

# Main execution
function Main {
    Write-Log "========================================" -Level "INFO"
    Write-Log "Android Media Sync Started" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    Write-Log "Source: $SourcePath"
    Write-Log "Destination: $DestinationPath"
    Write-Log "File Filter: $FileFilter"
    Write-Log "Recursive: $Recursive"
    Write-Log "Max Retries: $MaxRetries"
    Write-Log "Log File: $LogPath"
    Write-Log "========================================" -Level "INFO"

    # Check prerequisites
    if (-not (Test-AdbAvailable)) {
        Write-Log "Exiting due to missing ADB" -Level "ERROR"
        return
    }

    if (-not (Test-DeviceConnected)) {
        Write-Log "Exiting due to no connected device" -Level "ERROR"
        return
    }

    # Create destination directory on Android
    Write-Log "Creating destination directory on Android device..."
    & adb shell "mkdir -p '$DestinationPath'" 2>&1 | Out-Null

    # Get files to transfer
    Write-Log "Scanning for files..."
    $getChildItemParams = @{
        Path = $SourcePath
        Filter = $FileFilter
        File = $true
    }

    if ($Recursive) {
        $getChildItemParams.Recurse = $true
    }

    $files = Get-ChildItem @getChildItemParams | Where-Object {
        $_.Extension -match '\.(jpg|jpeg|png|gif|bmp|mp4|mov|avi|mkv|3gp|webm|heic)$'
    }

    if ($files.Count -eq 0) {
        Write-Log "No media files found matching the criteria" -Level "WARNING"
        return
    }

    Write-Log "Found $($files.Count) media files to transfer" -Level "INFO"
    Write-Log "========================================" -Level "INFO"

    # Transfer each file
    $fileNumber = 0
    foreach ($file in $files) {
        $fileNumber++
        Write-Log "`n[$fileNumber/$($files.Count)] Processing file..." -Level "INFO"

        if ($Recursive -and $file.DirectoryName -ne $SourcePath) {
            # Create subdirectory structure on Android
            $relativePath = $file.DirectoryName.Substring($SourcePath.Length).TrimStart('\')
            $androidSubPath = "$DestinationPath/$relativePath".Replace('\', '/')
            & adb shell "mkdir -p '$androidSubPath'" 2>&1 | Out-Null
            Copy-FileToAndroid -File $file -AndroidDestPath $androidSubPath
        }
        else {
            Copy-FileToAndroid -File $file -AndroidDestPath $DestinationPath
        }
    }

    # Summary
    $endTime = Get-Date
    $duration = $endTime - $script:StartTime

    Write-Log "`n========================================" -Level "INFO"
    Write-Log "SYNC SUMMARY" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    Write-Log "Total Files Processed: $($files.Count)"
    Write-Log "Successfully Transferred: $script:SuccessCount" -Level "SUCCESS"
    Write-Log "Failed: $script:FailureCount" -Level $(if ($script:FailureCount -gt 0) { "ERROR" } else { "INFO" })
    Write-Log "Duration: $($duration.ToString('hh\:mm\:ss'))"

    if ($script:FailedFiles.Count -gt 0) {
        Write-Log "`nFailed Files:" -Level "ERROR"
        foreach ($failedFile in $script:FailedFiles) {
            Write-Log "  - $($failedFile.FileName): $($failedFile.Reason)" -Level "ERROR"
        }
    }

    Write-Log "========================================" -Level "INFO"
    Write-Log "Log file saved to: $LogPath" -Level "INFO"

    # Trigger full media scan on destination folder
    Write-Log "`nTriggering final media scan on destination folder..."
    & adb shell "am broadcast -a android.intent.action.MEDIA_MOUNTED -d file://$DestinationPath" 2>&1 | Out-Null
    Write-Log "Media scan completed - files should now appear in Gallery" -Level "SUCCESS"
}

# Run main function
Main
