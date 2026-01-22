param(
    [string]$RepositoryPath = ".",
    [string]$MainBranch = "",
    [switch]$DryRun,
    [switch]$IncludeRemote,
    [switch]$Force,
    [string[]]$ProtectedBranches = @('master', 'main', 'develop', 'development', 'staging', 'production', 'current')
)

$ErrorActionPreference = 'Continue'

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('Info', 'Success', 'Warning', 'Error')]
        [string]$Level = 'Info'
    )

    $timestamp = Get-Date -Format 'HH:mm:ss'
    $prefix = "[$timestamp]"

    switch ($Level) {
        'Success' { Write-Host "$prefix [OK] $Message" -ForegroundColor Green }
        'Warning' { Write-Host "$prefix [WARN] $Message" -ForegroundColor Yellow }
        'Error'   { Write-Host "$prefix [ERROR] $Message" -ForegroundColor Red }
        default   { Write-Host "$prefix [INFO] $Message" -ForegroundColor White }
    }
}

function Test-IsGitRepository {
    param([string]$Path)

    if (Test-Path (Join-Path $Path ".git")) {
        return $true
    }
    return $false
}

function Get-DefaultBranch {
    try {
        # Versuche den Default-Branch von Remote zu ermitteln
        $remoteBranch = git symbolic-ref refs/remotes/origin/HEAD 2>$null
        if ($remoteBranch) {
            $branch = $remoteBranch -replace 'refs/remotes/origin/', ''
            return $branch
        }

        # Fallback: Prüfe ob master oder main existiert
        $branches = git branch --list 2>$null
        if ($branches -match '\bmaster\b') {
            return 'master'
        } elseif ($branches -match '\bmain\b') {
            return 'main'
        }

        # Letzter Fallback
        return 'master'
    } catch {
        return 'master'
    }
}

function Get-MergedBranches {
    param(
        [string]$BaseBranch,
        [string[]]$Protected
    )

    Write-Log "Suche nach Branches die in '$BaseBranch' gemerged wurden..."

    try {
        $mergedBranches = git branch --merged $BaseBranch 2>$null |
            ForEach-Object { $_.Trim('* ').Trim() } |
            Where-Object {
                $branch = $_
                $branch -and
                $branch -ne $BaseBranch -and
                $Protected -notcontains $branch
            }

        return $mergedBranches
    } catch {
        Write-Log "Fehler beim Ermitteln gemergter Branches: $($_.Exception.Message)" -Level Error
        return @()
    }
}

function Get-EmptyBranches {
    param(
        [string]$BaseBranch,
        [string[]]$Protected
    )

    Write-Log "Suche nach leeren Branches (ohne eigene Commits)..."

    try {
        $allBranches = git branch --format='%(refname:short)' 2>$null |
            Where-Object {
                $branch = $_
                $branch -and
                $branch -ne $BaseBranch -and
                $Protected -notcontains $branch
            }

        $emptyBranches = @()

        foreach ($branch in $allBranches) {
            # Zähle Commits die in diesem Branch aber nicht im Base-Branch sind
            $commitCount = git rev-list --count "$BaseBranch..$branch" 2>$null

            if ($commitCount -eq "0") {
                $emptyBranches += $branch
            }
        }

        return $emptyBranches
    } catch {
        Write-Log "Fehler beim Ermitteln leerer Branches: $($_.Exception.Message)" -Level Error
        return @()
    }
}

function Get-RemoteMergedBranches {
    param(
        [string]$BaseBranch,
        [string[]]$Protected
    )

    Write-Log "Suche nach Remote-Branches die in 'origin/$BaseBranch' gemerged wurden..."

    try {
        # Aktualisiere Remote-Informationen
        Write-Log "  -> git fetch --prune"
        git fetch --prune 2>&1 | Out-Null

        $remoteBranches = git branch -r --merged "origin/$BaseBranch" 2>$null |
            ForEach-Object { $_.Trim() } |
            Where-Object {
                $branch = $_ -replace 'origin/', ''
                $branch -and
                $branch -ne $BaseBranch -and
                $branch -notmatch 'HEAD' -and
                $Protected -notcontains $branch
            } |
            ForEach-Object { $_ -replace 'origin/', '' }

        return $remoteBranches | Select-Object -Unique
    } catch {
        Write-Log "Fehler beim Ermitteln gemergter Remote-Branches: $($_.Exception.Message)" -Level Error
        return @()
    }
}

function Remove-LocalBranch {
    param(
        [string]$BranchName,
        [bool]$IsDryRun
    )

    if ($IsDryRun) {
        Write-Log "  [DRY-RUN] Würde löschen: $BranchName" -Level Info
        return $true
    }

    try {
        $output = git branch -d $BranchName 2>&1
        if ($LASTEXITCODE -ne 0) {
            # Versuche Force-Delete wenn normales Delete fehlschlägt
            Write-Log "  -> Normales Löschen fehlgeschlagen, versuche Force-Delete" -Level Warning
            $output = git branch -D $BranchName 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Log "  -> Fehler beim Löschen: $output" -Level Error
                return $false
            }
        }
        Write-Log "  -> Gelöscht: $BranchName" -Level Success
        return $true
    } catch {
        Write-Log "  -> Fehler: $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Remove-RemoteBranch {
    param(
        [string]$BranchName,
        [bool]$IsDryRun
    )

    if ($IsDryRun) {
        Write-Log "  [DRY-RUN] Würde Remote-Branch löschen: origin/$BranchName" -Level Info
        return $true
    }

    try {
        $output = git push origin --delete $BranchName 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Log "  -> Fehler beim Löschen von Remote-Branch: $output" -Level Error
            return $false
        }
        Write-Log "  -> Remote-Branch gelöscht: origin/$BranchName" -Level Success
        return $true
    } catch {
        Write-Log "  -> Fehler: $($_.Exception.Message)" -Level Error
        return $false
    }
}

# Banner
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Git Branch Cleanup Tool" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Validierung
if (-not (Test-Path $RepositoryPath)) {
    Write-Log "Repository-Pfad existiert nicht: $RepositoryPath" -Level Error
    exit 1
}

Push-Location $RepositoryPath

if (-not (Test-IsGitRepository -Path $RepositoryPath)) {
    Write-Log "Kein Git-Repository gefunden in: $RepositoryPath" -Level Error
    Pop-Location
    exit 1
}

# Ermittle Main-Branch
if (-not $MainBranch) {
    $MainBranch = Get-DefaultBranch
    Write-Log "Verwende automatisch erkannten Main-Branch: $MainBranch"
}

# Konfiguration anzeigen
Write-Log "Konfiguration:"
Write-Log "  Repository: $RepositoryPath"
Write-Log "  Main-Branch: $MainBranch"
Write-Log "  Protected Branches: $($ProtectedBranches -join ', ')"
Write-Log "  Dry-Run: $DryRun"
Write-Log "  Include Remote: $IncludeRemote"
Write-Log "  Force: $Force"
Write-Host ""

# Prüfe ob Main-Branch existiert
$branchExists = git show-ref --verify --quiet "refs/heads/$MainBranch"
if ($LASTEXITCODE -ne 0) {
    Write-Log "Main-Branch '$MainBranch' existiert nicht!" -Level Error
    Pop-Location
    exit 1
}

# Sammle zu löschende Branches
$branchesToDelete = @()
$remoteBranchesToDelete = @()

# 1. Gemergte Branches
$mergedBranches = Get-MergedBranches -BaseBranch $MainBranch -Protected $ProtectedBranches
if ($mergedBranches) {
    Write-Log "Gefundene gemergte Branches: $($mergedBranches.Count)" -Level Success
    foreach ($branch in $mergedBranches) {
        Write-Log "  - $branch (merged)"
    }
    $branchesToDelete += $mergedBranches
} else {
    Write-Log "Keine gemergten Branches gefunden"
}
Write-Host ""

# 2. Leere Branches
$emptyBranches = Get-EmptyBranches -BaseBranch $MainBranch -Protected $ProtectedBranches
# Entferne bereits gemergte Branches aus der Liste
$emptyBranches = $emptyBranches | Where-Object { $branchesToDelete -notcontains $_ }

if ($emptyBranches) {
    Write-Log "Gefundene leere Branches: $($emptyBranches.Count)" -Level Success
    foreach ($branch in $emptyBranches) {
        Write-Log "  - $branch (empty)"
    }
    $branchesToDelete += $emptyBranches
} else {
    Write-Log "Keine leeren Branches gefunden"
}
Write-Host ""

# 3. Remote Branches (wenn gewünscht)
if ($IncludeRemote) {
    $remoteBranchesToDelete = Get-RemoteMergedBranches -BaseBranch $MainBranch -Protected $ProtectedBranches
    if ($remoteBranchesToDelete) {
        Write-Log "Gefundene gemergte Remote-Branches: $($remoteBranchesToDelete.Count)" -Level Success
        foreach ($branch in $remoteBranchesToDelete) {
            Write-Log "  - origin/$branch"
        }
    } else {
        Write-Log "Keine gemergten Remote-Branches gefunden"
    }
    Write-Host ""
}

# Zusammenfassung
$totalBranches = $branchesToDelete.Count + $remoteBranchesToDelete.Count
if ($totalBranches -eq 0) {
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Log "Keine Branches zum Löschen gefunden!" -Level Success
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    Pop-Location
    exit 0
}

Write-Host "================================================================" -ForegroundColor Yellow
Write-Log "Es werden $totalBranches Branch(es) gelöscht:" -Level Warning
Write-Log "  Lokale Branches: $($branchesToDelete.Count)"
if ($IncludeRemote) {
    Write-Log "  Remote Branches: $($remoteBranchesToDelete.Count)"
}
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host ""

# Bestätigung (wenn nicht Force oder DryRun)
if (-not $Force -and -not $DryRun) {
    $confirmation = Read-Host "Möchten Sie fortfahren? (J/N)"
    if ($confirmation -ne 'J' -and $confirmation -ne 'j') {
        Write-Log "Abgebrochen durch Benutzer" -Level Warning
        Pop-Location
        exit 0
    }
    Write-Host ""
}

# Lösche lokale Branches
$successCount = 0
$failureCount = 0

if ($branchesToDelete.Count -gt 0) {
    Write-Log "Lösche lokale Branches..."
    foreach ($branch in $branchesToDelete) {
        if (Remove-LocalBranch -BranchName $branch -IsDryRun $DryRun) {
            $successCount++
        } else {
            $failureCount++
        }
    }
    Write-Host ""
}

# Lösche Remote-Branches
if ($IncludeRemote -and $remoteBranchesToDelete.Count -gt 0) {
    Write-Log "Lösche Remote-Branches..."
    foreach ($branch in $remoteBranchesToDelete) {
        if (Remove-RemoteBranch -BranchName $branch -IsDryRun $DryRun) {
            $successCount++
        } else {
            $failureCount++
        }
    }
    Write-Host ""
}

# Abschluss
Write-Host "================================================================" -ForegroundColor Cyan
if ($DryRun) {
    Write-Log "DRY-RUN abgeschlossen!" -Level Success
    Write-Log "  Würde löschen: $successCount Branch(es)"
} else {
    Write-Log "Cleanup abgeschlossen!" -Level Success
    Write-Log "  Erfolgreich gelöscht: $successCount"
    Write-Log "  Fehler: $failureCount"
}
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

Pop-Location
