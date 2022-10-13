#================================================
#   OS
#   Start-OSDCloud with Params
#================================================
$Params = @{
    OSBuild = "21H2"
    OSEdition = "Enterprise"
    OSLanguage = "en-us"
    OSLicense = "Business"
    SkipAutopilot = $true
    SkipODT = $true
}
Start-OSDCloud @Params
