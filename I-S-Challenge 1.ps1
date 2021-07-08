# Your primary goal is to write a set of PowerShell functions that will GET
# and SET the registered user and organization for the local Windows computer.
# This is information you can see when you run the winver command. 
# This information is stored in the Windows registry.

function Get-OrganisationDetails {

    $owner = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name RegisteredOwner).RegisteredOwner
    $ownerstring = (Get-culture).TextInfo.ToTitleCase($owner)

    $org = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name RegisteredOrganization).RegisteredOrganization
    $orgstring = (Get-culture).TextInfo.ToTitleCase($org)

    Write-Host -ForegroundColor Green "Owner of this machine is: $ownerstring `nOrganisation is: $orgstring"

}

# For the SET function, you should let the user specify if they want to set the user and/or organization.
# The output should show the computer name and the registered values.

function Set-OrganisationDetails {
    
    
    
}