<#
.SYNOPSIS
Get-ComputerVersion retrieves information from WMI from one or
more computers.

.DESCRIPTION
Get-ComputerVersion uses WMI to retrieve the Win32_ComputerSystem,
Win32_BIOS and Win32_OperatingSystem instances from one or more computers. 
It displays the computers name, Manufacturer, workgroup, Serial number, 
Architecture, OS version, model and the Adminpassword. If the Admin password
is 1 converts to Disabled, 2 Enabled, 3 NA and 4 Unknown.

.PARAMETER computername
The computer name, or names, to query. 

.EXAMPLE
Get-ComputerVersion -ComputerName SERVER-R2
#>
function Get-ComputerVersion {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName,

        [string]$ErrorLogs = "C:\Temp\computerversionerrors.txt",
        [switch]$LogErrors

    )

    BEGIN {

    }

    PROCESS {

        Write-Verbose "Starting PROCESS Block"

        foreach ($computer in $ComputerName) {

            Try {
                
                $keepgoing = $true

                $system = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer -ErrorAction Stop

            } Catch {

                $keepgoing = $false

                Write-Warning "$computer failed to connect"

                if ($LogErrors) {

                    $computer | Out-File $ErrorLogs -Append

                    Write-Warning "Logged to $ErrorLogs"

                    }
                }

            if ($keepgoing) {

                Write-Verbose "Querying BIOS"

                $bios   = Get-WmiObject -Class Win32_BIOS -ComputerName $computer

                Write-Verbose "Querying OS"

                $os     = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer

                $PW     = $null
            
                if ($system.AdminPasswordStatus -eq 1) {
                
                    $PW = "Disabled"
                
                    Write-Verbose "Variable set to $PW"
                                
                    }

                elseif ($system.AdminPasswordStatus -eq 2) {

                    $PW = "Enabled"

                    Write-Verbose "Variable set to $PW"

                    }

                elseif ($system.AdminPasswordStatus -eq 3) {

                    $PW = "NA"

                    Write-Verbose "Variable set to $PW"

                    }

                elseif ($system.AdminPasswordStatus -eq 4) {

                    $PW = "Unknown"

                    Write-Verbose "Variable set to $PW"

                    }
        
                $properties = @{'Computer'=$computer;
                                'WorkGroup'=$system.Domain;
                                'AdminPasswordStatus'=$PW;
                                'Model'=$system.Model;
                                'Manufacturer'=$system.Model;
                                'Serial'=$bios.SerialNumber;
                                'Version'=$os.Version;
                                'Architecture'=$os.OSArchitecture
                                }

                $info = New-Object -TypeName PSObject -Property $properties

                Write-Output $info

                Write-Verbose "Ending script"

            }

        }  

    }


    END {

    }

}