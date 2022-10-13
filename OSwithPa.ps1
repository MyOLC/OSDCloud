#================================================
#   OS
#   Start-OSDCloud with Params
#================================================
$Params = @{
    OSBuild = "21H2"
    OSEdition = "Enterprise"
    OSLanguage = "en-us"
    OSLicense = "Volume"
    SkipAutopilot = $true
    SkipODT = $true
}
Start-OSDCloud @Params
