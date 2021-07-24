function Get-RegistryItem {

    [cmdletbinding()]

    param (

        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True
        )]
        [string]$ComputerName,

        [string]$ErrorLogs = "C:\Temp\pserror.txt"
        [Switch]$LogErrors

    )

    BEGIN {

    }

    PROCESS {

        foreach ($Computer in $ComputerName) {

            Try {

                Invoke-Command -ComputerName $Computer -ScriptBlock {

                    $Keys = Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\'

                } -ErrorAction Stop

            } Catch {

                

            }

        }

    }

    END {

    }
}