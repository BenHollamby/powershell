 function New-MonarchUser{

    [cmdletbinding()]

    param (

    )

    BEGIN {
        
        Write-Verbose "Starting BEGIN BLOCK"

        $Continue = $true

        Write-Verbose "Getting new staff member name"

        Clear-Host

#### Start of getting the name selection

        $Name = Read-Host "What is the full name of the new staff member?"
        write-host ''

        if ($Name -eq '') {

        Write-Verbose "Name is empty, warning prompt"
        write-host ''
        Write-Warning "Name is empty, do you want to continue?"

        Write-Host -ForegroundColor Yellow "================== Options ===================="
        Write-Host -ForegroundColor Yellow "1: Press '1' to try again"
        Write-Host -ForegroundColor Yellow "2: Press '2' to quit."
        Write-Host -ForegroundColor Yellow "==============================================="

        $NameSelection = Read-Host "Please confirm a selection"
        write-host ''

        if ($NameSelection -eq 1) {

            Write-Verbose "User selected $NameSelection"
            $Name = Read-Host "What is their full name?"

            if ($Name -eq '') {

                Do {

                    $Name = Read-Host "What is their full name?"

                } Until ($Name -ne '')

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq $Name}) {

                    Do {

                        Write-Warning "Sorry User exists, please try again"
                        $Name = Read-Host "What is their full name?"

                    } until (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq $Name}))

                }

            }

            else {

                Continue

            }

        }

        elseif ($NameSelection -eq 2) {

            Write-Verbose "User selected $NameSelection to quit"
            break

        }


        }

            Write-Verbose "Checking against existing users"
            if ($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)) {

                Write-Verbose "User already exists"
                Write-Warning "This user already exists"

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

                    if ($UserNameSelection -eq 1) {

                        Write-Verbose "User selected $UserNameSelection"
                        $Name = Read-Host "Please enter the full name again with their middle name"

                        if ($Name -eq '') {

                            Do {

                                $Name = Read-Host "Please enter the full name again with their middle name"

                            } Until ($Name -ne '')

                        }


                        elseif ($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)) {

                            Write-Host ''
                            Write-Warning "As stated, this user already exists"
                            Write-Host ''

                        }


                    }

                    elseif ($UserNameSelection -eq 2) {

                        Write-Verbose "User selected $UserNameSelection"
                        $Name = Read-Host "What is the full name of the new staff member?"

                        if ($Name -eq '') {

                            Do {

                                write-host ''
                                Write-Warning "Nothing entered"
                                write-host ''
                                $Name = Read-Host "Please enter a first name and a last name"

                            } Until ($Name -ne '')

                            if ($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)) {

                                write-host ''
                                write-warning "Sorry user already exists here"

                            }

                        }

                        elseif ($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)) {

                            write-host ''
                            Write-Warning "This user already exists"

                        }

                    }

                    elseif ($UserNameSelection -eq 'q') {
                        
                        Write-Verbose "User selected $UserNameSelection to quit"
                        #$Continue = $False
                        break

                    }

                    else {

                        Write-Warning "Not a valid choice, please read the prompt and try again."

                    }

                } until (-not($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)))

            }

            Clear-Host

    #### End of Name section        
    #### Start of Title selection

            Write-Host ''

            if ($Continue) {        

                Write-Verbose "Prompting for Job Title"
                $Title = Read-Host "What is $Name's job title?"

                if ($Title -eq '') {

                    Do {

                        Write-Verbose "Title is empty, warning prompt"

                        Write-Host ''
                        Write-Host -ForegroundColor Yellow "================== Options ===================="
                        Write-Host -ForegroundColor Yellow " Press '1' to enter a title"
                        Write-Host -ForegroundColor Yellow " Press '2' to skip."
                        Write-Host -ForegroundColor Yellow " Press 'q' to abort."
                        Write-Host -ForegroundColor Yellow "==============================================="
                        Write-Host ''

                        $TitleSelection = Read-Host "Please confirm a selection"
                        write-host ''

                        if ($TitleSelection -eq 1) {

                            Write-Verbose "User selected $TitleSelection"
                            $Title = Read-Host "What is their job title?"

                            if ($Title -eq '') {

                                Do {
                                    
                                    Write-Warning "Job Title is empty, please try again."
                                    $Title = Read-Host "What is their job title?"

                                } Until ($Title -ne '')

                            }

                        }

                        elseif ($TitleSelection -eq 2) {

                            Write-Verbose "User selected $TitleSelection to skip"
                            $Title = $null

                        }

                        elseif ($TitleSelection -eq 'q') {

                            Write-Verbose "User selected $TitleSelection to quit"
                            Break

                        }

                        else {
                        
                            write-host ''
                            Write-Warning "Not a valid choice, please read the above and try again"

                        }

                    } until ($Title -ne '')


                }

                write-host ''

                Clear-Host

    ##### End of Title selection
    ##### Start of branch selection         
                
                Write-Host "Which Branch will $Name be located at?"

                Write-Host ''
                Write-Host "================== Options ======================================================="
                Write-Host -ForegroundColor Green " Press '1' to select Central Branch"
                Write-Host -ForegroundColor Green " Press '2' to select Chartwell Branch"
                Write-Host -ForegroundColor Green " Press '3' to select City Branch"
                Write-Host -ForegroundColor Green " Press '4' to select Dinsdale Branch"
                Write-Host -ForegroundColor Green " Press '5' to select Glenview Branch"
                Write-Host -ForegroundColor Green " Press '6' to select Head Office"
                Write-Host -ForegroundColor Green " Press '7' to select Hillcrest Branch"
                Write-Host -ForegroundColor Green " Press '8' to select Rototuna Branch"
                Write-Host -ForegroundColor Green " Press '9' to enter a branch that doesn't exist here yet"
                Write-Host -ForegroundColor Green " Press 'Enter' to skip"
                Write-Host "=================================================================================="
                Write-Host ''

                $Branch = Read-Host "Which Branch will $Name be located at?"

                if ($Branch -eq '' -or $Branch -in 1..9) {

                    if ($Branch -eq 1) {

                    $Branch = "Central Branch"

                    }

                    elseif ($Branch -eq 2) {

                    $Branch = "Chartwell Branch"

                    }

                    elseif ($Branch -eq 3) {

                    $Branch = "City Branch"

                    }

                    elseif ($Branch -eq 4) {

                    $Branch = "Dinsdale Branch"

                    }

                    elseif ($Branch -eq 5) {

                    $Branch = "Glenview Branch"

                    }

                elseif ($Branch -eq 6) {

                $Branch = "Head Office"

                }

                elseif ($Branch -eq 7) {

                $Branch = "Hillcrest Branch"

                }

                elseif ($Branch -eq 8) {

                $Branch = "Rototuna Branch"

                }

                elseif ($Branch -eq 9) {

                    Do {

                        $Branch = Read-Host "Which Branch will $Name be located at?"

                    } until ($Branch -ne '')

                }

                    elseif ($Branch -eq '') {

                        $Branch = $null

                    }

                } else {

                    Do {

                        Write-Host ''
                        Write-Warning "You've failed to select a valid choice, please read and try again"
                        write-host ''
                        Write-Host "================== Options ======================================================="
                        Write-Host -ForegroundColor Yellow " Press '1' to select Central Branch"
                        Write-Host -ForegroundColor Yellow " Press '2' to select Chartwell Branch"
                        Write-Host -ForegroundColor Yellow " Press '3' to select City Branch"
                        Write-Host -ForegroundColor Yellow " Press '4' to select Dinsdale Branch"
                        Write-Host -ForegroundColor Yellow " Press '5' to select Glenview Branch"
                        Write-Host -ForegroundColor Yellow " Press '6' to select Head Office"
                        Write-Host -ForegroundColor Yellow " Press '7' to select Hillcrest Branch"
                        Write-Host -ForegroundColor Yellow " Press '8' to select Rototuna Branch"
                        Write-Host -ForegroundColor Yellow " Press '9' to enter a branch that doesn't exist here yet"
                        Write-Host -ForegroundColor Yellow " Press 'Enter' to skip"
                        Write-Host "=================================================================================="
                        Write-Host ''

                        $Branch = Read-Host "Which Branch will $Name be located at?"

                    } until ($Branch -eq '' -or $Branch -in 1..9)

                    if ($Branch -eq 1) {

                    $Branch = "Central Branch"

                    }

                    elseif ($Branch -eq 2) {

                    $Branch = "Chartwell Branch"

                    }

                    elseif ($Branch -eq 3) {

                    $Branch = "City Branch"

                    }

                    elseif ($Branch -eq 4) {

                    $Branch = "Dinsdale Branch"

                    }

                    elseif ($Branch -eq 5) {

                    $Branch = "Glenview Branch"

                    }

                elseif ($Branch -eq 6) {

                $Branch = "Head Office"

                }

                elseif ($Branch -eq 7) {

                $Branch = "Hillcrest Branch"

                }

                elseif ($Branch -eq 8) {

                $Branch = "Rototuna Branch"

                }

                elseif ($Branch -eq 9) {

                    Do {

                        $Branch = Read-Host "Please enter the branch name you would like to use"

                    } until ($Branch -ne '')

                }

                    elseif ($Branch -eq '') {

                        $Branch = $null

                    }

                }
                
        }

        Clear-Host

#### End of branch section
#### Start of Address section
        write-host ''
        $Address = Read-Host "Enter physical address, or press enter to skip"
        write-host ''
        Clear-Host
#### End of address section
#### Start of Mobile number section

        write-host ''
        $Mobile = Read-Host "What is $Name's mobile number?" #Need to check for INT, Need to check for second space?
        write-host ''

        if ($Mobile[3] -ne ' ') {

            $First3 = $Mobile.Substring(0,3)
            $Second3 = $Mobile.Substring(3,3)
            $LastDigits = $Mobile.Substring(6)

            $Mobile = "$First3 $Second3 $LastDigits"

        } 
        Clear-Host
#### End of Mobile section
#### Start of Manager section

        $Manager = Read-Host "Who is their manager?"

        $managers = Get-ADUser -Filter * -Properties Manager | Sort-Object Manager | Select-Object -ExpandProperty Manager | Get-Unique

        $managerlist = @()

        foreach ($item in $managers) {

        $SplitLeft = $item.Split('=')[1]
        $ManagerString = $SplitLeft.Split(',')[0]
        $managerlist += ,$ManagerString

        }

        if (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})) {

            write-host ''
            Write-Warning "User does not exist in Active Directory"
            write-host ''
            Write-Host -ForegroundColor Yellow "================== Options =========================="
            Write-Host -ForegroundColor Yellow " Press '1' to try again"
            Write-Host -ForegroundColor Yellow " Press '2' to leave blank"
            Write-Host -ForegroundColor Yellow "====================================================="
            Write-Host ''

            $managerselection = Read-Host "Please make a selection"

            if ($managerselection -eq 1) {

                $Manager = Read-Host "Who is their manager?"

                if (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})){

                    Do {

                        write-host ''
                        Write-Warning "User does not exist, please try again"
                        $Manager = Read-Host "Who is their manager?"

                    } until (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})

                    if ($Manager -notin $managerlist) {

                        write-host ''
                        Write-Warning "This is not an existing manager. Do you wish to continue?"
                        write-host ''
                        Write-Host "================== Options ======================================================="
                        Write-Host -ForegroundColor Yellow " Press '1' for continue with $Manager as the manager"
                        Write-Host -ForegroundColor Yellow " Press '2' to leave blank"
                        Write-Host "=================================================================================="
                        Write-Host ''

                        $ManagerSelection = Read-Host "Please select an option"

                        if ($managerselection -eq 1) {

                            Continue

                        } elseif ($managerselection -eq 2) {

                            $Manager = $null

                        } else {

                            Do {

                                write-host ''
                                Write-Warning "Not a valid option try again"
                                write-host ''
                                Write-Host "================== Options ======================================================="
                                Write-Host -ForegroundColor Yellow " Press '1' for yes"
                                Write-Host -ForegroundColor Yellow " Press '2' to leave blank"
                                Write-Host "=================================================================================="
                                Write-Host ''

                                $ManagerSelection = Read-Host "Please select an option"

                            } until ($managerselection -eq 1 -or $managerselection -eq 2)

                        }

                    } #

                } Elseif ($Manager -notin $managerlist) {

                    write-host ''
                    Write-Warning "This is not an existing manager. Do you wish to continue?"
                    write-host ''
                    Write-Host "================== Options ======================================================="
                    Write-Host -ForegroundColor Yellow " Press '1' to continue"
                    Write-Host -ForegroundColor Yellow " Press '2' to leave blank"
                    Write-Host -ForegroundColor Yellow " Press '3' to try again"
                    Write-Host "=================================================================================="
                    Write-Host ''

                    $ManagerSelection = Read-Host "Please select an option"

                    if ($ManagerSelection -eq 1) {

                        if (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"})) {

                            Write-Warning "Manager does not exist in AD, leaving blank"

                        }

                    } elseif ($ManagerSelection -eq 2) {

                        $Manager = $null

                    } elseif ($ManagerSelection -eq 3) {

                        Do {

                            $Manager = Read-Host "Who is their manager, please enter the first and last name of an AD user?"

                        } Until (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"})

                        if ($Manager -notin $managerlist) {

                            write-host ''
                            Write-Warning "This is not an existing manager. Do you wish to continue?"
                            write-host ''
                            Write-Host "================== Options ======================================================="
                            Write-Host -ForegroundColor Yellow " Press '1' to continue"
                            Write-Host -ForegroundColor Yellow " Press '2' to leave blank"
                            Write-Host -ForegroundColor Yellow " Press '3' to try again"
                            Write-Host "=================================================================================="
                            Write-Host ''

                            $ManagerSelection = Read-Host "Please select an option"

                            if ($ManagerSelection -eq 1) {

                                if (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"})) {

                                    Write-Warning "Manager does not exist in AD, leaving blank"

                                }

                            } elseif ($ManagerSelection -eq 2) {

                                $Manager = $null

                            } elseif ($ManagerSelection -eq 3) {

                                Do {

                                    write-host ''
                                    $Manager = Read-Host "Who is their manager?"

                                } Until (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"})

                            }

                        }

                    }
  

                } #

            }

        } Elseif ($Manager -notin $managerlist) {

            write-host ''
            Write-Warning "This is not an existing manager. Do you wish to continue?"
            write-host ''
            Write-Host "================== Options ======================================================="
            Write-Host -ForegroundColor Yellow " Press '1' to continue"
            Write-Host -ForegroundColor Yellow " Press '2' to leave blank"
            Write-Host -ForegroundColor Yellow " Press '3' to try again"
            Write-Host "=================================================================================="
            Write-Host ''

            $ManagerSelection = Read-Host "Please select an option"

            if ($ManagerSelection -eq 1) {

                if (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"})) {

                    Write-Warning "Manager does not exist in AD, leaving blank"

                }

            } elseif ($ManagerSelection -eq 2) {

                $Manager = $null

            } elseif ($ManagerSelection -eq 3) {

                Do {

                    write-host ''
                    $Manager = Read-Host "Who is their manager?"

                } Until (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"})

            }

        } elseif ($Manager -eq '') {

            Continue

        }
        Clear-Host
#### End of Manager Section
#### Start of permissions section

        $CopyUser = Read-Host "Please enter the name of the user to base permissions on"

        if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$CopyUser"}) {

            $UserGroups = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$CopyUser"}
            #$Groups = (Get-ADUser $UserGroups -Properties MemberOf).MemberOf

        } else {

            Write-Warning "User does not exist in Tenancy"
            write-host ''
            Write-Host "================== Options ======================================================="
            Write-Host -ForegroundColor Yellow " Press '1' to try again"
            Write-Host -ForegroundColor Yellow " Press '2' to forgo group memberships at this time"
            Write-Host "=================================================================================="
            Write-Host ''

            $CopyUserSelection = Read-Host "Please enter a choice"

            if ($CopyUserSelection -eq 1) {

                $CopyUser = Read-Host "Please enter the name of the user to base permissions on"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$CopyUser"}) {

                    $UserGroups = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$CopyUser"}
                    $Groups = (Get-ADUser $UserGroups -Properties MemberOf).MemberOf

                } else {

                    Do {

                        $CopyUser = Read-Host "Please enter the name of the user to base permissions on"

                    } Until (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$CopyUser"})

                    $UserGroups = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$CopyUser"}
                    $Groups = (Get-ADUser $UserGroups -Properties MemberOf).MemberOf

                }

            } elseif ($CopyUserSelection -eq 2) {

                $Groups = $null

            }

        }

        Clear-Host

#### End of permissions section
#### Start of Password Section

        $Password = Read-Host "Please enter an initial password" -AsSecureString

        if ((-not($Password.Length -ge 8))) {

            Do {

                Write-Warning "Password does not meet the length of 8+ characters"
                $Password = Read-Host "Please enter an initial password" -AsSecureString

            } until ($Password.Length -ge 8)

        }
         
        Clear-Host

#### End of Password section
#### Start of creating email address section and userprincipalname, samaccountname. Groups of user and manager objects 

        $emaildomain       = "@harcourtshamilton.co.nz"
        $emailpartone      = $Name.Split()[0].tostring()[0]
        $emailparttwo      = $Name.Split()[1]
        $EmailAddress      = "$emailpartone.$emailparttwo$emaildomain"
        $UserPrincipalName = "$emailpartone.$emailparttwo$emaildomain"
        $SAMAccountName    = "$emailpartone.$emailparttwo"
        $MemberShips       = (Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$CopyUser"}).memberof
        $ManagerIs           = Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$Manager"}

#### End of creating email address section
#### Setting Name for AD attributes
#### end of setting variables for name ad attributes, captialise display name and title

        $GivenName   = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0])
        $Surname     = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1])
        $DisplayName = (Get-Culture).TextInfo.ToTitleCase($Name)
        $Title       = (Get-Culture).TextInfo.ToTitleCase($Title)

#### Final chance to abort section and list of information gathered

        $object = [PSCustomObject]@{

            Name     = (Get-Culture).TextInfo.ToTitleCase($Name)
            Title    = (Get-Culture).TextInfo.ToTitleCase($Title)
            Branch   = (Get-Culture).TextInfo.ToTitleCase($Branch)
            Mobile   = (Get-Culture).TextInfo.ToTitleCase($Mobile)
            Manager  = (Get-Culture).TextInfo.ToTitleCase($Manager)
            Address  = (Get-Culture).TextInfo.ToTitleCase($Address)
            Email    = $EmailAddress

        }

        Write-Host -ForegroundColor Yellow "A NEW USER IS ABOUT TO BE CREATED WITH THE FOLLOWING INFORMATION"

        $object | Format-Table

        Write-Host -ForegroundColor Yellow "================== Options ======================================="
        Write-Host -ForegroundColor Yellow " Press '1' to create new user"
        Write-Host -ForegroundColor Yellow " Press '2' to abort"
        Write-Host -ForegroundColor Yellow "=================================================================="

        $Selection = Read-Host "Do you wish to continue?"

        if ($Selection -eq 1) {

            $Continue -eq $true | Out-Null

        } 
        
        elseif ($Selection -eq 2) {

            Break

        }

        else {

            Do {
                
                 Write-Warning "Invalid Choice, please read the following and enter an option"
                 Write-Host -ForegroundColor Yellow "================== Options ======================================="
                 Write-Host -ForegroundColor Yellow " Press '1' to create new user"
                 Write-Host -ForegroundColor Yellow " Press '2' to abort"
                 Write-Host -ForegroundColor Yellow "=================================================================="
                 $Selection = Read-Host "Do you wish to continue?"

            } until ($Selection -eq 1 -or $Selection -eq 2)

        }

#### End of final chance section

    } #end of begin block

    PROCESS {

        if ($Continue) {

            Try {

                Write-Verbose "Attempting to create $DisplayName"
                New-ADUser -Path "OU=Swarm Users,OU=Swarm,DC=swarm,DC=com" -Name $DisplayName -Title $Title -Office $Branch -MobilePhone $Mobile -StreetAddress $address -EmailAddress $EmailAddress -AccountPassword $Password -Enabled $true -DisplayName $DisplayName -GivenName $GivenName -Surname $Surname -UserPrincipalName $UserPrincipalName -SamAccountName $SAMAccountName -Manager $ManagerIs -ErrorAction Stop

            } Catch {

                $Continue = $false
                Write-Warning "Unable to create user $DisplayName"
                Write-Warning "$Error[0]"

            }

            if ($Continue) {

                $NewUser = Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$DisplayName"}

                foreach ($MemberShip in $MemberShips) {
                    
                    Try {

                        Write-Verbose "Assigning $DisplayName to $Membership Group"
                        Add-ADGroupMember -Identity $MemberShip -Members $NewUser -ErrorAction Stop

                    } Catch {

                        $Continue = $false
                        Write-Warning "Unable to add $DisplayName to $MemberShip group"
                        Write-Warning "Error[0]"

                    }

                }

            }

        }

        Clear-Host

    }

    END {

        $CompletedUser = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$DisplayName"}
        
        $object = [PSCustomObject]@{

            Name         = $CompletedUser.Name
            EmailAddress = $CompletedUser.UserPrincipalName
            UserName     = $CompletedUser.SamAccountName

        }

        $CompletedName = $CompletedUser.Name

        Write-Host ''
        Write-Host -ForegroundColor Green "$CompletedName's account has been created with the following details:"

        $object | Format-List

        ########### licensing
        Write-Host ''
        Write-Host "Would you like to license the user now?"
        write-host ''
        Write-Host -ForegroundColor Yellow "================ Licensing =============="
        Write-Host -ForegroundColor Yellow "Press '1' to license user."
        Write-Host -ForegroundColor Yellow "Press '2' for no to exit."
        Write-Host -ForegroundColor Yellow "================ Licensing =============="
        Write-Host ''

        $license = Read-Host "Please make your selection"

        if ($license -eq 1){

            Write-Verbose "Connecting to 365"
            
            Try {

                Connect-MsolService -ErrorAction Stop

            } Catch {

                $Continue = $false
                Write-Warning "Unable to connect to 365"
                Write-Warning "$Error[0]"
                
            }
            

            if ($Continue) {

                Write-Verbose "Checking available licenses"
                $LicenseType = Get-MsolAccountSku | Where-Object {$_.AccountSkuID -eq "reseller-account:O365_BUSINESS_PREMIUM"}
                $NumberOfLicenses = $LicenseType.ActiveUnits
                $ConsumedLicenses = $LicenseType.ConsumedUnits

                if (($NumberOfLicenses - $ConsumedLicenses) -ge 1) {

                    Write-Verbose "Licensing User"

                    Try {

                        Set-MsolUserLicense -UserPrincipalName tempben@harcourtshamilton.co.nz -AddLicenses "reseller-account:O365_BUSINESS_PREMIUM"

                    } Catch {

                        Write-Warning "Unable to license user"
                        Write-Warning "$Error[0]"

                    }

                } else {

                    Write-Warning "No spare licenses, please obtain more"

                }

            }

        }

        elseif ($license -eq 2) {

            break

        }

        elseif ($license -ne 1 -or $license -ne 2) {

            Do {

                Write-Host ''
                Write-Warning "Not a valid selection"
                Write-Host ''
                Write-Host "Would you like to license the user now?"
                Write-Host ''
                Write-Host -ForegroundColor Yellow "================ Licensing =============="
                Write-Host -ForegroundColor Yellow "Press '1' to license user."
                Write-Host -ForegroundColor Yellow "Press '2' to exit."
                Write-Host -ForegroundColor Yellow "================ Licensing =============="
                Write-Host ''

                $license = Read-Host "Please make your selection"

            } until ($license -eq 1 -or $license -eq 2)

            if ($license -eq 1){

                Write-Verbose "Checking available licenses"
                $LicenseType = Get-MsolAccountSku | Where-Object {$_.AccountSkuID -eq "reseller-account:O365_BUSINESS_PREMIUM"}
                $NumberOfLicenses = $LicenseType.ActiveUnits
                $ConsumedLicenses = $LicenseType.ConsumedUnits

                if (($NumberOfLicenses - $ConsumedLicenses) -ge 1) {

                    Write-Verbose "Licensing User"

                    Try {

                        Set-MsolUserLicense -UserPrincipalName tempben@harcourtshamilton.co.nz -AddLicenses "reseller-account:O365_BUSINESS_PREMIUM"

                    } Catch {

                        Write-Warning "Unable to license user"
                        Write-Warning "$Error[0]"

                    }

                } else {

                    Write-Warning "No spare licenses, please obtain more"

                }

            }

            elseif ($license -eq 2) {

                break

            }

        }

    } # END

}
 