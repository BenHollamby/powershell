$Servers = Get-ADComputer -Filter {OperatingSystem -like '*Windows Server*'} | Where-Object {$_.Enabled -eq 'True'} | Select-Object -ExpandProperty Name


    $Yesterday = (Get-Date) - (New-TimeSpan -Day 1)

    $SystemErrorsTable = @()
    $SystemWarningsTable = @()
    $ApplicationErrorsTable = @()
    $ApplicationWarningsTable = @()
    
    
    foreach ($Server in $Servers) {

        $SystemErrors              = Get-WinEvent -LogName System -MaxEvents 500 -ComputerName $Server | Where-Object {$_.LevelDisplayName -eq "Error" -and $_.TimeCreated -ge $Yesterday}
        $SystemWarnings            = Get-WinEvent -LogName System -MaxEvents 500 -ComputerName $Server | Where-Object {$_.LevelDisplayName -eq "Warning" -and $_.TimeCreated -ge $Yesterday}
        $ApplicationErrors         = Get-WinEvent -LogName Application -MaxEvents 500 -ComputerName $Server | Where-Object {$_.LevelDisplayName -eq "Error" -and $_.TimeCreated -ge $Yesterday}
        $ApplicationWarnings       = Get-WinEvent -LogName Application -MaxEvents 500 -ComputerName $Server | Where-Object {$_.LevelDisplayName -eq "Warning" -and $_.TimeCreated -ge $Yesterday}
        

        $SystemErrorCount          = $SystemErrors.count
        $SystemWarningCount        = $SystemWarnings.count
        $ApplicationErrorCount     = $ApplicationErrors.count
        $ApplicationWarningCount   = $ApplicationWarnings.count
        
        
        $SystemUniqueErrors        = $SystemErrors   | Select-Object -Unique
        $SystemUniqueWarnings      = $SystemWarnings | Select-Object -Unique
        $ApplicationUniqueErrors   = $ApplicationErrors   | Select-Object -Unique
        $ApplicationUniqueWarnings = $SystemWarnings | Select-Object -Unique
        
        foreach ($SystemUniqueError in $SystemUniqueErrors) {
        
            $SystemErrorArray      = [PSCustomObject] @{

                Server             = $Server
                Time               = $SystemUniqueError.TimeCreated
                ID                 = $SystemUniqueError.ID
                NumberofEvents     = $SystemErrorCount
                Message            = $SystemUniqueError.Message
                Type               = "Error"


            }

           $SystemErrorsTable      += $SystemErrorArray

        }

        foreach ($SystemUniqueWarning in $SystemUniqueWarnings) {

            $SystemWarningArray = [PSCustomObject] @{

                Server             = $Server
                Time               = $SystemUniqueWarning.TimeCreated
                ID                 = $SystemUniqueWarning.ID
                NumberofEvents     = $SystemWarningCount
                Message            = $SystemUniqueWarning.Message
                Type               = "Warning"


                }

            $SystemWarningsTable   += $SystemWarningArray


        }

        foreach ($ApplicationUniqueError in $ApplicationUniqueErrors) {
        
            $ApplicationErrorArray = [PSCustomObject] @{

                Server             = $Server
                Time               = $ApplicationUniqueError.TimeCreated
                ID                 = $ApplicationUniqueError.ID
                NumberofEvents     = $ApplicationErrorCount
                Message            = $ApplicationUniqueError.Message
                Type               = "Error"


            }

           $ApplicationErrorsTable += $ApplicationErrorArray

        }

        foreach ($ApplicationUniqueWarning in $ApplicationUniqueWarnings) {

            $ApplicationWarningArray = [PSCustomObject] @{

                Server             = $Server
                Time               = $ApplicationUniqueWarning.TimeCreated
                ID                 = $ApplicationUniqueWarning.ID
                NumberofEvents     = $ApplicationWarningCount
                Message            = $ApplicationUniqueWarning.Message
                Type               = "Warning"


                }

            $ApplicationWarningsTable += $ApplicationWarningArray


        }

      

    }

Write-Output ''
Write-Output "SYSTEM ERRORS"

$SystemErrorsTable | Format-Table -AutoSize

Write-Output ''
Write-Output "SYSTEM WARNINGS"

$SystemWarningsTable | Format-Table -AutoSize

Write-Output ''
Write-Output "APPLICATION ERRORS"

$ApplicationErrorsTable | Format-Table -AutoSize

Write-Output ''
Write-Output "APPLICATION WARNINGS"

$ApplicationWarningsTable | Format-Table -AutoSize