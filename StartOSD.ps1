Write-Host -ForegroundColor Green "Starting Cloud ZTI"
Start-Sleep -Seconds 2

start /wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Input-GroupTag.ps1
start /wait PowerShell -NoL -W Mi -C Start-OSDCloudGUI -Brand 'OLC'
