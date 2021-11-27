function Get-PFOSQLServer {

    [cmdletbinding()]

    param (

    )

    BEGIN {

        Try {
        
            Write-Verbose "Attempting to import SQLServer module"
            $Proceed = $true
            Import-Module SQLServer -ErrorAction Stop
    
        } Catch {
        
            Write-Verbose "Failed to import SQLServer module"
            $Proceed = $false
            Write-Warning "Module does not exist on this computer, run Install-Module SQLServer -AllowClobber"

        }

        Try {

            Write-Verbose "Attempting to connect to Exchange Server"
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri [] -Authentication Kerberos -ErrorAction Stop

        } Catch {

            $Proceed = $false
            Write-Warning "Unable to connect to Exchange"

        }

    }

    PROCESS {

        if ($Proceed) {

            Write-Verbose "Testing Database location"

            #Replace BikeStores with correct database name and DESKTOP-OML0LMM\SQLEXPRESS with correct servername and name
            $Database = "BikeStores"
            $ServerInstance = "DESKTOP-OML0LMM\SQLEXPRESS"

            #Replace path with correct database location
            if (Test-Path SQLSERVER:\SQL\$ServerInstance\databases\$database) {

                Try {
                    
                    Write-Verbose "Running SQL Query for NZ and assigning to variable $NZVehicleCustodians"
                    $NZVehicleCustodians = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $Database -Query "select * from vwVehicleCustodianNZ" -ErrorAction Stop

                } Catch {

                    $Proceed = $false
                    Write-Warning "Error during Invoke-Sqlcmd check C:\Temp\SQLErrorLogs.txt"

                    $error[0] | Out-File C:\Temp\SQLErrorLogs.txt

                }

                if ($Proceed) {
                
                    Try {
                        
                        Write-Verbose "Running SQL Query for AU and assigning to variable $AUVehicleCustodians"
                        $AUVehicleCustodians = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $Database -Query "select * from vwVehicleCustodianAU" -ErrorAction Stop  

                    } Catch {

                        $Proceed = $false
                        Write-Warning "Error during Invoke-Sqlcmd check C:\Temp\SQLErrorLogs.txt"

                        $error[0] | Out-File C:\Temp\SQLErrorLogs.txt

                    }

                }

                if ($Proceed) {
                    
                    Write-Verbose "Importing Exchange Session"
                    Import-PSSession $Session

                    Write-Verbose "Getting NZ and AU distribution groups and assigning variables"
                    $NZMembers = Get-DistributionGroupMember -Identity "Vehicle Custodians - New Zealand"
                    $AUMembers = Get-DistributionGroupMember -Identity "Vehicle Custodians - Australia"

                    foreach ($NZVehicleCustodian in $NZVehicleCustodians) {
                        
                        Write-Verbose "Checking $NZVehicleCustodian"

                        if ($NZMembers.primarySMTPAddress -contains $NZVehicleCustodian) {

                            Write-Output "$NZVehicleCustodian is in Vehicle Custodians - New Zealand"
    
                        } else {

                            Write-Warning "$NZVehicleCustodian not in Vehicle Custodians - New Zealand: Adding to Distribution Group"
                            
                            # hash out below try and catch block for read only
                            <#
                            Try {

                                Add-DistributionGroupMember -Identity "Vehicle Custodians - New Zealand" -Member $NZVehicleCustodian -ErrorAction Stop

                            } Catch {

                                Write-Warning "Unable to add $NZVehicleCustodian to Vehicle Custodians - New Zealand"

                            } #>

                        } 

                    }

                    foreach ($AUVehicleCustodian in $AUVehicleCustodians) {

                        Write-Verbose "Checking $AUVehicleCustodian"
    
                        if ($AUMembers.primarySMTPAddress -contains $AUVehicleCustodian) {

                            Write-Output "$AUVehicleCustodian is in Vehicle Custodians - Australia"
    
                        } else {

                            Write-Warning "$AUVehicleCustodian not in Vehicle Custodians - Australia: Adding to Distribution Group"
                            
                            # unhash out below try and catch block to write to Exchange
                            <#
                            Try {

                                Add-DistributionGroupMember -Identity "Vehicle Custodians - Australia" -Member $AUVehicleCustodian -ErrorAction Stop

                            } Catch {

                                Write-Warning "Unable to add $AUVehicleCustodian to Vehicle Custodians - Australia"

                            } #>

                        } 

                    }

                }

            } else {

                Write-Warning "Path to database is not true, please check location"

            }

        } Else {

            Write-Warning "problems in if proceed loop"

            }

        }

        END {

        }

}

