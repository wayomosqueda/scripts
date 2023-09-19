@echo off
setlocal

set /p stopTime="Escribe la hora (HH:mm) a la que quieres detener el script: "
set scriptPath="%HOMEPATH%\horaFinal.ps1"

if "%stopTime:~2,1%" NEQ ":" (
    echo Formato de Hora invalido. Utiliza el formato HH:mm
    pause
    exit /b 1
)

set "stopDateTime=%date% %stopTime%"
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%scriptPath%" -stopTime "%stopDateTime%"

start "NO MAS TRABAJO!" cmd /c %HOMEPATH%\showMessage.cmd

endlocal
