function Get-SystemInfo {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName

    )

    BEGIN {

    }

    PROCESS {

        foreach ($computer in $ComputerName) {
        
            $OS = Get-WmiObject -Class Win32_OperatingSystem

            $CS = Get-WmiObject -Class Win32_ComputerSystem

            $properties = @{'Model'=$CS.Model;
                            'ComputerName'=$computer;
                            'Manufacturer'=$CS.Manufacturer;
                            'LastBootTime'=$OS.ConvertToDateTime($os.LastBootUpTime);
                            'OSVersion'=$OS.Version
                            }
            $object = New-Object -TypeName PSObject -Property $properties

            Write-Output $object

        }    

    }

    END {

    }

}