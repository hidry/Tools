# Claude MD Git Manager mit lokaler Claude Installation
#Requires -Version 5.0

param(
    [string]$RootPath = (Get-Location).Path,
    [int]$MinChangesThreshold = 5,
    [int]$TopReposCount = 5,
    [switch]$DryRun,
    [switch]$Verbose
)



asdfasdfasdf

asdf
asdfasdf

asdfsadf


asdf
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Header([string]$msg) {
    Write-Host "`n█ $msg" -ForegroundColor Cyan
}

function Write-Status([string]$msg, [string]$Type = 'Info') {
    $colors = @{ Success = 'Green'; Warning = 'Yellow'; Error = 'Red'; Info = 'White' }
    Write-Host "  ► $msg" -ForegroundColor $colors[$Type]
}

function Invoke-Git {
    param(
        [string]$Command,
        [string]$Dir,
        [switch]$IgnoreError
    )
    $loc = Get-Location
    try {
        Set-Location $Dir
        $out = Invoke-Expression $Command 2>&1 | Out-String
        return $out.Trim()
    }
    catch {
        if (-not $IgnoreError) {
            Write-Status "Git error in '$Dir': $_" 'Error'
            return $null
        }
    }
    finally {
        Set-Location $loc
    }
}

function Get-DefaultBranch([string]$RepoPath) {
    try {
        $b = Invoke-Git "git symbolic-ref --short refs/remotes/origin/HEAD" $RepoPath -IgnoreError
        if ($b) { return ($b -replace 'origin/', '') }

        $b = Invoke-Git "git rev-parse --abbrev-ref HEAD" $RepoPath -IgnoreError
        if ($b -and $b -ne 'HEAD') { return $b }

        return 'master'
    }
    catch {
        return 'master'
    }
}

function Get-CommitCount([string]$RepoPath, [string]$Branch) {
    try {
        $out = Invoke-Git "git log --oneline $Branch 2>&1" $RepoPath -IgnoreError
        if ($out) {
            $lines = @($out -split "`n" | Where-Object { $_ -match '^\w' })
            return $lines.Count
        }
        return 0
    }
    catch {
        return 0
    }
}

function Get-RepoInfo([string]$RepoPath) {
    try {
        $url    = Invoke-Git "git config --get remote.origin.url" $RepoPath -IgnoreError
        $branch = Get-DefaultBranch $RepoPath
        return @{
            Name          = Split-Path $RepoPath -Leaf
            Path          = $RepoPath
            RemoteUrl     = $url
            DefaultBranch = $branch
            IsValid       = ($url -ne $null -and $url -ne '')
        }
    }
    catch {
        return @{
            Name          = Split-Path $RepoPath -Leaf
            Path          = $RepoPath
            RemoteUrl     = $null
            DefaultBranch = $null
            IsValid       = $false
        }
    }
}

function Test-IsRepo([string]$Path) {
    return Test-Path (Join-Path $Path '.git') -PathType Container
}

function Get-ChangesSince([string]$RepoPath, [string]$Branch, [datetime]$Since) {
    try {
        $date = $Since.ToString('yyyy-MM-dd HH:mm:ss')
        $out  = Invoke-Git "git log --oneline --since=`"$date`" $Branch" $RepoPath -IgnoreError
        if ($out) {
            $lines = @($out -split "`n" | Where-Object { $_ -match '^\w' })
            return $lines.Count
        }
        return 0
    }
    catch {
        return 0
    }
}

function Get-TotalChangesSinceRootUpdate([array]$Repos, [datetime]$Since) {
    $total = 0
    foreach ($r in $Repos) {
        $total += Get-ChangesSince $r.Path $r.Branch $Since
    }
    return $total
}

function Test-ClaudeInstalled {
    try {
        $test = Invoke-Expression "claude --version 2>&1" -ErrorAction SilentlyContinue
        return $test -ne $null
    }
    catch {
        return $false
    }
}

function Create-ClaudeTemplate([string]$RepoPath, [string]$RepoName) {
    $template = @"
# $RepoName Repository

## Overview
This is the $RepoName repository. Please analyze and document this codebase.

## Purpose
[To be documented by Claude]

## Structure
[To be documented by Claude]

## Key Files
[To be documented by Claude]

## Dependencies
[To be documented by Claude]

## Usage
[To be documented by Claude]

---
*Generated template - awaiting Claude analysis*
"@

    try {
        $path = Join-Path $RepoPath 'CLAUDE.md'
        Set-Content -Path $path -Value $template -Encoding UTF8 -Force
        return $true
    }
    catch {
        return $false
    }
}

function Create-RootTemplate([string]$RootPath, [array]$RepoNames) {
    $repoList = ($RepoNames | ForEach-Object { "- **$_**`n" }) -join ''

    $template = @"
# 4SELLERS - Repository Collection

## Overview
Central collection directory containing multiple specialized repositories for the 4SELLERS platform.

## Repositories
$repoList

## Purpose
[To be documented by Claude - provides overview of all sub-repositories]

## Architecture
[To be documented by Claude]

## Key Statistics
[To be documented by Claude]

## Development Guidelines
[To be documented by Claude]

---
*Generated template - awaiting Claude analysis*
"@

    try {
        $path = Join-Path $RootPath 'claude.md'
        Set-Content -Path $path -Value $template -Encoding UTF8 -Force
        return $true
    }
    catch {
        return $false
    }
}

function Get-ClaudePath {
    # Versuche Claude-Pfad zu finden
    $claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
    if ($claudeCmd) {
        $source = $claudeCmd.Source
        # Bevorzuge .cmd Version für ProcessStartInfo
        $cmdPath = $source -replace '\.ps1$', '.cmd'
        if (Test-Path $cmdPath) {
            return $cmdPath
        }
        return $source
    }

    # Fallback: Standard npm-Pfad
    $npmPath = Join-Path $env:APPDATA 'npm\claude.cmd'
    if (Test-Path $npmPath) {
        return $npmPath
    }

    return $null
}

function Invoke-ClaudeUpdate([string]$RepoPath, [int]$ChangeCount, [bool]$IsNew) {
    if ($DryRun) { return $true }

    try {
        $claudeMdPath = Join-Path $RepoPath 'CLAUDE.md'
        $repoName = Split-Path $RepoPath -Leaf

        # Claude-Pfad ermitteln
        $claudePath = Get-ClaudePath
        if (-not $claudePath) {
            Write-Status "Claude executable not found" 'Error'
            return $false
        }

        # Prompt für Claude vorbereiten
        if ($IsNew) {
            $prompt = "Analyze this repository '$repoName' and create a comprehensive CLAUDE.md documentation file. Include: 1) Overview - What this project/module does, 2) Project Structure - Key directories and purposes, 3) Key Files - Important files and roles, 4) Build Instructions - How to build, 5) Dependencies - Required dependencies, 6) Usage - How to use this module. Analyze the actual codebase to provide accurate information. Output ONLY the markdown content, nothing else."
        } else {
            $prompt = "Review the repository '$repoName' which has had $ChangeCount commits since the last documentation update. Read the existing CLAUDE.md file and update it to reflect the current state. Check for new files, changed structures, or updated dependencies. Output ONLY the updated markdown content, nothing else."
        }

        Write-Status "Running Claude analysis (this may take a moment)..." 'Info'
        if ($Verbose) {
            Write-Status "Using Claude at: $claudePath" 'Info'
        }

        # Escape Anführungszeichen im Prompt für cmd.exe
        $escapedPrompt = $prompt -replace '"', '\"'

        # Claude Code CLI mit -p flag für non-interaktive Ausführung
        # Verwende cmd.exe /c um .cmd Dateien korrekt auszuführen
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = 'cmd.exe'
        $psi.Arguments = "/c `"`"$claudePath`" -p `"$escapedPrompt`" --output-format text`""
        $psi.UseShellExecute = $false
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        $psi.CreateNoWindow = $true
        $psi.WorkingDirectory = $RepoPath

        $proc = [System.Diagnostics.Process]::Start($psi)

        # Async Output lesen um Deadlocks zu vermeiden
        $outputTask = $proc.StandardOutput.ReadToEndAsync()
        $errorTask = $proc.StandardError.ReadToEndAsync()

        # 5 Minuten Timeout pro Repository
        $completed = $proc.WaitForExit(300000)

        if (-not $completed) {
            $proc.Kill()
            Write-Status "Claude timeout after 5 minutes" 'Warning'
            return $false
        }

        $output = $outputTask.Result
        $errorOutput = $errorTask.Result

        if ($errorOutput -and $Verbose) {
            Write-Status "Claude stderr: $errorOutput" 'Warning'
        }

        # Prüfen ob sinnvoller Output vorhanden
        if ($output -and $output.Trim().Length -gt 100) {
            # Bereinige Output (entferne eventuelle ANSI-Codes)
            $cleanOutput = $output -replace '\x1b\[[0-9;]*m', ''
            $cleanOutput = $cleanOutput.Trim()

            # Schreibe in CLAUDE.md
            Set-Content -Path $claudeMdPath -Value $cleanOutput -Encoding UTF8 -Force
            Write-Status "CLAUDE.md written ($($cleanOutput.Length) chars)" 'Success'
            return $true
        }
        else {
            Write-Status "Claude returned insufficient output ($($output.Length) chars)" 'Warning'
            if ($Verbose -and $output) {
                Write-Status "Output: $output" 'Info'
            }
            return $false
        }
    }
    catch {
        Write-Status "Claude error: $_" 'Error'
        return $false
    }
}

function Test-Environment {
    @{
        'PowerShell 5.0+'  = ($PSVersionTable.PSVersion.Major -ge 5)
        'Git installed'    = ($null -ne (Get-Command git -ErrorAction SilentlyContinue))
        'Claude installed' = (Test-ClaudeInstalled)
        'Root exists'      = (Test-Path $RootPath -PathType Container)
    }
}

Write-Header "Claude MD Git Manager (Local Claude)"

Write-Host "`nValidating environment:`n" -ForegroundColor Cyan
$checks = Test-Environment
$valid  = $true
foreach ($c in $checks.GetEnumerator()) {
    $status = if ($c.Value) { '✓ PASS' } else { '✗ FAIL' }
    $color  = if ($c.Value) { 'Green' } else { 'Red' }
    Write-Host "  [$status] $($c.Name)" -ForegroundColor $color
    $valid = $valid -and $c.Value
}
if (-not $valid) {
    Write-Status 'Validation failed' 'Error'
    exit 1
}

Write-Header "Repository Scan"
Write-Status "Root Path: $RootPath" 'Info'

Write-Header "Scanning All Repositories"
$subdirs = Get-ChildItem -Path $RootPath -Directory -Depth 0 | Where-Object { $_.Name -notmatch '^\.' }
Write-Status "Found directories: $($subdirs.Count)" 'Info'

Write-Host "`nGathering repository information:`n" -ForegroundColor Cyan
$allRepos  = @()
$scanIndex = 0

foreach ($dir in $subdirs) {
    $path = $dir.FullName
    $scanIndex++
    Write-Host "  [$scanIndex/$($subdirs.Count)] $($dir.Name)" -ForegroundColor Gray -NoNewline

    if (-not (Test-IsRepo $path)) {
        Write-Host " (not a git repo)" -ForegroundColor Gray
        continue
    }

    $info = Get-RepoInfo $path
    if (-not $info.IsValid) {
        Write-Host " (invalid)" -ForegroundColor Gray
        continue
    }

    $commitCount = Get-CommitCount $path $info.DefaultBranch

    $mdpath     = Join-Path $path 'claude.md'
    $claudePath = Join-Path $path 'CLAUDE.md'
    $hasClaude  = (Test-Path $mdpath) -or (Test-Path $claudePath)

    $changes = 0
    if ($hasClaude) {
        $file = if (Test-Path $claudePath) { $claudePath } else { $mdpath }
        $age  = (Get-Item $file).LastWriteTime
        $changes = Get-ChangesSince $path $info.DefaultBranch $age
    }

    $allRepos += @{
        Name        = $dir.Name
        Path        = $path
        Branch      = $info.DefaultBranch
        CommitCount = $commitCount
        HasClaudeMd = $hasClaude
        Changes     = $changes
        RemoteUrl   = $info.RemoteUrl
    }

    Write-Host " ✓ (commits: $commitCount, changes: $changes)" -ForegroundColor Gray
}

Write-Header "Repository Prioritization"
Write-Status "Total valid repos: $($allRepos.Count)" 'Info'

$reposWithoutMd          = @($allRepos | Where-Object { -not $_.HasClaudeMd })
$reposWithMd             = @($allRepos | Where-Object { $_.HasClaudeMd -and $_.Changes -ge $MinChangesThreshold })
$reposWithMdButNoChanges = @($allRepos | Where-Object { $_.HasClaudeMd -and $_.Changes -lt $MinChangesThreshold })

$threshold = $MinChangesThreshold
Write-Status "Without CLAUDE.md: $($reposWithoutMd.Count) repos (will all be processed)" 'Info'
Write-Status ("With CLAUDE.md and changes >= {0}: {1} repos" -f $threshold, $reposWithMd.Count) 'Info'
Write-Status ("With CLAUDE.md but < {0}: {1} repos (skipped)" -f $threshold, $reposWithMdButNoChanges.Count) 'Info'

$reposWithMd = $reposWithMd | Sort-Object -Property Changes -Descending
$topRepos    = $reposWithMd | Select-Object -First $TopReposCount

if ($topRepos.Count -gt 0) {
    Write-Status "Top $TopReposCount repos by changes:" 'Success'
    $topRepos | ForEach-Object {
        Write-Status "  - $($_.Name): $($_.Changes) changes" 'Info'
    }
}

$processQueue = @() + $reposWithoutMd + $topRepos

Write-Header "Processing Queue"
Write-Status "Repos to process: $($processQueue.Count)" 'Info'
Write-Host "`nOrder of processing (Sub-Repositories):`n" -ForegroundColor Cyan
$processQueue | ForEach-Object {
    $tag = if (-not $_.HasClaudeMd) { '[NEW]' } else { '[UPDATE]' }
    Write-Host "  $tag $($_.Name) ($($_.Changes) changes)" -ForegroundColor Yellow
}

Write-Header "Processing Repositories"
$results      = @()
$processIndex = 0

foreach ($repo in $processQueue) {
    $processIndex++
    Write-Host "`n[$processIndex/$($processQueue.Count)] Repository: $($repo.Name)" -ForegroundColor Yellow
    Write-Status "Branch: $($repo.Branch)" 'Info'
    Write-Status "Commits: $($repo.CommitCount)" 'Info'
    Write-Status "Changes since last update: $($repo.Changes)" 'Info'

    $isNew = -not $repo.HasClaudeMd

    if ($isNew) {
        Write-Status "Initializing CLAUDE.md with Claude..." 'Info'
    }
    else {
        Write-Status "Updating CLAUDE.md with Claude..." 'Info'
    }

    if ($DryRun) {
        Write-Status "DRY-RUN: Would process" 'Info'
        $ok = $true
    }
    else {
        $ok = Invoke-ClaudeUpdate $repo.Path $repo.Changes $isNew
    }

    if ($ok) {
        Write-Status "Processing successful" 'Success'
        $results += @{
            Name   = $repo.Name
            Status = 'Updated'
            Action = if ($isNew) { 'init' } else { 'update' }
        }
    }
    else {
        Write-Status "Processing failed" 'Error'
        $results += @{
            Name   = $repo.Name
            Status = 'Error'
            Action = if ($isNew) { 'init' } else { 'update' }
        }
    }
}

Write-Header "Processing Root Directory"

$rootClaudeMd  = Join-Path $RootPath 'claude.md'
$hasRootClaude = Test-Path $rootClaudeMd
$repoNames     = $allRepos | ForEach-Object { $_['Name'] } | Sort-Object

$rootAction = ''

if (-not $hasRootClaude) {
    $rootAction = 'init'
    Write-Status "Creating root claude.md template..." 'Info'
    Create-RootTemplate $RootPath $repoNames | Out-Null
    Write-Status "Root directory: Creating overview with Claude..." 'Success'
}
else {
    $rootFileAge  = (Get-Item $rootClaudeMd).LastWriteTime
    $totalChanges = Get-TotalChangesSinceRootUpdate $allRepos $rootFileAge

    Write-Status ("Root claude.md age: {0:F1} days" -f ((Get-Date) - $rootFileAge).TotalDays) 'Info'
    Write-Status "Total changes in all sub-repos since root update: $totalChanges" 'Info'

    if ($totalChanges -ge $MinChangesThreshold) {
        $rootAction = 'update'
        Write-Status "Threshold reached - updating root overview..." 'Success'
    }
    else {
        Write-Status "Not enough changes in sub-repos - root update skipped" 'Info'
    }
}

if ($rootAction -ne '') {
    if ($DryRun) {
        Write-Status "DRY-RUN: Would process root directory" 'Info'
        $rootOk = $true
    }
    else {
        $rootOk = Invoke-ClaudeUpdate $RootPath 0 ($rootAction -eq 'init')
    }

    if ($rootOk) {
        Write-Status "Root directory processing successful" 'Success'
        $results += @{
            Name   = '[ROOT]'
            Status = 'Updated'
            Action = $rootAction
        }
    }
    else {
        Write-Status "Root directory processing failed" 'Error'
        $results += @{
            Name   = '[ROOT]'
            Status = 'Error'
            Action = $rootAction
        }
    }
}

Write-Header "Summary"
$successCount = @($results | Where-Object { $_.Status -eq 'Updated' }).Count
$errorCount   = @($results | Where-Object { $_.Status -eq 'Error' }).Count
$initCount    = @($results | Where-Object { $_.Action -eq 'init' }).Count
$updateCount  = @($results | Where-Object { $_.Action -eq 'update' }).Count

Write-Status "Total processed: $($results.Count)" 'Info'
Write-Status "Successful: $successCount" 'Success'
Write-Status "  - Initialized (no CLAUDE.md): $initCount" 'Info'
Write-Status "  - Updated (top $TopReposCount by changes): $updateCount" 'Info'
Write-Status "Errors: $errorCount" $(if ($errorCount -gt 0) { 'Error' } else { 'Success' })

if ($Verbose -and $results.Count -gt 0) {
    Write-Host "`nDetailed Results:" -ForegroundColor Cyan
    foreach ($r in $results) {
        $color  = if ($r.Status -eq 'Updated') { 'Green' } else { 'Red' }
        $action = if ($r.Action -eq 'init') { '[INIT]' } else { '[UPDATE]' }
        Write-Host "  - $($r.Name) $action : $($r.Status)" -ForegroundColor $color
    }
}

exit 0
