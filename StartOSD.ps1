#================================================
#TODO User Input
#================================================
$BDAT = New-Object System.Management.Automation.Host.ChoiceDescription '&Bradford Diocesan Academies Trust', 'BDAT'
$GAT = New-Object System.Management.Automation.Host.ChoiceDescription '&Greenwood Academies Trust', 'GAT'
$MER = New-Object System.Management.Automation.Host.ChoiceDescription 'The &Mercian Trust', 'MER'
$trusts = [System.Management.Automation.Host.ChoiceDescription[]]($BDAT, $GAT, $MER)
$result = $host.ui.PromptForChoice("Trust", "Please choose a trust from the options below:", $trusts,-1)
$trust = switch ($result)
{
    0 { 'BDAT' }
    1 { 'GAT' }
    2 { 'MER' }
}
$Site = $null
$Check = $null
       
if($trust -eq "GAT"){
                $Sites = @('BCA','BPA','BRA','BRU','CPA','CPC','DIA','DJA','DGA','GPA','HLA','HRA','IGA','KPA','KSA','MPA','MAM','MHA','NTA','NHA','NAC','NGA','POA','QPA','RPA','SEA','SAS','SKA','SIA','SJA','STA','SFI','SFJ','SPA','WAW','WAC','WFA','WPA','GSB','GWH')
                While($check -eq $null){
                                        if($site -ne $null){Write-Host "Site not found!" -ForegroundColor Red}
                                        $Site = Read-Host "Please type a site code, in the format of BRU"
                                        $Check = $Sites | where {$_ -eq $Site}
                                        }                    
                } elseif($trust -eq "BDAT") {
                    $Sites = @('ASJ','BBEC','BFA','BVG','CCA','CSJ','CUL','EMP','HQ','IMM','OXE','SHP','STJ','STO','STO','STP','WES','WOO')
                    While($check -eq $null){
                                            if($site -ne $null){Write-Host "Site not found!" -ForegroundColor Red}
                                            $Site = Read-Host "Please type a site code, in the format of ASJ"
                                            $Check = $Sites | where {$_ -eq $Site}
                                            }     
                } elseif($trust -eq "MER"){
                    $Sites = @('ALD','GBR','LAN','QMGS','QMHS','SOA','TLS','TPT','WSS')
                    While($check -eq $null){
                                            if($site -ne $null){Write-Host "Site not found!" -ForegroundColor Red}
                                            $Site = Read-Host "Please type a site code, in the format of ALD"
                                            $Check = $Sites | where {$_ -eq $Site}
                                            }     
                }
$RHS = New-Object System.Management.Automation.Host.ChoiceDescription '&Shared', 'Shared'
$RHP = New-Object System.Management.Automation.Host.ChoiceDescription '&Personal', 'Personal'
$DfE = New-Object System.Management.Automation.Host.ChoiceDescription '&DfE', 'DfE'
$options = [System.Management.Automation.Host.ChoiceDescription[]]($RHS, $RHP, $DfE)
$result = $host.ui.PromptForChoice("Group Tag", "Please choose a group tag from the options below:", $options, 0)

$PorS = switch ($result)
{
    0 { 'Shared' }
    1 { 'Personal' }
    2 { 'DfE' }
}
if($trust -eq "BDAT" -or $trust -eq "MER"){
    if ($PorS -ne "DfE") {
        $MyGroupTag = $Site.ToUpper() + "-Hybrid-" +$PorS
    }else{
        $MyGroupTag = $Site.ToUpper() + "-" +$PorS
    }
}elseif($trust -eq "GAT") {
          $MyGroupTag = $Site.ToUpper() + $PorS
}

Write-Host "Group Tag: $MyGroupTag `r`n" -ForegroundColor Green
$outputPath = "C:\Temp\"
if (-not (Test-Path -Path $outputPath -PathType Container)) {
    New-Item -Path $outputPath -ItemType Directory
   }
$MyGroupTag | Out-File -FilePath "C:\Temp\GroupTag.txt" -Encoding utf8
Write-Host -ForegroundColor Green "Hardware Hash copied."

start /wait PowerShell -NoL -W Mi -C Start-OSDCloudGUI -Brand 'OLC'
