function Get-LogicalDisk {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName,

        [string]$ErrorLogs = "C:\Temp\LogicalDiskError.txt",
        [switch]$LogErrors

        )

    BEGIN {

    }

    PROCESS {

        foreach ($computer in $ComputerName) {

        Try {
        
            $continue = $true

            $disk = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $computer -ErrorAction Stop

        } Catch {

            $continue = $false

            Write-Warning "$computer failed to connect"

            if ($LogErrors) {

                $computer | Out-File $ErrorLogs -Append

                Write-Warning "Logged to $ErrorLogs"

            }

        }

        if ($continue) {

            $properties = @{'FreeSpace'=$disk.FreeSpace / 1GB -as [int];
                            'Drive'=$disk.DeviceID;
                            'ComputerName'=$computer;
                            'Size'=$disk.Size / 1GB -as [int]
                            }

            $object = New-Object -TypeName PSObject -Property $properties

            Write-Output $object

        }
        
      }
   }

    END {

    }

}

