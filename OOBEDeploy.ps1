[CmdletBinding()]
param()
#region Initialize

#Start the Transcript
$Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-OSDCloud.log"
$null = Start-Transcript -Path (Join-Path "$env:SystemRoot\Temp" $Transcript) -ErrorAction Ignore

#=================================================
#   oobeCloud Settings
#=================================================
$Global:oobeCloud = @{
    oobeSetDisplay = $false
    oobeSetRegionLanguage = $true
    oobeSetDateTime = $true
    oobeRegisterAutopilot = $false
    oobeRegisterAutopilotCommand = 'Get-WindowsAutopilotInfo -Online -GroupTag Demo -Assign'
    oobeRemoveAppxPackage = $false
    oobeRemoveAppxPackageName = 'Solitaire'
    oobeAddCapability = $false
    oobeAddCapabilityName = 'GroupPolicy','ServerManager','VolumeActivation'
    oobeUpdateEdge = $true
    oobeUpdateDrivers = $true
    oobeUpdateWindows = $true
    oobeRestartComputer = $false
    EmbeddedProductKey = $true
    oobeStopComputer = $false
}

function Step-KeyboardLanguage {

    Write-Host -ForegroundColor Green "Set keyboard language to en-GB"
    $LanguageList = Get-WinUserLanguageList
    $LanguageList.Add("en-GB")
    Set-WinUserLanguageList $LanguageList -Force | Out-Null
    Start-Sleep -Seconds 5
    $LanguageList = Get-WinUserLanguageList
    $LanguageList.Remove(($LanguageList | Where-Object LanguageTag -like 'en-US'))
    Set-WinUserLanguageList $LanguageList -Force | Out-Null
}
function Step-oobeSetDisplay {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeSetDisplay -eq $true)) {
        Write-Host -ForegroundColor Yellow 'Verify the Display Resolution and Scale is set properly'
        Start-Process 'ms-settings:display' | Out-Null
        $ProcessId = (Get-Process -Name 'SystemSettings').Id
        if ($ProcessId) {
            Wait-Process $ProcessId
        }
    }
}
function Step-oobeSetRegionLanguage {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeSetRegionLanguage -eq $true)) {
        Write-Host -ForegroundColor Yellow 'Setting Region Language to en-GB'
        Set-WinSystemLocale en-GB
        Set-WinHomeLocation -GeoId 0xF2
        Set-Culture en-GB
        Set-WinUserLanguageList en-GB -Force
    }
}
function Step-oobeSetDateTime {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeSetDateTime -eq $true)) {
        Write-Host -ForegroundColor Yellow 'Setting time zone to GMT Standard Time'
        Write-Host -ForegroundColor Yellow 'If this is not configured properly, Certificates and Domain Join may fail'
        Set-TimeZone -Name 'GMT Standard Time' -PassThru
    }
}
function Step-oobeExecutionPolicy {
    [CmdletBinding()]
    param ()
    if ($env:UserName -ne 'defaultuser0') {
        if ((Get-ExecutionPolicy) -ne 'RemoteSigned') {
            Write-Host -ForegroundColor Cyan 'Set-ExecutionPolicy RemoteSigned'
            Set-ExecutionPolicy RemoteSigned -Force
        }
    }
}
function Step-oobePackageManagement {
    [CmdletBinding()]
    param ()
    if ($env:UserName -ne 'defaultuser0') {
        if (Get-Module -Name PowerShellGet -ListAvailable | Where-Object {$_.Version -ge '2.2.5'}) {
            Write-Host -ForegroundColor Cyan 'PowerShellGet 2.2.5 or greater is installed'
        }
        else {
            Write-Host -ForegroundColor Cyan 'Install-Package PackageManagement,PowerShellGet'
            Install-Package -Name PowerShellGet -MinimumVersion 2.2.5 -Force -Confirm:$false -Source PSGallery | Out-Null
    
            Write-Host -ForegroundColor Cyan 'Import-Module PackageManagement,PowerShellGet'
            Import-Module PackageManagement,PowerShellGet -Force
        }
    }
}
function Step-oobeTrustPSGallery {
    [CmdletBinding()]
    param ()
    if ($env:UserName -ne 'defaultuser0') {
        $PSRepository = Get-PSRepository -Name PSGallery
        if ($PSRepository)
        {
            if ($PSRepository.InstallationPolicy -ne 'Trusted')
            {
                Write-Host -ForegroundColor Cyan 'Set-PSRepository PSGallery Trusted'
                Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
            }
        }
    }
}
function Step-oobeInstallModuleAutopilot {
    [CmdletBinding()]
    param ()
    if ($env:UserName -ne 'defaultuser0') {
        $Requirement = Import-Module WindowsAutopilotIntune -PassThru -ErrorAction Ignore
        if (-not $Requirement)
        {
            Write-Host -ForegroundColor Cyan 'Install-Module AzureAD,Microsoft.Graph.Intune,WindowsAutopilotIntune'
            Install-Module WindowsAutopilotIntune -Force
        }
    }
}
function Step-oobeInstallModuleAzureAd {
    [CmdletBinding()]
    param ()
    if ($env:UserName -ne 'defaultuser0') {
        $Requirement = Import-Module AzureAD -PassThru -ErrorAction Ignore
        if (-not $Requirement)
        {
            Write-Host -ForegroundColor Cyan 'Install-Module AzureAD'
            Install-Module AzureAD -Force
        }
    }
}
function Step-oobeInstallScriptAutopilot {
    [CmdletBinding()]
    param ()
    if ($env:UserName -ne 'defaultuser0') {
        $Requirement = Get-InstalledScript -Name Get-WindowsAutoPilotInfo -ErrorAction SilentlyContinue
        if (-not $Requirement)
        {
            Write-Host -ForegroundColor Cyan 'Install-Script Get-WindowsAutoPilotInfo'
            Install-Script -Name Get-WindowsAutoPilotInfo -Force
        }
    }
}
function Step-oobeRegisterAutopilot {
    [CmdletBinding()]
    param (
        [System.String]
        $Command
    )
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeRegisterAutopilot -eq $true)) {
        Step-oobeInstallModuleAutopilot
        Step-oobeInstallModuleAzureAd
        Step-oobeInstallScriptAutopilot

        Write-Host -ForegroundColor Cyan 'Registering Device in Autopilot in new PowerShell window ' -NoNewline
        $AutopilotProcess = Start-Process PowerShell.exe -ArgumentList "-Command $Command" -PassThru
        Write-Host -ForegroundColor Green "(Process Id $($AutopilotProcess.Id))"
        Return $AutopilotProcess
    }
}
function Step-oobeRemoveAppxPackage {
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeRemoveAppxPackage -eq $true)) {
        Write-Host -ForegroundColor Cyan 'Removing Appx Packages'
        foreach ($Item in $Global:oobeCloud.oobeRemoveAppxPackageName) {
            if (Get-Command Get-AppxProvisionedPackage) {
                Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -Match $Item} | ForEach-Object {
                    Write-Host -ForegroundColor DarkGray $_.DisplayName
                    if ((Get-Command Remove-AppxProvisionedPackage).Parameters.ContainsKey('AllUsers')) {
                        Try
                        {
                            $null = Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName
                        }
                        Catch
                        {
                            Write-Warning "AllUsers Appx Provisioned Package $($_.PackageName) did not remove successfully"
                        }
                    }
                    else {
                        Try
                        {
                            $null = Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName
                        }
                        Catch
                        {
                            Write-Warning "Appx Provisioned Package $($_.PackageName) did not remove successfully"
                        }
                    }
                }
            }
        }
    }
}
function Step-oobeAddCapability {
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeAddCapability -eq $true)) {
        Write-Host -ForegroundColor Cyan "Add-WindowsCapability"
        foreach ($Item in $Global:oobeCloud.oobeAddCapabilityName) {
            $WindowsCapability = Get-WindowsCapability -Online -Name "*$Item*" -ErrorAction SilentlyContinue | Where-Object {$_.State -ne 'Installed'}
            if ($WindowsCapability) {
                foreach ($Capability in $WindowsCapability) {
                    Write-Host -ForegroundColor DarkGray $Capability.DisplayName
                    $Capability | Add-WindowsCapability -Online | Out-Null
                }
            }
        }
    }
}
function Step-oobeUpdateDrivers {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeUpdateDrivers -eq $true)) {
        Write-Host -ForegroundColor Cyan 'Updating Windows Drivers'
        if (!(Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore)) {
            try {
                Install-Module PSWindowsUpdate -Force
                Import-Module PSWindowsUpdate -Force
            }
            catch {
                Write-Warning 'Unable to install PSWindowsUpdate Driver Updates'
            }
        }
        if (Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore) {
            Start-Process PowerShell.exe -ArgumentList "-Command Install-WindowsUpdate -UpdateType Driver -AcceptAll -IgnoreReboot" -Wait
        }
    }
}
function Step-oobeUpdateWindows {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeUpdateWindows -eq $true)) {
        Write-Host -ForegroundColor Cyan 'Updating Windows'
        if (!(Get-Module PSWindowsUpdate -ListAvailable)) {
            try {
                Install-Module PSWindowsUpdate -Force
                Import-Module PSWindowsUpdate -Force
            }
            catch {
                Write-Warning 'Unable to install PSWindowsUpdate Windows Updates'
            }
        }
        if (Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore) {
            #Write-Host -ForegroundColor DarkCyan 'Add-WUServiceManager -MicrosoftUpdate -Confirm:$false'
            Add-WUServiceManager -MicrosoftUpdate -Confirm:$false | Out-Null
            #Write-Host -ForegroundColor DarkCyan 'Install-WindowsUpdate -UpdateType Software -AcceptAll -IgnoreReboot'
            #Install-WindowsUpdate -UpdateType Software -AcceptAll -IgnoreReboot -NotTitle 'Malicious'
            #Write-Host -ForegroundColor DarkCyan 'Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot'
            Start-Process PowerShell.exe -ArgumentList "-Command Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -NotTitle 'Preview' -NotKBArticleID 'KB890830','KB5005463','KB4481252'" -Wait
        }
    }
}
function Invoke-Webhook {
    $BiosSerialNumber = Get-MyBiosSerialNumber
    $ComputerManufacturer = Get-MyComputerManufacturer
    $ComputerModel = Get-MyComputerModel
    
    $URI = 'https://XXXX.webhook.office.com/webhookb2/YYYY'
    $JSON = @{
        "@type"    = "MessageCard"
        "@context" = "<http://schema.org/extensions>"
        "title"    = 'OSDCloud Information'
        "text"     = "The following client has been successfully deployed:<br>
                    BIOS Serial Number: **$($BiosSerialNumber)**<br>
                    Computer Manufacturer: **$($ComputerManufacturer)**<br>
                    Computer Model: **$($ComputerModel)**"
        } | ConvertTo-JSON
        
        $Params = @{
        "URI"         = $URI
        "Method"      = 'POST'
        "Body"        = $JSON
        "ContentType" = 'application/json'
        }
        Invoke-RestMethod @Params | Out-Null
}
function Step-oobeRestartComputer {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeRestartComputer -eq $true)) {
        Write-Host -ForegroundColor Cyan 'Build Complete!'
        Write-Warning 'Device will restart in 30 seconds.  Press Ctrl + C to cancel'
        Stop-Transcript
        Start-Sleep -Seconds 30
        Restart-Computer
    }
}
function Step-xEmbeddedProductKey {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.EmbeddedProductKey -eq $true)) {
        Write-Host -ForegroundColor Green "Get embedded product key"
        $Key = (Get-WmiObject SoftwareLicensingService).OA3xOriginalProductKey
        If ($Key) {
            Write-Host -ForegroundColor Green "Installing embedded product key"
            Invoke-Command -ScriptBlock {& 'cscript.exe' "$env:windir\system32\slmgr.vbs" '/ipk' "$($Key)"}
            Start-Sleep -Seconds 5

            Write-Host -ForegroundColor Green "Activating embedded product key"
            Invoke-Command -ScriptBlock {& 'cscript.exe' "$env:windir\system32\slmgr.vbs" '/ato'}
            Start-Sleep -Seconds 5
        }
        Else {
            Write-Host -ForegroundColor Red 'No embedded product key found.'
        }
    }
}
function Step-EmbeddedProductKey {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.EmbeddedProductKey -eq $true)) {
        Write-Host -ForegroundColor Green "Get embedded product key"
        $Key = (Get-WmiObject SoftwareLicensingService).OA3xOriginalProductKey
        If ($Key) {
            Write-Host -ForegroundColor Green "Installing embedded product key"
            Invoke-Command -ScriptBlock {& 'cscript.exe' "$env:windir\system32\slmgr.vbs" '/ipk' "$($Key)"}
            Start-Sleep -Seconds 5

            Write-Host -ForegroundColor Green "Activating embedded product key"
            Invoke-Command -ScriptBlock {& 'cscript.exe' "$env:windir\system32\slmgr.vbs" '/ato'}
            Start-Sleep -Seconds 5
            $WindowsProductKey =  (Get-WmiObject -query "select * from SoftwareLicensingService").OA3xOriginalProductKey
            $WindowsProductType = (Get-WmiObject -query "select * from SoftwareLicensingService").OA3xOriginalProductKeyDescription
           
            # Write-Host "[BIOS] Windows Product Key: $WindowsProductKey" -ForegroundColor Yellow
            Write-Host "[BIOS] Windows Product Type: $WindowsProductType" -ForegroundColor Yellow
            
            If($WindowsProductType -like "*Professional*" -or $WindowsProductType -eq "Windows 10 Pro" -or $WindowsProductType -like "*Enterprise*"){
                Write-Host "BIOS Windows license is suited for MS365 enrollment" -ForegroundColor Green
            }
            else{
                Write-Host "BIOS Windows license is not suited for MS365 enrollment" -ForegroundColor red
                $WindowsProductType = get-computerinfo | select WindowsProductName 
                $WindowsProductType = $WindowsProductType.WindowsProductName
                
                Write-Host "[SOFTWARE] Windows Product Key: $WindowsProductKey" -ForegroundColor Yellow
                Write-Host "[SOFTWARE] Windows Product Type: $WindowsProductType" -ForegroundColor Yellow
                
                If($WindowsProductType -like "*Professional*" -or $WindowsProductType -eq "Windows 10 Pro" -or $WindowsProductType -like "*Enterprise*"){
                    Write-Host "SOFTWARE Windows license is valid for MS365 enrollment" -ForegroundColor Green
                }
                else{
                    Write-Host "SOFTWARE Windows license is not valid for MS365 Enrollment" -ForegroundColor red
                    Write-Host "Revert the changes. Adding GVLK Key" -ForegroundColor Yellow
                    $key = "96YNV-9X4RP-2YYKB-RMQH4-6Q72D"
                    Invoke-Command -ScriptBlock {& 'cscript.exe' "$env:windir\system32\slmgr.vbs" '/ipk' "$($Key)"}
                    Start-Sleep -Seconds 5
        
                    Write-Host -ForegroundColor Green "Activating embedded product key"
                    Invoke-Command -ScriptBlock {& 'cscript.exe' "$env:windir\system32\slmgr.vbs" '/ato'}
                    Start-Sleep -Seconds 5
                    Write-Host "Successfully activated GVLK Key." -ForegroundColor Green
                }
            }
        }
        Else {
            Write-Host -ForegroundColor Red 'No embedded product key found.'
        }
    }
}

function Step-oobeStopComputer {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeStopComputer -eq $true)) {
        Write-Host -ForegroundColor Cyan 'Build Complete!'
        Write-Warning 'Device will shutdown in 30 seconds. Press Ctrl + C to cancel'
        Stop-Transcript
        Start-Sleep -Seconds 30
        Stop-Computer
    }
}

function Step-oobeUpdateEdge {
    [CmdletBinding()]
    param ()
    if (($env:UserName -ne 'defaultuser0') -and ($Global:oobeCloud.oobeUpdateEdge -eq $true)) {    
        $UpdateChannel = 'Stable'
        $Architecture = 'x64'
        $Platform = 'Windows'
    switch ($UpdateChannel) {
        'Stable' { $AppGUID = '{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}' }
        'Beta' { $AppGUID = '{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}' }
        'Canary' { $AppGUID = '{65C35B14-6C1D-4122-AC46-7148CC9D6497}' }
        'Dev' { $AppGUID = '{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}' }
        }    
        #Determine original Microsoft Edge Version
        [System.Version]$EdgeVersionOld = (Get-AppxPackage -AllUsers -Name "Microsoft.MicrosoftEdge.$UpdateChannel").Version
        if (!($EdgeVersionOld)) {
            Write-Error "Microsoft Edge $UpdateChannel not installed, exiting"
            $ExitCode = 1
        }
Else {
    Write-Host "Current Microsoft Edge version $EdgeVersionOld" -ForegroundColor Red
    #Determine latest Microsoft Edge Version depending on the update channel
    $EdgeInfo = (Invoke-WebRequest -UseBasicParsing -uri 'https://edgeupdates.microsoft.com/api/products?view=enterprise')

    [System.Version]$EdgeVersionLatest = ((($EdgeInfo.content | Convertfrom-json) | Where-Object {$_.product -eq $UpdateChannel}).releases | Where-Object {$_.Platform -eq $Platform -and $_.architecture -eq $architecture})[0].productversion
    Write-Host "Latest $UpdateChannel Microsoft Edge version is $EdgeVersionLatest" -ForegroundColor yellow
				
    #Check if Microsoft Edge is already up to date
    If ($EdgeVersionOld -ge $EdgeVersionLatest) {
        Write-Host "Microsoft Edge $UpdateChannel already up to date"
        }
    else {
        #Trigger Microsoft Edge update
        Write-Host "Launching Microsoft Edge $UpdateChannel update"
        Start-Process -FilePath "C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe" -argumentlist "/silent /install appguid=$AppGUID&appname=Microsoft%20Edge&needsadmin=True"
        Write-Host "Sleeping for 60 seconds"
        Start-Sleep -Seconds 60

        #Getting new Microsoft Edge installed version
        [System.Version]$EdgeVersionNew = (Get-AppxPackage -AllUsers -Name "Microsoft.MicrosoftEdge.$UpdateChannel").Version

        # Do While Loop to wait until Microsoft Edge Version updated if required
        Do {
            [System.Version]$EdgeVersionNew = (Get-AppxPackage -AllUsers -Name "Microsoft.MicrosoftEdge.$UpdateChannel").Version
            Write-Host "Checking current Edge version"
            Start-Sleep -Seconds 15
        } While ($EdgeVersionNew -lt $EdgeVersionLatest)
        Write-Host "Microsoft Edge $UpdateChannel version updated to $EdgeVersionNew" -ForegroundColor Green
    }

    }
    }
}
#endregion

# Execute functions
Step-KeyboardLanguage
Step-oobeExecutionPolicy
Step-oobePackageManagement
Step-oobeTrustPSGallery
Step-oobeSetDisplay
Step-oobeSetRegionLanguage
Step-oobeSetDateTime
Step-oobeRegisterAutopilot
Step-EmbeddedProductKey
Step-oobeRemoveAppxPackage
Step-oobeAddCapability
Step-oobeUpdateEdge
Step-oobeUpdateDrivers
Step-oobeUpdateWindows
# Invoke-Webhook
Step-oobeRestartComputer
Step-oobeStopComputer
#=================================================
