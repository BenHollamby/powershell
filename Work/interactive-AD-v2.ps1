function New-SwarmName {

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

    }

}

function New-SwarmTitle {

    <#
    .SYNOPSIS
    New-SwarmTitle will take a job title and capitalise it.
    .DESCRIPTION
    New-SwarmTitle takes an optional string of Title and capitalised the first letter of each string.
    .PARAMETER Title
    Optional
    Accepts value from pipeline
    Accepts value from pipeline by property name
    .EXAMPLE
    New-SwarmTitle -Title "team lead"
    Team Lead
    .EXAMPLE
    "chief technology officer" | New-SwarmTitle
    Chief Technology Officer
    .EXAMPLE
    Import-CSV C:\Temp\title.csv | New-SwarmTitle
    #>  

    [cmdletbinding()]

    param (

        [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName)]
        [string]$Title

    )

    if ($Title) {

        Write-Verbose "Capitalising Title"
        $Title = (Get-Culture).TextInfo.ToTitleCase($Title)

    }

}

function New-SwarmBranch {

    <#
    .SYNOPSIS
    New-SwarmBranch will take a branch and address and capitalise it.
    .DESCRIPTION
    New-SwarmBranch takes an optional string of Branch and or Address and capitalise the first letter of each string.
    .PARAMETER Branch
    Optional
    Accepts value from pipeline
    Accepts value from pipeline by property name
    .PARAMETER Address
    Optional
    Accepts value from pipeline
    Accepts value from pipeline by property name
    .EXAMPLE
    New-SwarmBranch -Branch "head office" -Address "666 electric blvd"
    Head Office
    666 Electric Blvd
    .EXAMPLE
    Import-CSV C:\Temp\branch.csv | New-SwarmBranch
    Head Office
    666 Electric Blvd
    #>  

    [cmdletbinding()]

    param (

        [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Branch,

        [Parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName
                   )]
        [string]$Address

    )

    if ($Branch) {

        Write-Verbose "Capitalising Branch"
        $Branch = (Get-Culture).TextInfo.ToTitleCase($Branch)

    }

    if($Address) {

        Write-Verbose "Capitalising Address"
        $Address = (Get-Culture).TextInfo.ToTitleCase($Address)

    }

    $Branch
    $Address

}

function New-SwarmMobile {

    <#
    .SYNOPSIS
    New-SwarmMobile will take a Mobile split it to a more readable format.
    .DESCRIPTION
    New-SwarmMobile takes an optional string of a Mobile number and splits it into a 3-3-4 format
    to make it more readable for humans.
    .PARAMETER Mobile
    Optional
    Accepts value from pipeline
    Accepts value from pipeline by property name
    .EXAMPLE
    New-SwarmMobile -Mobile 022222222 
    022 222 2222
    .EXAMPLE
    022222222 | New-SwarmMobile  
    022 222 2222
    .EXAMPLE
    Import-CSV C:\Temp\Mobile.csv | New-SwarmMobile
    022 222 2222
    #>  

    [cmdletbinding()]

    param (

        [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Mobile

       
    )

    if ($Mobile) {



        if ($Mobile[0] -eq '0') {
            
            Write-Verbose "Spliting Mobile to friendly number"
            $First3 = $Mobile.Substring(0,3)
            $Second3 = $Mobile.Substring(3,3)
            $LastDigits = $Mobile.Substring(6)
            $Mobile = "$First3 $Second3 $LastDigits"
        }
        
        
        elseif ($Mobile[0] -ne '0') {

            Write-Verbose "Mobile number from pipeline, appending 0 to the front"
            $Mobile = "0$Mobile"
            $First3 = $Mobile.Substring(0,3)
            $Second3 = $Mobile.Substring(3,3)
            $LastDigits = $Mobile.Substring(6)
            $Mobile = "$First3 $Second3 $LastDigits"

        }
        
    }

    

}

function New-SwarmManager {

    <#
    .SYNOPSIS
    New-SwarmManager will take a manager and grab the AD Object.
    .DESCRIPTION
    New-SwarmManager takes an optional string of a manager and if the user exists in Active Directory
    puts the ad user into a variable.
    .PARAMETER Manager
    Optional
    Accepts value from pipeline
    Accepts value from pipeline by property name
    .EXAMPLE
    New-SwarmManager -Manager "drone one"
    CN=Drone One,OU=Swarm Users,OU=Swarm,DC=swarm,DC=com
    .EXAMPLE
    "drone one" | New-SwarmManager  
    CN=Drone One,OU=Swarm Users,OU=Swarm,DC=swarm,DC=com
    .EXAMPLE
    Import-CSV C:\Temp\Manager.csv | New-SwarmManager
    CN=Drone One,OU=Swarm Users,OU=Swarm,DC=swarm,DC=com
    #>  

    [cmdletbinding()]

    param (

        [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Manager

       
    )

    if ($Manager) {

        Write-Verbose "Confirming if $Manager exists in domain"
        if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}) {

            $Manager = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}

        }

    }

}

function New-SwarmPermissions {

    <#
    .SYNOPSIS
    New-SwarmPermissions will get a users group memberships and assign them to a variable.
    .DESCRIPTION
    New-SwarmPermissions takes an optional string of a user, searches for that user in 
    Active Directory, grabs all groups memberships and assigns them to a variable.
    .PARAMETER Mobile
    Optional
    Accepts value from pipeline
    Accepts value from pipeline by property name
    .EXAMPLE
    New-SwarmPermissions -Permissions "drone one" 
    CN=Hive02,OU=Swarm Groups,OU=Swarm,DC=swarm,DC=com
    CN=Hive01,OU=Swarm Groups,OU=Swarm,DC=swarm,DC=com
    .EXAMPLE
    'drone one' | New-SwarmPermissions  
    CN=Hive02,OU=Swarm Groups,OU=Swarm,DC=swarm,DC=com
    CN=Hive01,OU=Swarm Groups,OU=Swarm,DC=swarm,DC=com
    .EXAMPLE
    Import-CSV C:\Temp\copyuser.csv | New-SwarmPermissions
    CN=Hive02,OU=Swarm Groups,OU=Swarm,DC=swarm,DC=com
    CN=Hive01,OU=Swarm Groups,OU=Swarm,DC=swarm,DC=com
    #>  

    [cmdletbinding()]

    param (

        [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Permissions

       
    )

    if ($Permissions) {

        if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}) {

            $GroupMemberShips = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}
            
            $Groups = (Get-ADUser $GroupMemberShips -Properties MemberOf).MemberOf

            $Groups

        }
        
    }

}

function Get-RandomString {

    <#
    .SYNOPSIS
    Get-RandomString will generate a random string of normal and special characters
    .DESCRIPTION
    Get-RandomString takes a mandatory input of Number which specifies how many characters
    to generate. With just the Number parameter it will produce a string with normal
    and special characters.
    With the Specials parameter, users can specify how many special characters are
    required in the string
    .PARAMETER Number
    Mandatory
    Accepts value from pipeline
    Determines how many characters will be in the string
    .PARAMETER Specials
    Optional
    Determines how many special characters required in the string.
    .EXAMPLE
    Get-RandomString -Number 10 -Specials 9
    <&:)_!@j:?
    #>
    
        [cmdletbinding()]
    
        param (
    
            [Parameter(Mandatory,
                       ValueFromPipeline)]
            [int]$Number,
    
            [int]$Specials
    
        )
    
        $Count = 0
    
        $SCharacters = ""
    
        while ($Count -ne $Number) {
    
            foreach($l in $Number) {
    
                $Count += 1
    
                $Characters = 33..126
                $Random = Get-Random $Characters
                $string = [char]$Random
    
                $SCharacters += $string
    
            }
    
        }
    
        if($Specials) {
    
             DO {
    
                    $Count = 0
    
                    $SCharacters = ""
    
                    while ($Count -ne $Number) {
    
                        foreach($l in $Number) {
    
                            $Count += 1
    
                            $Characters = 33..126
                            $Random = Get-Random $Characters
                            $string = [char]$Random
    
                            $SCharacters += $string
    
                        }
    
                    }
    
                    $arrays = $SCharacters.ToCharArray()
    
                    $normal = ''
                    $special = ''
    
                    foreach ($array in $arrays) {
    
                        if ($array -match '[^a-zA-Z0-9]') {
    
                            $special += $array
    
                        } else {
    
                            $normal += $array
    
                        }
    
                    }
    
                } Until ($special.Length -ge $Specials)
    
                $SCharacters
    
            } else {
    
                $SCharacters
    
            }
    
    } 