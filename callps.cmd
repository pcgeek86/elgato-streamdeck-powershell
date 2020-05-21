REM The only thing this script does is pass all command line arguments from Elgato Stream Deck software
REM over to the PowerShell script, as an array of arguments. Literally, that's all it does.
pwsh.exe -ExecutionPolicy Bypass -File "%~dp0script.ps1" %*