function Show-Trust {
    Write-Host "=== Select the trust from below ==="
    Write-Host "1. BDAT"
    Write-Host "2. GAT"
    Write-Host "3. MER"
    Write-Host "Q. Quit"
    Write-Host ""
}
function Show-BDATSites {
    Write-Host "=== Select the BDAT site below ==="
    Write-Host "1. ASJ- The Academy at St James"
    Write-Host "2. BAI - Baildon CE Primary School"
    Write-Host "3. BBEC - Buttershaw Business and Enterprise College"
    Write-Host "4. BFA - Bradford Forster Academey"
    Write-Host "5. BGGS - Bradford Girls' Grammar School"
    Write-Host "6. BVG - Belle Vue Girls Academy"
    Write-Host "7. CCA - Christ Church Academy"
    Write-Host "8. CSJ - Clayton St John CE Primary"
    Write-Host "9. CUL - Cullingworth Village Primary"
    Write-Host "10. EMP - East Morton CE Primary"
    Write-Host "11. HQ - Jade Builing HQ"
    Write-Host "12. IMM -Immanuel College"
    Write-Host "13. OXE - Oxenhope CE Primary"
    Write-Host "14. SHP - Shipley CE Primary"
    Write-Host "15. STJ - St Johns CE Primary"
    Write-Host "16. STO - St Oswalds CE Primary"
    Write-Host "17. STP - St Philips CE Primary"
    Write-Host "18. WES - Westminster CE Primary"
    Write-Host "19. WOO - Woodlands CE Primary"
    Write-Host "20. WYC - Wycliffe CE Primary"
    Write-Host ""
}
function Valid-BDATChoice {
    switch ($Site) {
        "1" {$global:SiteCode = 'ASJ'}
        "2" {$global:SiteCode = 'BAI'}
        "3" {$global:SiteCode = 'BBEC'}
        "4" {$global:SiteCode = 'BFA'}
        "5" {$global:SiteCode = 'BGGS'}
        "6" {$global:SiteCode = 'BVG'}
        "7" {$global:SiteCode = 'CCA'}
        "8" {$global:SiteCode = 'CSJ'}
        "9" {$global:SiteCode = 'CUL'}
        "10" {$global:SiteCode = 'EMP'}
        "11" {$global:SiteCode = 'HQ'}
        "12" {$global:SiteCode = 'IMM'}
        "13" {$global:SiteCode = 'OXE'}
        "14" {$global:SiteCode = 'SHP'}
        "15" {$global:SiteCode = 'STJ'}
        "16" {$global:SiteCode = 'STO'}
        "17" {$global:SiteCode = 'STP'}
        "18" {$global:SiteCode = 'WES'}
        "19" {$global:SiteCode = 'WOO'}
        "20" {$global:SiteCode = 'WYC'}
        Default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red } 
    }
}
function Valid-GATChoice {
    switch ($Site) {
        "1" {$global:SiteCode = 'BCA'}
        "2" {$global:SiteCode = 'BPA'}
        "3" {$global:SiteCode = 'BRA'}
        "4" {$global:SiteCode = 'BRI'}
        "5" {$global:SiteCode = 'CPA'}
        "6" {$global:SiteCode = 'CPC'}
        "7" {$global:SiteCode = 'DfE'}
        "8" {$global:SiteCode = 'DGA'}
        "9" {$global:SiteCode = 'DIA'}
        "10" {$global:SiteCode = 'DJA'}
        "11" {$global:SiteCode = 'GPA'}
        "12" {$global:SiteCode = 'GWH'}
        "13" {$global:SiteCode = 'HLA'}
        "14" {$global:SiteCode = 'IGA'}
        "15" {$global:SiteCode = 'KPA'}
        "16" {$global:SiteCode = 'KSA'}
        "17" {$global:SiteCode = 'MAM'}
        "18" {$global:SiteCode = 'MHA'}
        "19" {$global:SiteCode = 'MPA'}
        "20" {$global:SiteCode = 'NAC'}
        "21" {$global:SiteCode = 'NGA'}
        "22" {$global:SiteCode = 'NHA'}
        "23" {$global:SiteCode = 'NTA'}
        "24" {$global:SiteCode = 'POA'}
        "25" {$global:SiteCode = 'QPA'}
        "26" {$global:SiteCode = 'RPA'}
        "27" {$global:SiteCode = 'SAS'}
        "28" {$global:SiteCode = 'SEA'}
        "29" {$global:SiteCode = 'SFI'}
        "30" {$global:SiteCode = 'SFJ'}
        "31" {$global:SiteCode = 'SIA'}
        "32" {$global:SiteCode = 'SJA'}
        "33" {$global:SiteCode = 'SKA'}
        "34" {$global:SiteCode = 'SPA'}
        "35" {$global:SiteCode = 'STA'}
        "36" {$global:SiteCode = 'WAC'}
        "37" {$global:SiteCode = 'WAW'}
        "38" {$global:SiteCode = 'WFA'}
        "39" {$global:SiteCode = 'WPA'}
        Default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red}
    }
}
function Welcome {
        Clear-Host
        $welcomeScreen = "ICBfX18gICAgICAgICAgICAgICBfICAgICAgICAgICAgICAgICAgICAgICAgICBfICAgICAgICAgICAgICAgICAgICAgICMjIyMjIyMjKgogLyBfIFwgXyAgIF8gXyBfXyAgfCB8ICAgIF9fXyAgX18gXyBfIF9fIF8gX18gKF8pXyBfXyAgIF9fIF8gICAgICAgICMjIyMjKiojIyMjKiArKysrCnwgfCB8IHwgfCB8IHwgJ19ffCB8IHwgICAvIF8gXC8gX2AgfCAnX198ICdfIFx8IHwgJ18gXCAvIF9gIHwgICAgKyojIyAgICAgICAgICsrKysrKysrCnwgfF98IHwgfF98IHwgfCAgICB8IHxfX3wgIF9fLyAoX3wgfCB8ICB8IHwgfCB8IHwgfCB8IHwgKF98IHwgICsrKysqIyAgICAgICAgID0rKysrKysrKysrCiBcX19fLyBcX18sX3xffCAgICB8X19fX19cX19ffFxfXyxffF98ICB8X3wgfF98X3xffCB8X3xcX18sIHwgKysrKyAgICAgICAgICAgICsrKysrKysrKysrCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8X19fLyAgICsrCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX19fXyAgIF8gICAgICAgICAgICAgICAgICAgICAgIF8gICsrKysgICAgICAgICAgICAgIDo6OjoKICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8gX19ffCB8IHwgICBfX18gICAgXyAgIF8gICAgX198IHwgICsrKysrKysrKyoqKzo6Ojo6Ojo6CiAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgfCAgICAgfCB8ICAvIF8gXCAgfCB8IHwgfCAgLyBfYCB8CiAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgfF9fXyAgfCB8IHwgKF8pIHwgfCB8X3wgfCB8IChffCB8CiAgICAgICAgICAgICAgICAgICAgICAgICAgICBcX19fX3wgfF98ICBcX19fLyAgIFxfXyxffCAgXF9fLF98Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQogICAgICAgICAgICAgaHR0cHM6Ly9vdXJsZWFybmluZ2Nsb3VkLm9yZwogICAgICAgICAgICAgICAgICAgICAgQmhhdmluIFBhdGVsCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ=="
        Write-Host $([system.text.encoding]::UTF8.GetString([system.convert]::FromBase64String($welcomeScreen)))
        Start-Sleep -Seconds 2
}
function Valid-DeviceType {
    switch ($DeviceTypes) {
        "1" {$global:DeviceType = "Shared"}
        "2" {$global:DeviceType = "Personal"}
        "3" {$global:DeviceType = "Dfe"}
        Default {Write-Host "Invalid choice. Please try again." -ForegroundColor Red} 
    }
}
function Show-GATSites {
    Write-Host "=== Select the GAT site below ==="
    Write-Host "1. BCA - Bishop Creighton Academy"
    Write-Host "2. BPA - Beacon Primary Academy"
    Write-Host "3. BRA - The Bramble Academy"
    Write-Host "4. BRI - The Brunts Academy"
    Write-Host "5. CPA - City of Peterborough Academy"
    Write-Host "6. CPC - Corby Primary Academy"
    Write-Host "7. DfE - Department of Education"
    Write-Host "8. DGA - Dogsthorpe Junior Academy"
    Write-Host "9. DIA - Danesholme Infant Academy"
    Write-Host "10. DJA - Danesholme Junior Academy"
    Write-Host "11. GPA - Greenoaks Primary Academy"
    Write-Host "12. GWH - Greenwood House"
    Write-Host "13. HLA - Hazel Leys Academy"
    Write-Host "14. IGA - Ingoldmells Academy"
    Write-Host "15. KPA - Kingswood Primary Academy"
    Write-Host "16. KSA - Kingswood Secondary Academy"
    Write-Host "17. MAM - Mansfield Primary Academy"
    Write-Host "18. MHA - Medeshamstede Academy"
    Write-Host "19. MPA - Mablethorpe Primary Academy"
    Write-Host "20. NAC - Nottingham Academy"
    Write-Host "21. NGA - Nottingham Girls Academy"
    Write-Host "22. NHA - Newark Hill Academy"
    Write-Host "23. NTA - Nethergate Academy"
    Write-Host "24. POA - Purpleoaks Academy"
    Write-Host "25. QPA - Queensmead Primary Academy"
    Write-Host "26. RPA - Rushden Primary Academy"
    Write-Host "27. SAS - Skegby Junior Academy"
    Write-Host "28. SEA - Seathome Primary Academy"
    Write-Host "29. SFI - Studfall Infant Academy"
    Write-Host "30. SFJ - Studfall Junior"
    Write-Host "31. SIA - Skegness Infants Academy"
    Write-Host "32. SJA - Skegness Junior Academy"
    Write-Host "33. SKA - Skegness Academy"
    Write-Host "34. SPA - Sunnyside Primary Academy"
    Write-Host "35. STA - Stanground Academy"
    Write-Host "36. WAC - Wells Academy"
    Write-Host "37. WAW - Welland Primary Academy"
    Write-Host "38. WFA - Weston Favell Academy"
    Write-Host "39. WPA - Woodvale Primary Academy"
    Write-Host ""
}
function Show-MERSites {
    Write-Host "=== Select the MER site below ==="
    Write-Host "1. ALD - Aldridge School"
    Write-Host "2. GBR - Q3 Academy Great Barr"
    Write-Host "3. LAN - Q3 Academy Langley"
    Write-Host "4. HQ - Mercian House"
    Write-Host "5 .QMGS - Queen MaD'S Grammar"
    Write-Host "6 .QMHS - Queen Marys High School"
    Write-Host "7. SOA - Shire Oak Academy"
    Write-Host "8 .TLS - The Ladder School"
    Write-Host "9. TPT - Q3 Academy Tipton"
    Write-Host "10. WSS - Walsall Studio School"
    Write-Host ""
}
function Valid-MERChoice{
    switch ($Site)
    {
        "1" {$global:SiteCode = 'ALD'}
        "2" {$global:SiteCode = 'GBR'}
        "3" {$global:SiteCode = 'LAN'}
        "4" {$global:SiteCode = 'MER'}
        "5" {$global:SiteCode = 'QMG'}
        "6" {$global:SiteCode = 'QMH'}
        "7" {$global:SiteCode = 'SOA'}
        "8" {$global:SiteCode = 'TLS'}
        "9" {$global:SiteCode = 'TPT'}
        "10" {$global:SiteCode = 'WSS'}
        Default {Write-Host "Invalid choice. Please try again."-ForegroundColor Red}
    }
}
function Show-DeviceType {
    Write-Host "=== Please select type of device ==="
    Write-Host "1. Shared"
    Write-Host "2. Personal"
    Write-Host "3. DfE"
    Write-Host ""
}

function Show-Location {
    $SiteLocation = @("BAI","BGGS")
    if ($SiteLocation -contains $global:SiteCode.ToUpper() ){
        if($global:SiteCode -eq "BAI"){
            Write-Host "=== Please select location of device ==="
            Write-Host "0. Blank (No Room)"
            Write-Host "1. Room 73"
            Write-Host ""
            do {
               $choice = get-UserChoice
                switch ($choice) {
                    "1" {$global:Room = "-73"}
                    "0" {$global:Room = ""}
                    Default {Write-Host "Invalid choice. Please try again."-ForegroundColor Red} 
                }
            } while ($global:Room -eq $null)

        }elseif($global:SiteCode -eq "BGGS"){
            $Phase = $null
            if ($global:DeviceType -eq "Personal"){
                Write-Host "=== Please select School Phase ==="
                Write-Host "1. Senior Phase Staff"
                Write-Host "2. Primary Phase Staff"
                do {
                    $choice = Get-UserChoice
                    switch ($choice){
                        "1" {$Phase = "-SPStaff"}
                        "2" {$Phase = "-PPStaff"}
                        Default {Write-Host "Invalid choice. Please try again."-ForegroundColor Red} 
                    } 
                } while ($Phase -eq $null)
            
            }
            Write-Host "=== Please select location of device ==="
            Write-Host "0. Blank (No Room)"
            Write-Host "1. Room B02"
            Write-Host "2. Room B08"
            Write-Host "3. Room F10"
            Write-Host "4. Room F11"
            Write-Host "5. Room F17"
            Write-Host "6. Room F18"
            Write-Host "7. Isolation Room"
            Write-Host "8. Senior Phase Library"
            Write-Host "9. Trolley 01"
            Write-Host "10. Trolley 02"
            Write-Host ""
            do {
                $choice = get-UserChoice
                 switch ($choice) {
                     "0" {$global:Room = "" + $Phase}
                     "1" {$global:Room = "-B02"+ $Phase}
                     "2" {$global:Room = "-B08"+ $Phase}
                     "3" {$global:Room = "-F10"+ $Phase}
                     "4" {$global:Room = "-F11"+ $Phase}
                     "5" {$global:Room = "-F17"+ $Phase}
                     "6" {$global:Room = "-F18"+ $Phase}
                     "7" {$global:Room = "-ISO"+ $Phase}
                     "8" {$global:Room = "-SPL"+ $Phase}
                     "9" {$global:Room = "-Trolley01"+ $Phase}
                     "10" {$global:Room = "Trolley02"+ $Phase}
                     Default {Write-Host "Invalid choice. Please try again."-ForegroundColor Red}
                 }
             } while ($global:Room -eq $null)
        } 
    } 
}
function Get-UserChoice {
    Write-Host "Enter your choice:" -ForegroundColor Yellow
    $choice = Read-Host
    return $choice.ToUpper()
}
function Build-GroupTag {
    if ($global:TrustCode -eq "BDAT" -or $global:TrustCode -eq "MER") {
        if ($global:DeviceType -ne "DfE"){
            $global:GroupTag = $global:SiteCode + "-Hybrid-" + $global:DeviceType + $global:Room
        } else{
            $global:GroupTag = $global:SiteCode + "-DfE"
        }
    } elseif($global:TrustCode -eq "GAT"){
        if ($global:DeviceType -ne "DfE"){
            $global:GroupTag = $global:SiteCode + $global:DeviceType + $global:Room
        }else{
            if (($global:SiteCode -ne "BRA") -And ($global:SiteCode -ne "BRI")) {
                $global:GroupTag = $global:SiteCode + "DfE"
            } else {
                $global:GroupTag = $global:SiteCode + "-DfE"
            }
            
        }
    }
}
function Main {
    $global:SiteCode = $null
    $global:TrustCode = $null
    $global:DeviceType = $null
    $global:GroupTag = $null
    $global:Room = $null
    $choice = ""
    do {
        Show-Trust
        $choice = Get-UserChoice

        switch ($choice) {
            "1" {
                $global:TrustCode = "BDAT"
                Show-BDATSites
                do {
                    $Site = Get-UserChoice
                    Valid-BDATChoice
                } while ($SiteCode -eq $null)
                Show-DeviceType
                do {
                    $DeviceTypes = Get-UserChoice
                    Valid-DeviceType
                } while ($DeviceType -eq $null)
                Show-Location
                $Choice = "Q" 
                Build-GroupTag
                Write-Host "Group Tag: "$global:GroupTag -ForegroundColor Green
            }
            "2" {
                $global:TrustCode = "GAT"
                Show-GATSites
                do {
                    $Site = Get-UserChoice
                    Valid-GATChoice
                } while ($SiteCode -eq $null)
                Show-DeviceType
                do {
                    $DeviceTypes = Get-UserChoice
                    Valid-DeviceType
                } while ($DeviceType -eq $null)
                Show-Location
                $Choice = "Q" 
                Build-GroupTag
                Write-Host "Group Tag: "$global:GroupTag -ForegroundColor Green
            }
            "3" {   
                $global:TrustCode = "MER"
                Show-MERSites
                do {
                    $Site = Get-UserChoice
                    Valid-MERChoice
                } while ($SiteCode -eq $null)
                Show-DeviceType
                do {
                    $DeviceTypes = Get-UserChoice
                    Valid-DeviceType
                } while ($DeviceType -eq $null)
                Show-Location
                $Choice = "Q" 
                Build-GroupTag
                Write-Host "Group Tag: "$global:GroupTag -ForegroundColor Green
            }
            "Q" {
                Write-Host "Exiting..."
            }
            default {
                Write-Host "Invalid choice. Please try again." -ForegroundColor Red
            }
        }
        
    } while ($choice -ne "Q")
}
Welcome
Main
#Variables to define the Windows OS / Edition etc to be applied during OSDCloud
$OSVersion = 'Windows 10' #Used to Determine Driver Pack
$OSReleaseID = '22H2' #Used to Determine Driver Pack
$OSName = 'Windows 10 22H2 x64'
$OSEdition = 'Enterprise'
$OSActivation = 'Retail'
$OSLanguage = 'en-gb'
#Set OSDCloud Vars
$Global:MyOSDCloud = [ordered]@{
    Restart = [bool]$False
    RecoveryPartition = [bool]$False
    OEMActivation = [bool]$True
    WindowsUpdate = [bool]$True
    WindowsUpdateDrivers = [bool]$True
    WindowsDefenderUpdate = [bool]$True
    SetTimeZone = [bool]$True
    ClearDiskConfirm = [bool]$False
    ShutdownSetupComplete = [bool]$False
    SyncMSUpCatDriverUSB = [bool]$true
}
#Launch OSDCloud
Write-Host "Starting OSDCloud" -ForegroundColor Green
write-host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"

Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage

write-host "OSDCloud Process Complete, Running Custom Actions Before Reboot" -ForegroundColor Green
if (-not(Test-Path "C:\OSDCloud\Temp" -ErrorAction SilentlyContinue)) {
        New-Item -Path "C:\OSDCloud\Temp" -ItemType Directory -Force -ErrorAction SilentlyContinue }
       
$global:GroupTag | Out-File -FilePath "C:\OSDCloud\Temp\GroupTag.txt" -Encoding utf8
Write-Host -ForegroundColor Green "GroupTag copied to local drive."
$null = Copy-Item -Path "X:\OSDCloud\Config\Scripts\SetupComplete\ServiceUI.exe" -Destination "C:\OSDCloud\ServiceUI.exe" -Force -ErrorAction SilentlyContinue
if ($global:TrustCode = "BDAT"){
    $null = Copy-Item -Path "X:\OSDCloud\Config\Scripts\SetupComplete\BDAT-HashUploadManual.ps1" -Destination "C:\OSDCloud\Scripts\HashUploadManual.ps1" -Force -ErrorAction SilentlyContinue
} elseif($global:TrustCode = "GAT"){
    $null = Copy-Item -Path "X:\OSDCloud\Config\Scripts\SetupComplete\GAT-HashUploadManual.ps1" -Destination "C:\OSDCloud\Scripts\HashUploadManual.ps1" -Force -ErrorAction SilentlyContinue
} elseif ($global:TrustCode = "MER"){
    $null = Copy-Item -Path "X:\OSDCloud\Config\Scripts\SetupComplete\MER-HashUploadManual.ps1" -Destination "C:\OSDCloud\Scripts\HashUploadManual.ps1" -Force -ErrorAction SilentlyContinue
}
Write-Host -ForegroundColor Green "ServiceUI & Hardware copied to local drive."
Start-Sleep -Seconds 120
