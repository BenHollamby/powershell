function New-SwarmUser {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName
                   )]
        [array]$Objects

    )

    BEGIN {

        Write-Verbose "Quick 12 charcter password generato"

        $Number = 12
        $Count = 0
        $RandomPassword = ""
        while ($Count -ne $Number) {
    
            foreach($l in $Number) {
    
                $Count += 1
    
                $Characters = 33..126
                $Random = Get-Random $Characters
                $string = [char]$Random
                $RandomPassword += $string
    
            }
    
        }

        $Password = ConvertTo-SecureString -AsPlainText $RandomPassword -Force

    } #

    PROCESS {

        $Objects | ForEach-Object {

            foreach ($_ in $objects) {

                $Name        = $_.Name
                $Title       = $_.Title
                $Branch      = $_.Branch
                $Address     = $_.Address
                $Mobile      = $_.Mobile
                $Manager     = $_.Manager
                $Permissions = $_.Permissions

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

                } ####### End Of Name Section #####
                ######### Start of Title Section ##

                if ($Title) {

                    Write-Verbose "Capitalising Title"
                    $Title = (Get-Culture).TextInfo.ToTitleCase($Title)

                }

                ####### End of Title Section ######
                ####### Start of Branch Section ###

                if ($Branch) {

                    Write-Verbose "Capitalising Branch"
                    $Branch = (Get-Culture).TextInfo.ToTitleCase($Branch)

                }

                ####### End of Branch Section ######
                ####### Start of Address Section ###

                if($Address) {

                    Write-Verbose "Capitalising Address"
                    $Address = (Get-Culture).TextInfo.ToTitleCase($Address)

                }

                ####### End of Address Section ######
                ####### Start of Mobile Section ###
                
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

                ####### End of Mobile Section ######
                ####### Start of Manager Section ###

                if ($Manager) {

                    Write-Verbose "Confirming if $Manager exists in domain"
                    if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}) {

                        $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}

                    }

                }

                ####### End of Manager Section ######
                ####### Start of Permissions Section ###

                if ($Permissions) {

                    if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}) {

                        $GroupMemberShips = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}
            
                        $Groups = (Get-ADUser $GroupMemberShips -Properties MemberOf).MemberOf

                    }
        
                }

                ####### End of Permissions Section ######
                ####### Start of User creation Section ###

                Try {

                    Write-Verbose "Attempting to create $DisplayName"
                    New-ADUser -Path "OU=Swarm Users,OU=Swarm,DC=swarm,DC=com" -Name $DisplayName -Title $Title -Office $Branch -MobilePhone $Mobile -StreetAddress $address -EmailAddress $EmailAddress -AccountPassword $Password -Enabled $true -DisplayName $DisplayName -GivenName $GivenName -Surname $Surname -UserPrincipalName $UserPrincipalName -SamAccountName $SAMAccountName -Manager $ManagerIs -ErrorAction Stop

                } Catch {

                    Write-Warning "Unable to create user $DisplayName"
                    Write-Warning "$Error[0]"

                }

                ####### End of user creation Section ######
                ####### Start of User memberships Section ###

                $NewUser = Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$DisplayName"}

                foreach ($group in $Groups) {
                    
                    Try {

                        Write-Verbose "Assigning $NewUser to $Group Group"
                        Add-ADGroupMember -Identity $Group -Members $NewUser -ErrorAction Stop

                    } Catch {

                        Write-Warning "Unable to add $NewUser to $Group group"
                        Write-Warning "Error[0]"

                    }

                }

                ####### End of User Memberships Section ######
                ##############################################

                $Results = @()

                $Results += [PSCustomObject]@{

                    Name         = $NewUser.Name
                    EmailAddress = $NewUser.UserPrincipalName
                    UserName     = $NewUser.SamAccountName
                    Password     = $RandomPassword

                }

            } #

        }

        $Results | Select-Object Name, EmailAddress, UserName, Password

    }

    END {

    }

}