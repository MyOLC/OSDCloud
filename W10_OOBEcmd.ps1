
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
$Params = @{
    OSVersion = "Windows 10"
    OSBuild = "22H2"
    OSEdition = "Enterprise"
    OSLanguage = "en-gb"
    OSLicense = "Volume"
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
                      "IsPresent":  true
                  },
    "RemoveAppx":  [
                        "Microsoft.MicrosoftSolitaireCollection"
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  true
                      },
    "UpdateWindows":  {
                          "IsPresent":  true
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
    "GroupTag":  "BDAT-IMM-Shared",
    "GroupTagOptions":  [
                    "IMM-Hybrid-Personal",
                    "IMM-DfE"
    ],
    "Hidden":  [
                   "AssignedComputerName",
                   "AssignedUser",
                   "PostAction",
                   "AddtoGroup",
                   "Assign"
               ],
    "PostAction":  "Quit",
    "Run":  "NetworkingWireless",
    "Docs":  "https://ourlearningcloud.org/",
    "Title":  "OLC Autopilot Register"
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$AutopilotOOBEJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json" -Encoding ascii -Force

#================================================
#  [PostOS] AutopilotOOBE CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\System32\OOBE.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force -Verbose
Start /Wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Set-KeyboardLanguage.ps1?token=GHSAT0AAAAAAB2TV6VIU6O6JYOTHTAIOC7WY3HRR7A
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Install-EmbeddedProductKey.ps1?token=GHSAT0AAAAAAB2TV6VJOVETEMHO6E3W4ULIY3HRRIQ
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/AP-Prereq.ps1?token=GHSAT0AAAAAAB2TV6VJNQSPMUTUBNWKB2ZYY3HRTYA
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Start-AutopilotOOBE.ps1?token=GHSAT0AAAAAAB2TV6VJFXMUH6SO3OH2EZGAY3HRU6Q
Start /Wait PowerShell -NoL -C Start-OOBEDeploy
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/TPM.ps1?token=GHSAT0AAAAAAB2TV6VIDNM7IPV4EDIXZ2VEY3HRV6Q
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/CleanUp.ps1?token=GHSAT0AAAAAAB2TV6VJS54DTPOM22R6WOKYY3HRXMQ
Start /Wait PowerShell -NoL -C Restart-Computer -Force
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\System32\OOBE.cmd' -Encoding ascii -Force

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
