
#================================================
#   [PreOS] Update Module
#================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force   

#=======================================================================
#   [OS] Params and Start-OSDCloud
#=======================================================================

Write-Host -ForegroundColor Cyan "Set the Global Variables for a Driver Pack name --> none"
$Global:MyOSDCloud = @{
    DriverPackName = 'none'
    #ApplyManufacturerDrivers = $false
    #ApplyCatalogDrivers = $false
    #ApplyCatalogFirmware = $false
}

$Params = @{
    OSVersion = "Windows 10"
    OSBuild = "22H2"
    OSEdition = "Enterprise"
    OSLanguage = "en-us"
    Firmware = $false
    ZTI = $true
}
Start-OSDCloud @Params

#================================================
#  [PostOS] OOBEDeploy Configuration
#================================================
Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json"
$OOBEDeployJson = @'
{
    "Autopilot":  {
                      "IsPresent":  false
                  },
    "RemoveAppx":  [
                       "Microsoft.MicrosoftSolitaireCollection"
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  false
                      },
    "UpdateWindows":  {
                          "IsPresent":  false
                      }
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$OOBEDeployJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json" -Encoding ascii -Force

#================================================
#  [PostOS] AutopilotOOBE Configuration Staging
#================================================
Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json"
$AutopilotOOBEJson = @'
{
    "Assign":  {
                   "IsPresent":  true
               },
    "GroupTag":  "IMM-Hybrid-Shared",
    "AddToGroup": "AADGroupX",
    "AddToGroupOptions":  [
                    "AADGroupX",
                    "AADroupY"
    ],
    "Hidden":  [
                   "AssignedComputerName",
                   "AssignedUser",
                   "PostAction",
                   "GroupTag",
                   "Assign"
               ],
    "PostAction":  "Quit",
    "Run":  "NetworkingWireless",
    "Docs":  "https://google.com/",
    "Title":  "AkosCloud Autopilot Register"
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$AutopilotOOBEJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json" -Encoding ascii -Force

#================================================
#  [PostOS] AutopilotOOBE CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\System32\OOBEOLC.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force -Verbose
Start /Wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Set-KeyboardLanguage.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Install-EmbeddedProductKey.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/AP-Prereq.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Start-AutopilotOOBE.ps1
Start /Wait PowerShell -NoL -C Start-OOBEDeploy
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/TPM.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/CleanUp.ps1
Start /Wait PowerShell -NoL -C Restart-Computer -Force
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\System32\OOBEOLC.cmd' -Encoding ascii -Force

#================================================
#  [PostOS] SetupComplete CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\SetupComplete.cmd"
$SetupCompleteCMD = @'
'@
$SetupCompleteCMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\SetupComplete.cmd' -Encoding ascii -Force

#================================================
#  [PostOS] Installing August CU for Autopilot HW hash issues
#================================================
If ($Params.OSVersion -eq "Windows 10" -and $Params.OSBuild -eq "21H2") {
    Write-Host -ForegroundColor Cyan "Installing CU for Autopilot HW hash issues"
    Invoke-Expression (Invoke-RestMethod https://cu.osdcloud.ch)

    Write-Host -ForegroundColor Gray "Download August CU PPKG from Azure Blob Storage"
    Invoke-Expression "& curl.exe --insecure --location --output 'C:\OSDCloud\Packages\Install_CU.ppkg' --url 'https://XXXX.blob.core.windows.net/packages/Install_CU.ppkg'"
    
    Write-Host -ForegroundColor Gray "Importing August CU as PPKG"
    DISM.exe /Image:C:\ /Add-ProvisioningPackage /PackagePath:C:\OSDCloud\Packages\Install_CU.ppkg
}

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host "Restarting in 20 seconds!" -ForegroundColor Green
Start-Sleep -Seconds 20
wpeutil reboot
