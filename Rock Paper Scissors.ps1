function Start-RockPaperScissors {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory = $True)]
        [int]$NumberOfGames

    )

    BEGIN {

        Write-Output "Welcome to Computer vs Computer PowerShell edition!"

    }

    PROCESS {

        $items = 'Rock', 'Paper', 'Scissors'

        $Computer_One_Wins = $null

        $Computer_One_Losses = $null

        $Computer_Two_Wins = $null

        $Computer_Two_Losses = $null

        $Ties = $null
        
        $GamesPlayed = $null

        while ($GamesPlayed -ne $NumberOfGames) {

            $Computer_One_Choice = Get-Random $items

            $Computer_Two_Choice = Get-Random $items

            $GamesPlayed += 1

            if ($Computer_One_Choice -eq $Computer_Two_Choice) {

                $Ties += 1

            } 
            
            elseif ($Computer_One_Choice -eq 'Rock' -and $Computer_Two_Choice -eq 'Scissors') {

                $Computer_One_Wins += 1
                $Computer_Two_Losses +=1

            }

            elseif ($Computer_One_Choice -eq 'Scissors' -and $Computer_Two_Choice -eq 'Rock') {

                $Computer_Two_Wins += 1
                $Computer_One_Losses += 1

            }
            
            elseif ($Computer_One_Choice -eq 'Paper' -and $Computer_Two_Choice -eq 'Rock') {

                $Computer_One_Wins += 1
                $Computer_Two_Losses += 1

            }

            elseif ($Computer_One_Choice -eq 'Paper' -and $Computer_Two_Choice -eq 'Scissors') {

                $Computer_Two_Wins += 1
                $Computer_One_Losses += 1

            }

            elseif ($Computer_One_Choice -eq 'Scissors' -and $Computer_Two_Choice -eq 'Paper') {

                $Computer_One_Wins += 1
                $Computer_Two_Losses += 1

            }

            elseif ($Computer_One_Choice -eq "Rock" -and $Computer_Two_Choice -eq 'Paper') {

                $Computer_Two_Wins += 1
                $Computer_One_Losses += 1

            }


        }
         
        if ($Computer_One_Wins -eq $Computer_Two_Wins) {

            Write-Output "`nThe Result is a tie after $NumberOfGames"

        }

        elseif ($Computer_One_Wins -gt $Computer_Two_Wins) {

            Write-Output "`nComputer One wins!"
            $number = ($Computer_One_Wins - $Computer_Two_Wins)
            Write-Output "Won by $number matches!"

        }

        elseif ($Computer_Two_Wins -gt $Computer_One_Wins) {

            Write-Output "`nComputer Two wins!"
            $numbers = ($Computer_Two_Wins - $Computer_One_Wins)
            Write-Output "Won by $numbers matches!"

        }

    }

    END {
       
        $properties = @{'Number of Games'=$NumberOfGames;
                        'Ties'=$Ties;
                        'Computer_1_Wins'=$Computer_One_Wins;
                        'Computer_1_Losses'=$Computer_One_Losses;
                        'Computer_2_Wins'=$Computer_Two_Wins;
                        'Computer_2_Losses'=$Computer_Two_Losses
                        }

        $object = New-Object -TypeName PSObject -Property $properties

        Write-Output $object

    }
    
}