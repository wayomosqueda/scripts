#Random pause so not all office PCs run at same time - 900 seconds is 15 mins
#start-sleep -Seconds (1..1800 | get-random)

######### Absolute monitoring values ########## 
$maxpacketloss = 2 #how much % packetloss until we alert. 
$MinimumDownloadSpeed = 75 #What is the minimum expected download speed in Mbit/ps
$MinimumUploadSpeed = 75 #What is the minimum expected upload speed in Mbit/ps
######### End absolute monitoring values ######
 
#Replace the Download URL to where you've uploaded the ZIP file yourself. We will only download this file once. 
#Latest version can be found at: https://www.speedtest.net/nl/apps/cli
#For reference we host the zip file below on our own azure account, but i have pasted the real source url below
$DownloadURL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
$DownloadLocation = "$($Env:ProgramData)\SpeedtestCLI"
try {
    $TestDownloadLocation = Test-Path $DownloadLocation
    if (!$TestDownloadLocation) {
        new-item $DownloadLocation -ItemType Directory -force
        Invoke-WebRequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\speedtest.zip"
        Expand-Archive "$($DownloadLocation)\speedtest.zip" -DestinationPath $DownloadLocation -Force
    } 
}
catch {  
    write-host "The download and extraction of SpeedtestCLI failed. Error: $($_.Exception.Message)"
    exit 1
}
$PreviousResults = if (test-path "$($DownloadLocation)\LastResults.txt") { get-content "$($DownloadLocation)\LastResults.txt" | ConvertFrom-Json }
$SpeedtestResults = & "$($DownloadLocation)\speedtest.exe" --format=json
$SpeedtestResults | Out-File "$($DownloadLocation)\LastResults.txt" -Force
$SpeedtestResults = $SpeedtestResults | ConvertFrom-Json

#Write-Output "Download Location:"
#Write-Output $DownloadLocation
 
#creating object
[PSCustomObject]$SpeedtestObj = @{
    downloadspeed = [math]::Round($SpeedtestResults.download.bandwidth / 1000000 * 8, 2)
    uploadspeed   = [math]::Round($SpeedtestResults.upload.bandwidth / 1000000 * 8, 2)
    packetloss    = [math]::Round($SpeedtestResults.packetLoss)
    isp           = $SpeedtestResults.isp
    ExternalIP    = $SpeedtestResults.interface.externalIp
    InternalIP    = $SpeedtestResults.interface.internalIp
    UsedServer    = $SpeedtestResults.server.host
    ResultsURL    = $SpeedtestResults.result.url
    Jitter        = [math]::Round($SpeedtestResults.ping.jitter)
    Latency       = [math]::Round($SpeedtestResults.ping.latency)
}
$SpeedtestHealth = @()
#Comparing against previous result. Alerting is download or upload differs more than 20%.
if ($PreviousResults) {
    if ($PreviousResults.download.bandwidth / $SpeedtestResults.download.bandwidth * 100 -le 80) { $SpeedtestHealth += "Download speed difference is more than 20%" }
    if ($PreviousResults.upload.bandwidth / $SpeedtestResults.upload.bandwidth * 100 -le 80) { $SpeedtestHealth += "Upload speed difference is more than 20%" }
}


$Output = "`n Upload Speed: " + $SpeedtestObj.uploadspeed + " Mbps"
Write-Output $Output

$Output =  "`n Download Speed: " +  $SpeedtestObj.downloadspeed + " Mbps"
Write-Output $Output

$Output =  "`n Packet Loss: " +  $SpeedtestObj.packetloss
Write-Output $Output

$Output =  "`n ISP: " +  $SpeedtestObj.isp
Write-Output $Output

$Output =  "`n Latency: " +  $SpeedtestObj.Latency + " ms"
Write-Output $Output

$Output =  "`n Test Results URL: " +  $SpeedtestObj.ResultsURL
Write-Output $Output
 
#Write-Output "Comparing against preset variables." 
#Comparing against preset variables.
if ($SpeedtestObj.downloadspeed -lt $MinimumDownloadSpeed) { $SpeedtestHealth += "Download speed is lower than $MinimumDownloadSpeed Mbit/ps" }
if ($SpeedtestObj.uploadspeed -lt $MinimumUploadSpeed) { $SpeedtestHealth += "Upload speed is lower than $MinimumUploadSpeed Mbit/ps" }
if ($SpeedtestObj.packetloss -gt $MaxPacketLoss) { $SpeedtestHealth += "Packetloss is higher than $maxpacketloss%" }
 
if (!$SpeedtestHealth) {
    $SpeedtestHealth = "Healthy"
}

