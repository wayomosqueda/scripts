param (
    [int]$durationMinutes = 30 
)

$durationSeconds = $durationMinutes * 60

$endTime = (Get-Date).AddSeconds($durationSeconds)

while ((Get-Date) -lt $endTime) {
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    [System.Windows.Forms.SendKeys]::SendWait("{SCROLLLOCK 2}")

    Start-Sleep -Seconds 60
}
