# PowerShell Testing Workflow

This repository includes automated validation for all PowerShell scripts using syntax checking and code quality analysis.

## 🚀 Automated Workflow

The GitHub Actions workflow `powershell-syntax-check.yml` automatically:

- ✅ **Syntax Validation** - Validates structural syntax of all `.ps1` files (Parser)
- ✅ **Code Analysis** - Analyzes code quality and detects invalid commands (PSScriptAnalyzer)
- ✅ Runs on every push and pull request
- ✅ Provides detailed error messages with line numbers
- ✅ Prevents merging of invalid scripts

**Workflow triggers:**
- Push to any branch (when `.ps1` files are modified)
- Pull requests (when `.ps1` files are modified)
- Manual workflow dispatch

## 🧪 Local Testing

### Option 1: PSScriptAnalyzer (Recommended)

Install and run PSScriptAnalyzer for comprehensive code analysis:

```powershell
# Install PSScriptAnalyzer (only once)
Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser

# Analyze a single script
Invoke-ScriptAnalyzer -Path 'path/to/script.ps1'

# Analyze all scripts in repository
Get-ChildItem -Path . -Filter *.ps1 -Recurse | ForEach-Object {
    $results = Invoke-ScriptAnalyzer -Path $_.FullName
    if ($results) {
        Write-Host "❌ $($_.Name): $($results.Count) issue(s)" -ForegroundColor Red
        $results | Format-Table -Property Severity, Line, RuleName, Message
    } else {
        Write-Host "✅ $($_.Name)" -ForegroundColor Green
    }
}
```

### Option 2: Syntax-Only Check

Test syntax using the PowerShell Parser (does not detect invalid commands):

```powershell
# Test a single script
$errors = $null
[System.Management.Automation.Language.Parser]::ParseFile(
    'path/to/script.ps1',
    [ref]$null,
    [ref]$errors
)
if ($errors) {
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Red }
} else {
    Write-Host "✅ No syntax errors found" -ForegroundColor Green
}
```

To test all PowerShell scripts in the repository:

```powershell
Get-ChildItem -Path . -Filter *.ps1 -Recurse | ForEach-Object {
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile(
        $_.FullName,
        [ref]$null,
        [ref]$errors
    )
    if ($errors) {
        Write-Host "❌ $($_.Name): $($errors.Count) error(s)" -ForegroundColor Red
    } else {
        Write-Host "✅ $($_.Name)" -ForegroundColor Green
    }
}
```

## 📋 What is Validated?

### Step 1: Syntax Validation (PowerShell Parser)
Structural syntax checking:
- ✅ Missing brackets, parentheses, braces
- ✅ Unclosed strings or blocks
- ✅ Invalid parameter definitions
- ✅ Malformed function declarations

### Step 2: Code Analysis (PSScriptAnalyzer)
Code quality and semantic validation:
- ✅ **Invalid commands** (e.g., `asdfasdfasdf`, undefined cmdlets)
- ✅ **Incorrect usage** of cmdlets and functions
- ✅ **Best practices** violations
- ✅ **Code style** issues
- ✅ **Potential bugs** and anti-patterns
- ✅ **Performance** issues

**What is NOT validated:**
- ❌ Script execution or runtime errors
- ❌ Logic correctness
- ❌ External dependencies availability
- ❌ Environment-specific issues

## 🔧 Requirements

- **GitHub Actions:** Windows-latest runner with PowerShell (included)
- **Local Testing:**
  - PowerShell 5.1+ or PowerShell Core 7+
  - PSScriptAnalyzer module (install with `Install-Module PSScriptAnalyzer`)

## 📊 Workflow Results

After each run, you'll see two validation steps:

**Step 1: Syntax Validation**
- List of all checked scripts
- ✅ Pass/❌ Fail status for structural syntax
- Detailed error messages with line numbers

**Step 2: PSScriptAnalyzer**
- Code quality analysis results
- ❌ Errors (blocks merge)
- ⚠️ Warnings (informational only)
- ℹ️ Info messages
- Specific rule violations with line numbers

The workflow **fails** if:
- ❌ Any syntax errors found (Step 1)
- ❌ Any PSScriptAnalyzer errors found (Step 2)

The workflow **succeeds** with warnings if:
- ✅ No syntax errors or PSScriptAnalyzer errors
- ⚠️ PSScriptAnalyzer warnings present (review recommended)

## 🔄 Future Enhancements

Potential future additions:
- ✅ ~~PSScriptAnalyzer (linting and best practices)~~ **Implemented!**
- Pester unit tests for functional testing
- Code coverage reports
- Multi-version PowerShell testing (5.1, 7.x)
- Custom PSScriptAnalyzer rules
