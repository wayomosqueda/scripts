# Define el path del registro para las Políticas de Grupo Locales
$RegistryPath = "HKLM:\Software\Policies\Microsoft\Edge"

# Nombre y valor de la clave para habilitar la página de nueva pestaña
$KeyName1 = "NewTabPageLocation"
$KeyValue1 = "https://google.com/"

# Habilitar la directiva para la ubicación de la página de nueva pestaña
$KeyName2 = "NewTabPageLocationEnabled"
$KeyValue2 = 1

# Verificar si la ruta del registro existe, si no, crearla
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force
}

# Establecer la ubicación de la página de nueva pestaña
Set-ItemProperty -Path $RegistryPath -Name $KeyName1 -Value $KeyValue1

# Habilitar la directiva
Set-ItemProperty -Path $RegistryPath -Name $KeyName2 -Value $KeyValue2

Write-Host "Directiva habilitada correctamente. Reinicia Microsoft Edge para aplicar los cambios."
