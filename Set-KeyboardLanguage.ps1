$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Set-KeyboardLanguage.log"
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" $Global:Transcript) -ErrorAction Ignore

Write-Host -ForegroundColor Green "Set keyboard language to en-GB"
Start-Sleep -Seconds 5

$LanguageList = Get-WinUserLanguageList

$LanguageList.Add("en-GB")
Set-WinUserLanguageList $LanguageList -Force

Start-Sleep -Seconds 5

$LanguageList = Get-WinUserLanguageList
$LanguageList.Remove(($LanguageList | Where-Object LanguageTag -like 'en-GB'))
Set-WinUserLanguageList $LanguageList -Force

$LanguageList = Get-WinUserLanguageList
$LanguageList.Remove(($LanguageList | Where-Object LanguageTag -like 'en-US'))
Set-WinUserLanguageList $LanguageList -Force

Stop-Transcript
