function New-MonarchName {

    <#
    .SYNOPSIS
    New-MonarchName will take a name and generate the strings needed to create an Active Directory user.
    .DESCRIPTION
    New-MonarchName takes a mandatory string of Name and creates, DisplayName, GivenName
    Surname, EmailAddress, SAMAccountName and UserPrincipalName, in the format specified for this mock company.
    If the name exists in this tenant, it will prompt for a middle name and amends accordingly and formats professionally.
    .PARAMETER Name
    Mandatory
    Accepts value from pipeline
    Accepts value from pipeline by property name
    Name should be put in a firstname lastname format
    .EXAMPLE
    New-MonarchName -Name "Drone One"
    .EXAMPLE
    "Drone One" | New-MonarchName
    .EXAMPLE
    Import-CSV C:\Temp\Names.csv | New-MonarchName
    #>    

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName
                   )]
        [string]$Name

    )

    BEGIN {

    }

    PROCESS {

        Write-Verbose "Checking $Name against Active Directory"
    
        if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Name"}) {

            Write-Host ''
            Write-Warning "$Name exists in Active Directory"

            Do {

                Write-Host ''
                Write-Host "================== Options ===================="
                Write-Host -ForegroundColor Yellow " Press '1' to confirm this is a new user with the same name as an existing employee."
                Write-Host -ForegroundColor Yellow " Press '2' to try again."
                Write-Host -ForegroundColor Yellow " Press 'q' to quit."
                Write-Host "==============================================="
                Write-Host ''

                $UserNameSelection = Read-Host "Please make a selection"
                Write-Host ''

            } until ($UserNameSelection -eq 1 -or $UserNameSelection -eq 2 -or $UserNameSelection -eq 'q')

            if ($UserNameSelection -eq 1) {

                Write-Verbose "User comfirmed with same name, asking for middle name"
                $Middle = Read-Host "Please enter $Name's middle Name"

                $GivenName         = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0])
                $Surname           = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1])
                $FirstName         = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0])
                $LastName          = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1])
                $MiddleName        = (Get-Culture).TextInfo.ToTitleCase($Middle)
                $FirstInitial      = $FirstName[0]
                $MiddleInitial     = $MiddleName[0]
                $DisplayName       = "$FirstName $MiddleInitial $LastName"
                $EmailAddress      = "$FirstInitial$MiddleInitial.$LastName@swarm.com"
                $SAMAccountName    = "$FirstInitial$MiddleInitial.$LastName"
                $UserPrincipalName = $EmailAddress

            }

            elseif ($UserNameSelection -eq 2) {

                Write-Verbose "Selection equals 2, name prompt"
                Do {

                    $Name = Read-Host "What is the users first and last name"

                } until ($Name -ne '')

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Name"}) {

                    Write-Verbose "User comfirmed with same name, asking for middle name"
                    $Middle = Read-Host "Please enter $Name's middle Name"

                    $GivenName         = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0])
                    $Surname           = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1])
                    $FirstName         = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0])
                    $LastName          = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1])
                    $MiddleName        = (Get-Culture).TextInfo.ToTitleCase($Middle)
                    $FirstInitial      = $FirstName[0]
                    $MiddleInitial     = $MiddleName[0]
                    $DisplayName       = "$FirstName $MiddleInitial $LastName"
                    $EmailAddress      = "$FirstInitial$MiddleInitial.$LastName@swarm.com"
                    $SAMAccountName    = "$FirstInitial$MiddleInitial.$LastName"
                    $UserPrincipalName = $EmailAddress

                }

                else {

                    $GivenName         = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0])
                    $Surname           = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1])
                    $DisplayName       = (Get-Culture).TextInfo.ToTitleCase($Name)
                    $EmailPartOne      = $Name.Split()[0].tostring()[0]
                    $EmailPartTwo      = $Name.Split()[1]
                    $EmailAddress      = "$Emailpartone.$emailparttwo@swarm.com"
                    $UserPrincipalName = $EmailAddress
                    $SAMAccountName    = "$EmailPartOne.$EmailPartTwo"

                }

            }

            elseif ($UserNameSelection -eq 'q') {

                Write-Verbose "Breaking out of script"
                Break

            }

        }

        else {

            $GivenName         = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0])
            $Surname           = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1])
            $DisplayName       = (Get-Culture).TextInfo.ToTitleCase($Name)
            $EmailPartOne      = $Name.Split()[0].tostring()[0]
            $EmailPartTwo      = $Name.Split()[1]
            $EmailAddress      = "$Emailpartone.$emailparttwo@swarm.com"
            $UserPrincipalName = $EmailAddress
            $SAMAccountName    = "$EmailPartOne.$EmailPartTwo"

        }
            
    }

    END {

        <# HASHED OUT, unhash for troubleshooting
        $GivenName
        $Surname
        $DisplayName
        $EmailAddress
        $SAMAccountName
        $UserPrincipalName
        #>

    }

}