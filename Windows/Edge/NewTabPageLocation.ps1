# Define the registry path
$RegistryPath = "HKCU:\Software\Policies\Microsoft\Edge"

# Define the name and value of the registry key
$KeyName = "NewTabPageLocation"
$KeyValue = "https://google.com/"

# Check if the registry path exists, if not, create it
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force
}

# Set the registry key value
Set-ItemProperty -Path $RegistryPath -Name $KeyName -Value $KeyValue

# Define another key to enforce the policy
$KeyName2 = "NewTabPageLocationEnabled"
$KeyValue2 = 1

# Set the registry key for enforcing the policy
Set-ItemProperty -Path $RegistryPath -Name $KeyName2 -Value $KeyValue2

Write-Host "Registry key created successfully. Please restart Microsoft Edge for changes to take effect."
