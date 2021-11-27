function Get-RegistryItem {

    [cmdletbinding()]

    param (

        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True
        )]
        [string[]]$ComputerName,

        [string]$ErrorLogs = "C:\Temp\pserror.txt",
        [Switch]$LogErrors

    )

    BEGIN {

    }

    PROCESS {

        foreach ($Computer in $ComputerName) {

            Try {

                $continue = $True

                Invoke-Command -ComputerName $Computer -ScriptBlock {

                    $Keys = Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\'

                } -ErrorAction Stop

            } Catch {

                $continue = $false

                if ($LogErrors) {

                    $Computer | Out-File $ErrorLogs -Append  

                    write-warning "Failed to connect to $Computer, logged to $ErrorLogs"

                }
                  
            }

            if ($continue) {

                $properties = @{'ComputerName'=$Computer;
                                'Protocol'=$Keys.SecureProtocols;
                                'Hive'=$Keys.PSDrive;
                                'Child'=$Keys.PSChildName
                                }

                $object = New-Object -TypeName psobject -Property $properties

                Write-Output $object

            }    

        

        }

    }

    END {

    }
}