@echo off
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Sync-Repos.ps1" %*
pause