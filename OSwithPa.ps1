#================================================
#   OS
#   Start-OSDCloud with Params
#================================================
$Global:MyOSDCloud = @{
	ApplyManufacturerDrivers = $false
	ApplyCatalogDrivers = $false
	ApplyCatalogFirmware = $false
}
$Params = @{
    OSBuild = "21H2"
    OSEdition = "Enterprise"
    OSLanguage = "en-us"
    OSLicense = "Volume"
    SkipAutopilot = $true
    SkipODT = $true
}
Start-OSDCloud @Params
