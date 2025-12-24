# PowerShell Testing Workflow

This repository includes automated validation for all PowerShell scripts using syntax checking and code quality analysis.

## 🚀 Automated Workflow

The GitHub Actions workflow `powershell-syntax-check.yml` automatically:

- ✅ **Syntax Validation** - Validates structural syntax of all `.ps1` files (Parser)
- ✅ **Code Analysis** - Analyzes code quality and best practices (PSScriptAnalyzer)
- ✅ Runs on every push and pull request
- ✅ Provides detailed error messages with line numbers
- ✅ Prevents merging of syntactically invalid or poor-quality scripts

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
Code quality and best practices validation:
- ✅ **Best practices** violations (e.g., using aliases, unapproved verbs)
- ✅ **Code style** issues (formatting, naming conventions)
- ✅ **Incorrect usage** of well-known cmdlets (wrong parameters, deprecated usage)
- ✅ **Potential bugs** and anti-patterns
- ✅ **Performance** issues (inefficient patterns)
- ✅ **Security** risks (injection vulnerabilities, credential exposure)

**What is NOT validated:**
- ❌ **Undefined commands** (e.g., `asdfasdfasdf` - could be a function defined elsewhere)
- ❌ Script execution or runtime errors
- ❌ Logic correctness
- ❌ External dependencies availability
- ❌ Environment-specific issues

**Note:** PSScriptAnalyzer is a static analysis tool. It validates code quality and best practices, but cannot detect if a command exists at runtime. Use proper testing (e.g., Pester) for functional validation.

## ❓ Why doesn't PSScriptAnalyzer catch `asdfasdfasdf`?

PSScriptAnalyzer performs **static code analysis**, not runtime validation. Here's why:

```powershell
# This is syntactically valid PowerShell
asdfasdfasdf
```

**Why it's not flagged:**
- ✅ Syntactically correct - could be a function call
- ✅ Could be defined later in the script
- ✅ Could come from an imported module
- ✅ Could be a dynamically created function

**To detect undefined commands, you would need:**
- Execute the script (risky and slow)
- Import all modules (heavy and environment-dependent)
- Use unit tests with Pester (recommended approach)

**Example of what PSScriptAnalyzer DOES catch:**
```powershell
# ❌ Using alias instead of full cmdlet
ls | where Name -eq "test"  # Warns: Use Get-ChildItem, Where-Object

# ❌ Unapproved verb
function Validate-Input { }  # Error: Use Test-Input or Confirm-Input

# ❌ Security issue
Invoke-Expression $userInput  # Warning: Potential code injection
```

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
