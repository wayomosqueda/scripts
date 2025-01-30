$processes = "chrome","msedge","brave"
$browserPaths = "Google\Chrome","Microsoft\Edge","BraveSoftware\Brave-Browser"
$extensionId = "dmpgopmhgecgfpbiphgfobeaeaodaidj"
$usersPath = "C:\Users"
$localAppDataPath = "AppData\Local"
$userDataPath = "User Data"
$defaultProfileDirectory = "Default"
$preferencesFileName = "preferences"

# Load System.Web.Extensions assembly
Add-Type -AssemblyName System.Web.Extensions

# Create log file
$logDate = Get-Date -Format "yyyyMMdd"
$logFilePath = "C:\Intel\logs\LXupdate-$logDate.log"
New-Item -ItemType File -Path $logFilePath -Force | Out-Null

function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Write-Output $logEntry
    Add-Content -Path $logFilePath -Value $logEntry
}

function Enable-Profile-Incognito ($preferencesFilePath) {
    if (Test-Path $preferencesFilePath) {
        $tempPath = "$preferencesFilePath.tmp"
        $backupDate = Get-Date -Format "yyyyMMdd-HHmm"
        $backupPath = "$preferencesFilePath.$backupDate.old"
        
        try {
            # Read the JSON file
            $jsonContent = Get-Content -Path $preferencesFilePath -Raw -ErrorAction SilentlyContinue
            $serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
            $preferences = $serializer.Deserialize($jsonContent, [hashtable])

            # Check and update the incognito setting
            if (-not $preferences['extensions']['settings'][$extensionId]['incognito'] -or $preferences['extensions']['settings'][$extensionId]['incognito'] -eq $false) {
                $preferences['extensions']['settings'][$extensionId]['incognito'] = $true

                # Serialize the updated JSON
                $updatedJson = $serializer.Serialize($preferences)

                # Write to a temporary file
                Set-Content -Path $tempPath -Value $updatedJson -Encoding UTF8

                # Rename the original preferences file to preferences.YYYYMMDD-HHmm.old
                Rename-Item -Path $preferencesFilePath -NewName $backupPath -Force

                # Replace the original preferences file with the updated one
                Move-Item -Path $tempPath -Destination $preferencesFilePath -Force

                Log-Message "  Success: $preferencesFilePath"
            } else {
                Log-Message "  No update: $preferencesFilePath"
            }

        } catch {
            Log-Message "Failed to update ${preferencesFilePath}: $_"
        }
    }
}

function Enable-Incognito ([string]$username, [string]$browserPath) {
    $profilesPath = "$usersPath\$username\$localAppDataPath\$browserPath\$userDataPath"
    if (-Not (Test-Path $profilesPath)) {
        return
    }

    Log-Message "Start incognito update for $username, $browserPath"

    # Handle all preferences files under "Profile *"
    $profiles = @(Get-ChildItem -Path $profilesPath -Filter 'Profile *' -Directory -Force -ErrorAction SilentlyContinue)
    foreach ($profile in $profiles) {
        $preferencesFilePath = "$($profile.FullName)\$preferencesFileName"
        Enable-Profile-Incognito $preferencesFilePath
    }

    # Handle preferences files under Default
    $defaultProfilePath = "$profilesPath\$defaultProfileDirectory"
    Enable-Profile-Incognito "$defaultProfilePath\$preferencesFileName"

    Log-Message "Finished incognito update for $username, $browserPath"
}

### Main

# Kill browser processes
foreach ($process in $processes) {
    Log-Message "Stopping $process"
    Get-Process -Name $process -ErrorAction SilentlyContinue | Stop-Process -Force
}
# Iterate through browsers and enable incognito setting on each user profile
$users = @(Get-ChildItem -Path $usersPath -Directory -Force -ErrorAction SilentlyContinue)
foreach ($user in $users) {
    foreach ($browserPath in $browserPaths) {
        Enable-Incognito $user.Name $browserPath
    }
}
