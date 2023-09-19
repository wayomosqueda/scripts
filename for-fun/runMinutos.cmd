@echo off
setlocal

set /p durationMinutes="Minutos para mantener despierto el sistema: "
set scriptPath="%HOMEPATH%\minutos.ps1"

if not exist "%scriptPath%" (
    echo La ruta del Script no es correcta. Edita el archivo "runScript.cmd" para establecer la ruta correcta.
    pause
    exit /b 1
)

powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%scriptPath%" -durationMinutes %durationMinutes%

start "NO MAS TRABAJO!" cmd /c %HOMEPATH%\showMessage.cmd

endlocal
