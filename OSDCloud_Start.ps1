Write-Host -ForegroundColor Green "Starting OLC Deployment ZTI"
Start-Sleep -Seconds 5

#Make sure I have the latest OSD Content
Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force

#Start OSDCloudScriptPad
Write-Host -ForegroundColor Green "Start OSDPad"
Start-OSDPad -RepoOwner Bhavin Patel -RepoName OSDCloud -RepoFolder ScriptPad -BrandingTitle 'OLC Cloud Deployment'
