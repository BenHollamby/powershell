function Write-Menu {

    Write-Host "================== Monarch's Menu ===================="

    Write-Host "1: Press '1' to create a new user."
    Write-Host "2: Press '2' to create a new contact."
    Write-Host "3: Press '3' to edit an existing user."
    Write-Host "4: Press '4' to get details of an existing user."
    Write-Host "5: Press '5' to disable a user."
    Write-Host "5: Press '6' to delete a user."
    Write-Host "q: Press 'q' to quit."
    Write-Host "================== End of Menu ======================="
}

function Invoke-Menu {


    BEGIN {

        Write-Menu

        do {

            $selection = Read-Host "Please make a selection"

            if ($selection -eq "1") {

                Write-Output "You have selected to create a new user."

            }

            elseif ($selection -eq "2") {

                Write-Output "You have selected to create a new contact."

            }

            elseif ($selection -eq "3") {

                Write-Output "You have selected to edit an existing user."

            }

            elseif ($selection -eq "4") {

                Write-Output "You have selected to get details of an existing user."

            }

            elseif ($selection -eq "5") {

                Write-Output "You have selected to disable a user."

            }

            elseif ($selection -eq "6") {

                Write-Output "You have selected to delete a user."

            }

            elseif ($selection -eq "q") {

                Write-Output "You have selected to quit, exiting menu."

            }
        
            else {

                Write-Host "Your selection is invalid. Please try and read the prompt, then try again."

            }

        }  until ($selection -gt 0 -and $selection -le 6 -or $selection -eq 'q')

    }

    PROCESS {

        if ($selection -eq 1) {

            Write-Output "This is selection one"

        }
        
        if ($selection -eq 2) {

            Write-Output "This is selection two"

        }

        if ($selection -eq 3) {

            Write-Output "This is selection  three"

        }

        if ($selection -eq 4) {

            Write-Output "This is selection four"

        }

        if ($selection -eq 5) {

            Write-Output "This is selection five"

        }

        if ($selection -eq 6) {

            Write-Output "This is selection six"

        }

    }

    END {

    }

 }
    
 function New-MonarchUser{

    [cmdletbinding()]

    param (

    )

    BEGIN {
        
        Write-Verbose "Starting BEGIN BLOCK"

        $Continue = $true

        Write-Verbose "Getting new staff member name"

#### Start of getting the name selection

        $Name = Read-Host "What is the full name of the new staff member?"

        if ($Name -eq '') {

        Write-Verbose "Name is empty, warning prompt"
        Write-Warning "Name is empty, do you want to continue?"

        Write-Host "================== Options ===================="
        Write-Host "1: Press '1' to continue"
        Write-Host "2: Press '2' to quit."
        Write-Host "==============================================="

        $NameSelection = Read-Host "Please confirm a selection"

        if ($NameSelection -eq 1) {

            Write-Verbose "User selected $NameSelection"
            $Title = Read-Host "What is their full name?"

            if ($Name -eq '') {

                Do {

                    $Name = Read-Host "What is their full name?"

                } Until ($Name -ne '')

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
            
                    Write-Host "================== Options ===================="
                    Write-Host " Press '1' to confirm this is a new user with the same name as an existing employee."
                    Write-Host " Press '2' to try again."
                    Write-Host " Press 'q' to quit."
                    Write-Host "==============================================="

                    $UserNameSelection = Read-Host "Please make a selection"

                    if ($UserNameSelection -eq 1) {

                        Write-Verbose "User selected $UserNameSelection"
                        $Name = Read-Host "Please enter the full name again with their middle name"

                        if ($Name -eq '') {

                            Do {

                                $Name = Read-Host "Please enter the full name again with their middle name"

                            } Until ($Name -ne '')

                        }


                        elseif ($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)) {

                            Write-Warning "As stated, this user already exists"

                        }


                    }

                    elseif ($UserNameSelection -eq 2) {

                        Write-Verbose "User selected $UserNameSelection"
                        $Name = Read-Host "What is the full name of the new staff member?"

                        if ($Name -eq '') {

                            Do {

                                $Name = Read-Host "Nothing entered, please enter a first name and a last name"

                            } Until ($Name -ne '')

                        }

                        elseif ($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)) {

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

    #### End of Name section        
    #### Start of Title selection

            Write-Host ''

            if ($Continue) {        

                Write-Verbose "Prompting for Job Title"
                $Title = Read-Host "What is their job title?"

                if ($Title -eq '') {

                    Write-Verbose "Title is empty, warning prompt"
                    Write-Warning "Job Title is empty, do you want to continue?"

                    Write-Host "================== Options ===================="
                    Write-Host -ForegroundColor Yellow " Press '1' to enter a title"
                    Write-Host -ForegroundColor Yellow " Press '2' to skip."
                    Write-Host -ForegroundColor Yellow " Press 'q' to abort."
                    Write-Host "==============================================="

                    $TitleSelection = Read-Host "Please confirm a selection"

                    if ($TitleSelection -eq 1) {

                        Write-Verbose "User selected $TitleSelection"
                        $Title = Read-Host "What is their job title?"

                        if ($Title -eq '') {

                            Do {

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
                        #$Continue = $false
                        Break

                    }

                }

                write-host ''

    ##### End of Title selection
    ##### Start of branch selection         
                
                Write-Host "Please select which branch the user is based at"

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

                $Branch = Read-Host "Please select which branch the user is based at"

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

                        $Branch = Read-Host "Please enter the branch name you would like to use"

                    } until ($Branch -ne '')

                }

                    elseif ($Branch -eq '') {

                        $Branch = $null

                    }

                } else {

                    Do {

                        Write-Warning "You've failed to select a valid choice, please read and try again"
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

                        $Branch = Read-Host "Please select which branch the user is based at"

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

        Write-Host ''

        $Address = Read-Host "What is the ADDRESS?"
        $Mobile = Read-Host "What is the MOBILE?"
        $Manager = Read-Host "Who is their manager?"
        $Password = Read-Host "Please enter an initial password"

    }

    PROCESS {

    }

    END {

    }

}

<#
OFFICE PROPERTIES
Get-ADUser -Filter * -Properties Office | Where-Object {$_.Office -ne "Test Account"} | Sort-Object Office | Select-Object -ExpandProperty Office | Get-Unique
Central Branch
Central Office
Chartwell Branch
Chartwell Office
City Office
Dinsdale
Dinsdale Branch
Glenview Branch
Head Office
Hillcrest
Hillcrest Branch
Rototuna Branch

Title | Should also be their description
Get-ADUser -Filter * -Properties "Title" | Sort-Object Title | Select-Object -ExpandProperty Title | Get-Unique 
Branch Manager
Chartwell Branch Manager
Office Administrator

Manager
Get-ADUser -Filter * -Properties "Manager" | Sort-Object Manager | Select-Object -ExpandProperty Manager | Get-Unique
CN=Allan Archer,OU=O365 Users,OU=Monarch_Users,OU=Monarch,DC=monarch,DC=local
CN=Angus Mills,OU=O365 Users,OU=Monarch_Users,OU=Monarch,DC=monarch,DC=local
CN=Brian King,OU=O365 Users,OU=Monarch_Users,OU=Monarch,DC=monarch,DC=local
CN=Daryll Roberts,OU=Disabled Accounts,OU=Monarch,DC=monarch,DC=local
CN=David Forster,OU=O365 Users,OU=Monarch_Users,OU=Monarch,DC=monarch,DC=local
CN=Davinder Singh,OU=O365 Users,OU=Monarch_Users,OU=Monarch,DC=monarch,DC=local
CN=Heidi Puriri,OU=O365 Users,OU=Monarch_Users,OU=Monarch,DC=monarch,DC=local
CN=Paul McNeil,OU=Disabled Accounts,OU=Monarch,DC=monarch,DC=local
CN=Trent Finlay,OU=O365 Users,OU=Monarch_Users,OU=Monarch,DC=monarch,DC=local

Description
get-aduser -Filter * -Properties description | Sort-Object description | Select-Object -ExpandProperty description | get-unique
A user account managed by the system.
Account to login into Boardroom
Account used for connection to Azure AD
Account used for Fortinet Single-Sign On
Account used for LDAP lookups - SSLVPN
Account used for running the ASP.NET worker process (aspnet_wp.exe)
Admin account - added as per Allan's request 3/5/2016
Branch Manager
Branch Manager - Rototuna
Branch Manager (Glenview)
Branch Manager(Rototuna)
Built-in account for administering the computer/domain
Built-in account for anonymous access to Internet Information Services
Built-in account for guest access to the computer/domain
Built-in account for Internet Information Services to start out of process applications
Chartwell Administrator
Chartwell Agent
City Administrator
City Administrator No. 1
City Agent 1
Commercial Agent
Datacom Contractor
Dedicated User to run VMware Converter Standalone server jobs.
Dinsdale Administrator
Dinsdale Agent
Director
Executive Assistant
Exists purely to forward misdirected email.
Glenview Administrator
Glenview Agent
Gold Account
Gold support remote access
Hamilton Agent
Head Office Accountant
Head Office Administrator No. 1
Head Office Administrator No. 2
Head Office Administrator No. 4
Head Office Administrator No. 5
Head Office Administrator No. 6
Head Office Administrator No. 7
Hillcrest Administrator
Hillcrest Agent
Hillcrest Agent 1
Key Distribution Center Service Account
Management Accountant
MoneyWorks NAI Commercial Ledger
Murray Friend
Office Administrator
Office Administrator Hamilton
Office Administrator Hamilton Downstairs
Office Administrator(Disabled on instructions from Heidi)
Photographer
Rototuna Administrator
Rototuna Agent
Service account for Automate monitoring agent
System Administrator A/C
Temp OA account - enabled as needed
This is a vendor's account for the Help and Support Service
Veeam backup service account


Mobile
Should really be in 3 - 3 - 4 format

#>