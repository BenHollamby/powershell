function Get-LogicalDisk {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName

        )

    BEGIN {

    }

    PROCESS {

        foreach ($computer in $ComputerName) {
        
        $disk = Get-WmiObject -Class Win32_LogicalDisk

        $properties = @{'FreeSpace'=$disk.FreeSpace / 1GB -as [int];
                        'Drive'=$disk.DeviceID;
                        'ComputerName'=$computer;
                        'Size'=$disk.Size / 1GB -as [int]
                        }

        $object = New-Object -TypeName PSObject -Property $properties

        Write-Output $object
        
        }
    }

    END {

    }

}

