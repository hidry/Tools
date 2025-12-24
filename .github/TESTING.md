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

You can test PowerShell scripts locally before committing using the PowerShell Parser:

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
