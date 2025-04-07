# Path to JSON file
$JsonPath = "C:\Support\LocationInfo.json"

# Check if JSON exists
if (Test-Path $JsonPath) {
    # Read JSON content
    $LocationInfo = Get-Content $JsonPath | ConvertFrom-Json

    # Extract info
    $Trust = $LocationInfo.trust
    $Site = $LocationInfo.site
    $DeviceTypeCode = $LocationInfo.devicetype
    $Room = $LocationInfo.room

    # Map short code to full name
    switch ($DeviceTypeCode.ToUpper()) {
        "P" { $DeviceTypeFull = "Personal" }
        "S" { $DeviceTypeFull = "Shared" }
        "A" { $DeviceTypeFull = "Admin" }
        "D" { $DeviceTypeFull = "DfE" }
        default { $DeviceTypeFull = "Unknown" }
    }

    # Set Environment Variables (System-wide)
    [System.Environment]::SetEnvironmentVariable("Trust", $Trust, "Machine")
    [System.Environment]::SetEnvironmentVariable("Academy", $Site, "Machine")
    [System.Environment]::SetEnvironmentVariable("DeviceType", $DeviceTypeFull, "Machine")
    [System.Environment]::SetEnvironmentVariable("Room", $Room, "Machine")

    # Get Serial Number
    $SerialNumber = (Get-WmiObject Win32_BIOS).SerialNumber.Trim()

    # Build new name: site-devicetypecode-serial
    $NewName = "$Site-$DeviceTypeCode-$SerialNumber"

    # Rename
    #Rename-Computer -NewName $NewName -Force -Restart
    Rename-Computer -NewName $NewName
}
else {
    Write-Host "LocationInfo.json not found at $JsonPath"
}
