#================================================
#   [PreOS] Update Module
#================================================
Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force

if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#=======================================================================
#   [OS] Params and Start-OSDCloud
#=======================================================================
$Params = @{
    OSVersion = "Windows 10"
    OSBuild = "22H2"
    OSEdition = "Enterprise"
    OSLicense = "Volume"
    OSLanguage = "en-gb"
    ZTI = $true
    Firmware = $true
}
Start-OSDCloud @Params

#================================================
#  [PostOS] OOBEDeploy Configuration
#================================================
Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json"
$OOBEDeployJson = @'
{
    "AddNetFX3":  {
                      "IsPresent":  true
                  },
    "Autopilot":  {
                      "IsPresent":  false
                  },
    "RemoveAppx":  [
                        Microsoft.MicrosoftSolitaireCollection"                   
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
Write-Host -ForegroundColor Green "Define Computername:"
$TargetComputername = $Serial = -join ((65..90) + (97..122) | Get-Random -Count 6 | % {[char]$_})

$AssignedComputerName = "BDAT-IMM-$TargetComputername"
Write-Host -ForegroundColor Red $AssignedComputerName
Write-Host ""

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
                   "AddToGroup",
                   "Assign"
               ],
    "PostAction":  "Quit",
    "Run":  "NetworkingWireless",
    "Docs":  "https://ourlearningcloud.org/",
    "Title":  "OLC Autopilot Register"
}
'@
$AutopilotOOBEJson += '"AssignedComputerName" : "' + $AssignedComputerName + '"}'

If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$AutopilotOOBEJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json" -Encoding ascii -Force

#================================================
#  [PostOS] OOBEDeploy CMD Command Line - 1.cmd
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\System32\1.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Set-KeyboardLanguage.ps1?token=GHSAT0AAAAAAB2TV6VJKRG2BYQVEFL5KC6MY3HRGYA
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/MyOLC/OSDCloud/Main/Install-EmbeddedProductKey.ps1?token=GHSAT0AAAAAAB2TV6VJZPTEESBQWWUB7EYQY3HRGBA
Start /Wait PowerShell -NoL -C Start-OOBEDeploy
Start /Wait PowerShell -NoL -C Restart-Computer -Force
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\System32\1.cmd' -Encoding ascii -Force

#================================================
#  [PostOS] AutopilotOOBE CMD Command Line - 2.cmd
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\System32\2.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force -Verbose
Start /Wait PowerShell -NoL -C Start-AutopilotOOBE
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://tpm.osdcloud.ch
Start /Wait PowerShell -NoL -C Restart-Computer -Force
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\System32\2.cmd' -Encoding ascii -Force

#================================================
#  [PostOS] SetupComplete CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\SetupComplete.cmd"
$SetupCompleteCMD = @'
RD C:\OSDCloud\OS /S /Q
XCOPY C:\OSDCloud\ C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD /E /H /C /I /Y
XCOPY C:\ProgramData\OSDeploy C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD /E /H /C /I /Y
RD C:\OSDCloud /S /Q
RD C:\Drivers /S /Q
RD C:\Temp /S /Q
'@
$SetupCompleteCMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\SetupComplete.cmd' -Encoding ascii -Force

Write-Host ""
Write-Host "Installing August CU for Autopilot HW hash issues" -ForegroundColor Green 
If (!(Test-Path -Path "C:\OSDCloud\CU")) {
    New-Item -Path "C:\OSDCloud\CU" -ItemType Directory
}

$SourceUrl = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/secu/2022/08/windows10.0-kb5016616-x64_94a65010a34b5bae2324c9433d1cae0b9d906d8c.msu"
Write-Host "cURL Source: $SourceUrl" -Foreground Green

$DestinationFullName = "C:\OSDCloud\CU\windows10.0-kb5016616-x64_94a65010a34b5bae2324c9433d1cae0b9d906d8c.msu"
Write-Host "Destination: $DestinationFullName" -Foreground Green

Invoke-Expression "& curl.exe --insecure --location --output `"$DestinationFullName`" --url `"$SourceUrl`""
expand -f:* "C:\OSDCloud\CU\windows10.0-kb5016616-x64_94a65010a34b5bae2324c9433d1cae0b9d906d8c.msu" C:\OSDCloud\CU\

Write-Host "Set registry keys to force a reboot" -Foreground Green
Set-ItemProperty -Path "HKLM:\System\Setup" -Name "SetupShutdownRequired" -Value 1 -Type DWORD
Set-ItemProperty -Path "HKLM:\System\Setup" -Name "SetupType" -Value 0 -Type DWORD

$UnattendXml = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="specialize">
        <component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <RunSynchronous>
                <RunSynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Description>OSDCloud Specialize</Description>
                    <Path>Powershell -ExecutionPolicy Bypass -Command Invoke-OSDSpecialize -Verbose</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <Description>OSDCloud Specialize</Description>
                    <Path>CMD /C "C:\Windows\SysWOW64\DISM.exe /Online /Add-Package /PackagePath:C:\OSDCloud\CU\windows10.0-kb5016616-x64.cab /LogPath:C:\OSDCloud\CU\DISM_CU_08_W11.log /NoRestart"</Path>
                </RunSynchronousCommand>
            </RunSynchronous>
        </component>
    </settings>
</unattend>
'@

$PantherUnattendPath = 'C:\Windows\Panther\'
if (-NOT (Test-Path $PantherUnattendPath)) {
    New-Item -Path $PantherUnattendPath -ItemType Directory -Force | Out-Null
}
$AuditUnattendPath = Join-Path $PantherUnattendPath 'Invoke-OSDSpecialize.xml'

Write-Host -ForegroundColor Green "Set Unattend.xml at $AuditUnattendPath"
$UnattendXml | Out-File -FilePath $AuditUnattendPath -Encoding utf8

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
