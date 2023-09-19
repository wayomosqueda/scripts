param (
    [datetime]$stopTime 
)

while ((Get-Date) -lt $stopTime) {
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    [System.Windows.Forms.SendKeys]::SendWait("{SCROLLLOCK 2}")

    Start-Sleep -Seconds 60
}
