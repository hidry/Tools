#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Local PowerShell Syntax Validation Script

.DESCRIPTION
    Tests all PowerShell scripts in the repository for syntax errors.
    This is the same logic used in the GitHub Actions workflow.

.EXAMPLE
    ./Test-Syntax.ps1
#>

Write-Host "🔍 PowerShell Syntax Validation (Local Test)" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Get script directory
$scriptRoot = $PSScriptRoot
if (-not $scriptRoot) {
    $scriptRoot = Get-Location
}

Write-Host "Searching in: $scriptRoot" -ForegroundColor White
Write-Host ""

# Find all PowerShell scripts
$scripts = Get-ChildItem -Path $scriptRoot -Filter *.ps1 -Recurse -File | Where-Object { $_.Name -ne 'Test-Syntax.ps1' }

if ($scripts.Count -eq 0) {
    Write-Host "⚠️  No PowerShell scripts found" -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($scripts.Count) PowerShell script(s) to validate" -ForegroundColor White
Write-Host ""

$failed = @()
$passed = 0

foreach ($script in $scripts) {
    $relativePath = $script.FullName.Replace($scriptRoot + [System.IO.Path]::DirectorySeparatorChar, '')
    Write-Host "Checking: $relativePath" -ForegroundColor Cyan

    $errors = $null
    $tokens = $null

    try {
        # Parse the PowerShell file
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $script.FullName,
            [ref]$tokens,
            [ref]$errors
        )

        if ($errors -and $errors.Count -gt 0) {
            Write-Host "  ❌ SYNTAX ERROR" -ForegroundColor Red
            foreach ($error in $errors) {
                Write-Host "     Line $($error.Extent.StartLineNumber): $($error.Message)" -ForegroundColor Red
            }
            $failed += @{
                Script = $relativePath
                Errors = $errors
            }
        } else {
            Write-Host "  ✅ Valid syntax" -ForegroundColor Green
            $passed++
        }
    } catch {
        Write-Host "  ❌ PARSE FAILED: $_" -ForegroundColor Red
        $failed += @{
            Script = $relativePath
            Errors = @("Exception: $_")
        }
    }
    Write-Host ""
}

# Summary
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  ✅ Passed: $passed" -ForegroundColor Green
Write-Host "  ❌ Failed: $($failed.Count)" -ForegroundColor $(if ($failed.Count -gt 0) { 'Red' } else { 'Gray' })
Write-Host "=============================================" -ForegroundColor Cyan

if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host "❌ Syntax validation failed for:" -ForegroundColor Red
    foreach ($f in $failed) {
        Write-Host "  - $($f.Script)" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Please fix the syntax errors before committing." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host ""
    Write-Host "✅ All PowerShell scripts have valid syntax!" -ForegroundColor Green
    Write-Host ""
    exit 0
}
