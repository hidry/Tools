param(
    [string]$Organization = "https://myAzureDevOpsServer/tfs/myCollection/",
    [string]$Project = "myProject",
    [string]$Token = "myPAT",
    [string]$BasePath = "C:\myBasePath"
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

function Get-RepositoriesFromAzureDevOps {
    Write-Log "Abrufen von Repositories aus Projekt: $Project"
    
    try {
        $base64Auth = [Convert]::ToBase64String(
            [Text.Encoding]::ASCII.GetBytes(":$Token")
        )
        
        $headers = @{
            Authorization = "Basic $base64Auth"
            'Content-Type' = 'application/json'
        }
        
        $url = "${Organization}/_apis/git/repositories?api-version=7.0"
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorAction Stop
        
        $repos = $response.value | Where-Object { $_.project.name -eq $Project }
        Write-Log "Gefundene Repositories: $($repos.Count)" -Level Success
        
        return $repos
    } catch {
        Write-Log "Fehler beim Abrufen der Repositories: $($_.Exception.Message)" -Level Error
        throw
    }
}

function Get-DefaultBranch {
    param(
        [object]$Repository
    )
    
    if ($Repository.defaultBranch) {
        $branch = $Repository.defaultBranch -replace 'refs/heads/', ''
        return $branch
    }
    
    return "master"
}

function Test-IsGitRepository {
    param(
        [string]$Path
    )
    
    if (Test-Path (Join-Path $Path ".git")) {
        return $true
    }
    return $false
}

function Sync-Repository {
    param(
        [object]$Repository,
        [string]$LocalPath
    )
    
    $repoName = $Repository.name
    $cloneUrl = $Repository.remoteUrl
    $defaultBranch = Get-DefaultBranch -Repository $Repository
    
    Write-Log "Verarbeite: $repoName (Branch: $defaultBranch, URL: $cloneUrl)"
    
    # Pruefen ob bereits ein Git-Repository existiert
    if ((Test-Path $LocalPath) -and (Test-IsGitRepository -Path $LocalPath)) {
        Write-Log "Repository existiert, aktualisiere: $repoName"
        
        try {
            Push-Location $LocalPath
            
            # Fetch vom origin
            Write-Log "  -> git fetch origin $defaultBranch"
            $output = git fetch origin $defaultBranch 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Log "  -> Fetch Fehler: $output" -Level Warning
            }
            
            # Checkout zum Default-Branch
            $currentBranch = git rev-parse --abbrev-ref HEAD 2>&1
            Write-Log "  -> Aktueller Branch: $currentBranch, Ziel: $defaultBranch"
            
            if ($currentBranch -ne $defaultBranch) {
                Write-Log "  -> Wechsle zu Branch $defaultBranch"
                git checkout $defaultBranch 2>&1 | Out-Null
            }
            
            # Pull
            Write-Log "  -> git pull origin $defaultBranch"
            $output = git pull origin $defaultBranch 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Log "  -> Pull Fehler: $output" -Level Warning
                Pop-Location
                return $false
            }
            
            Pop-Location
            Write-Log "OK - Aktualisiert: $repoName" -Level Success
            return $true
        } catch {
            Write-Log "Fehler beim Aktualisieren von $repoName : $($_.Exception.Message)" -Level Error
            Pop-Location
            return $false
        }
    } else {
        # Repository existiert nicht oder ist nicht initialisiert
        Write-Log "Klone neues Repository: $repoName"
        
        try {
            # Erstelle Parent-Verzeichnis
            $parentPath = Split-Path -Parent $LocalPath
            if (-not (Test-Path $parentPath)) {
                Write-Log "  -> Erstelle Verzeichnis: $parentPath"
                New-Item -ItemType Directory -Path $parentPath -Force | Out-Null
            }
            
            # Wenn Verzeichnis existiert, aber nicht initialisiert
            if (Test-Path $LocalPath) {
                Write-Log "  -> Loeschen existierendes Verzeichnis: $LocalPath"
                Remove-Item -Path $LocalPath -Recurse -Force | Out-Null
            }
            
            Write-Log "  -> git clone --branch $defaultBranch --single-branch $cloneUrl $LocalPath"
            $output = git clone --branch $defaultBranch --single-branch $cloneUrl $LocalPath 2>&1
            
            if ($LASTEXITCODE -ne 0) {
                Write-Log "  -> Clone Fehler: $output" -Level Error
                return $false
            }
            
            Write-Log "OK - Geklont: $repoName" -Level Success
            return $true
        } catch {
            Write-Log "Fehler beim Klonen von $repoName : $($_.Exception.Message)" -Level Error
            return $false
        }
    }
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Azure DevOps Repository Synchronizer" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Log "Konfiguration:"
Write-Log "  Organisation: $Organization"
Write-Log "  Projekt: $Project"
Write-Log "  Basispfad: $BasePath"
Write-Log ""

# Stelle sicher, dass Basispfad existiert
if (-not (Test-Path $BasePath)) {
    Write-Log "Erstelle Basispfad: $BasePath"
    New-Item -ItemType Directory -Path $BasePath -Force | Out-Null
}

$repositories = Get-RepositoriesFromAzureDevOps

if ($repositories.Count -eq 0) {
    Write-Log "Keine Repositories gefunden!" -Level Warning
    Write-Host ""
    exit 1
}

Write-Log "Starte Synchronisation von $($repositories.Count) Repositories..."
Write-Host ""

$successCount = 0
$failureCount = 0

foreach ($repo in $repositories) {
    $repoPath = Join-Path $BasePath $repo.name
    
    if (Sync-Repository -Repository $repo -LocalPath $repoPath) {
        $successCount++
    } else {
        $failureCount++
    }
    Write-Host ""
}

Write-Host "================================================================" -ForegroundColor Cyan
Write-Log "Synchronisation abgeschlossen!" -Level Success
Write-Log "  Erfolgreich: $successCount"
Write-Log "  Fehler: $failureCount"
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""