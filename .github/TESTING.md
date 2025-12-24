# PowerShell Testing Workflow

This repository includes automated syntax validation for all PowerShell scripts.

## 🚀 Automated Workflow

The GitHub Actions workflow `powershell-syntax-check.yml` automatically:

- ✅ Validates syntax of all `.ps1` files
- ✅ Runs on every push and pull request
- ✅ Provides detailed error messages with line numbers
- ✅ Prevents merging of syntactically invalid scripts

**Workflow triggers:**
- Push to any branch (when `.ps1` files are modified)
- Pull requests (when `.ps1` files are modified)
- Manual workflow dispatch

## 🧪 Local Testing

You can test PowerShell scripts locally before committing:

### Option 1: Using the Test Script

```powershell
# Run the local test script
.\Test-Syntax.ps1
```

This script:
- Scans all PowerShell files in the repository
- Validates syntax using PowerShell Parser
- Provides colored output with detailed error messages
- Exits with code 1 if any errors are found

### Option 2: Manual Testing

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
}
```

## 📋 What is Validated?

The workflow validates:
- ✅ PowerShell syntax errors
- ✅ Missing brackets, parentheses, braces
- ✅ Unclosed strings or blocks
- ✅ Invalid parameter definitions
- ✅ Malformed function declarations

**Note:** This is syntax-only validation. It does NOT:
- ❌ Execute the scripts
- ❌ Test logic or functionality
- ❌ Validate external dependencies
- ❌ Check runtime errors

## 🔧 Requirements

- **GitHub Actions:** Windows-latest runner (included)
- **Local Testing:** PowerShell 5.1+ or PowerShell Core 7+

## 📊 Workflow Results

After each run, you'll see:
- List of all checked scripts
- ✅ Pass/❌ Fail status for each script
- Detailed error messages with line numbers
- Summary of total passed/failed scripts

## 🔄 Future Enhancements

Potential future additions:
- PSScriptAnalyzer (linting and best practices)
- Pester unit tests
- Code coverage reports
- Multi-version PowerShell testing (5.1, 7.x)
