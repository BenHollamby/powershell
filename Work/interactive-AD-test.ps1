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

        
        $Name = Read-Host "What is the full name of the new staff member?"

        if ($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)) {

            Write-Warning "This user already exists"

            Do {
        
                Write-Host "================== Options ===================="
                Write-Host "1: Press '1' to confirm this is a new user with the same name as an existing employee."
                Write-Host "2: Press '2' to try again."
                Write-Host "q: Press 'q' to quit."
                Write-Host "==============================================="

                $UserNameSelection = Read-Host "Please make a selection"

                if ($UserNameSelection -eq 1) {

                    $Name = Read-Host "Please enter the full name again with their middle name"

                    if ($Name -eq '') {

                        Do {

                            $Name = Read-Host "Please enter the full name again with their middle name"

                        } Until ($Name -ne '')

                    }

                }

                elseif ($UserNameSelection -eq 2) {

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

                    $Continue = $False
                    break

                }

                else {

                    Write-Warning "Not a valid choice, please read the prompt and try again."

                }

            } until (-not($Name -in (Get-ADUser -Filter * -Properties DisplayName | Select-Object -ExpandProperty DisplayName)))

        }

        if ($Continue) {

            $Position = Read-Host "What is their position?"
            $Branch = Read-Host "What is the full name of the new staff member?"
            $Address = Read-Host "What is the full name of the new staff member?"
            $Mobile = Read-Host "What is the full name of the new staff member?"
            $Manager = Read-Host "Who is their manager?"
            $Password = Read-Host "Please enter an initial password"

        }

    }

    PROCESS {

    }

    END {

    }

}

