function Get-RunningProcesses {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName

    )

    BEGIN {

    }

    PROCESS {

        foreach ($computer in $ComputerName) {

            $IDS = Get-WmiObject -Class Win32_Service | Where-Object {$_.State -eq "running"} | Select-Object -ExpandProperty ProcessID

            foreach ($id in $IDS) {

                $Process = Get-WmiObject -Class Win32_Process | Where-Object {$_.ProcessID -eq "$id"}

                $properties = @{'ComputerName'=$computer;
                                'ThreadCount'=$Process.ThreadCount;
                                'ProcessName'=$Process.ProcessName;
                                'Name'=$Process.Name;
                                'VMSize'=$Process.VM;
                                'PeakPageFile'=$Process.PeakPageFileUsage
                                }
                
                $object = New-Object -TypeName PSObject -Property $properties

                Write-Output $object
                
            }
        }

    }

    END {

    }

}