# Your primary goal is to write a set of PowerShell functions that will GET
# and SET the registered user and organization for the local Windows computer.
# This is information you can see when you run the winver command. 
# This information is stored in the Windows registry. This one has to set remote computers, but has the ability to have many computer names

function Get-OrganisationDetails {

    [cmdletbinding()]

    param(
        
        [Parameter(ValueFromPipeline = $True)]
        [string[]]$ComputerName = "$env:COMPUTERNAME"

    )

    foreach ($Computer in $ComputerName) {

        $owner = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name RegisteredOwner).RegisteredOwner
        $ownerstring = (Get-culture).TextInfo.ToTitleCase($owner)
    
        $org = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name RegisteredOrganization).RegisteredOrganization
        $orgstring = (Get-culture).TextInfo.ToTitleCase($org)
        
        [PSCustomObject]@{
    
            Computer     = $env:COMPUTERNAME
            Owner        = $ownerstring
            Organisation = $orgstring
    
        }
       
    }

}


# For the SET function, you should let the user specify if they want to set the user and/or organization.
# The output should show the computer name and the registered values.

function Set-OrganisationDetails {

    [cmdletbinding()]

    param(

        [Parameter(ValueFromPipeline = $true)]
        [string]$ComputerName = "$env:COMPUTERNAME"
        
    )
    
    Do {

    $response = Read-Host -Prompt "Would you like to also change the organisation name? Yes or No"

    } until ($response -eq "yes" -or $response -eq "no")


    if ($response -eq 'yes') {

        $name_entered = Read-Host -Prompt "Who is now the registered owner?"

        $org_entered = Read-Host -Prompt "What is the organisation name?"

        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name RegisteredOwner -Value $name_entered

        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name RegisteredOrganization -Value $org_entered

        Get-OrganisationDetails

    }else {
        
        $name_entered = Read-Host -Prompt "Who is now the registered owner?"

        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name RegisteredOwner -Value $name_entered

        Get-OrganisationDetails

    }
    
}