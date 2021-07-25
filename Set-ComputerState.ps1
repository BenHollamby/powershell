<#
Lab Two
write a function called set-computerstate based on the Win32Shutdown method in Win32_OperatingSystem
have it accept one or more computer names
have it provide an -Action parameter which accepts on the values
'LogOff', 'Restart', 'Shutdown', 'PowerOff' (0, 1, 2, 8 respectively)
Provide a -Force switch (which is 4 (above) for force)
Implement -whatif and -confirm with [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact='High')]

Parameters not showing up! Comeback to this tomorrow!

#>

function Set-ComputerState {

    [cmdletbinding(SupportShouldProcess = $True,
                   ConfirmImpact='High')]

    param (

        [Parameter(Mandatory = $True,
                   ValueFromPipeline = $True)]
        [string[]]$ComputerName,

        [ValidateNotNullorEmpty()] 
        [ValidateSet(0, 1, 2, 8)]
        [int]$Action,

        [string]$ForceShutdown,
        [switch]$Force
        
    )

    BEGIN{

    }

    PROCESS {

        foreach ($Computer in $ComputerName) {

            Try {

                if ($Force) {

                    Write-Verbose "Forcing Shutdown"

                    (Get-WmiObject -ComputerName $Computer -Class Win32_operatingsystem).Win32Shutdown(4)

                } 
                
                elseif ($Action -eq 0) {

                    Write-Verbose "Logging off user on $Computer"

                    (Get-WmiObject -ComputerName $Computer -Class Win32_operatingsystem).Win32Shutdown(0)

                }

                elseif ($Action -eq 1) {

                    Write-Verbose "Restarting $Computer"

                    (Get-WmiObject -ComputerName $Computer -Class Win32_operatingsystem).Win32Shutdown(1)

                }

                elseif ($Action -eq 2) {

                    Write-Verbose "Shutting down $Computer"

                    (Get-WmiObject -ComputerName $Computer -Class Win32_operatingsystem).Win32Shutdown(2)
                    
                  
                }

                elseif ($Action -eq 8) {

                    Write-Verbose "Powering off $Computer"

                    (Get-WmiObject -ComputerName $Computer -Class Win32_operatingsystem).Win32Shutdown(8)

                }

                
        }

        Catch {

            Write-Warning "Error!!!"

            }

    }

}

    END {

    }

}