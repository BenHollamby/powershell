function Get-SystemInfo {

    [CmdletBinding()]

    param (
        
        [Parameter(Mandatory = $true)] 
        [string[]]$ComputerName,

        [Parameter(Mandatory = $true)]
        [string]$ErrorLog = "infolog.txt"

    )

    BEGIN {

        Write-Output "Log name is $errorlog"

    }

    PROCESS {

        foreach ($computer in $ComputerName) {
        
            $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer

            $comp = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer

            $bios = Get-WmiObject -Class Win32_BIOS -ComputerName $computer

            $properties = @{'ComputerName'=$computer;
                            'OSVersion'=$os.version;
                            'SPVersion'=$os.servicepackmajorversion;
                            'BIOSSerial'=$bios.serialnumber;
                            'Manufacturer'=$comp.manufacturer;
                            'Model'=$comp.model}

            $object = New-Object -TypeName PSObject -Property $properties

            Write-Output $object

        }

    }

    END {               

    }
}

#Get-SystemInfo -ComputerName localhost, localhost
