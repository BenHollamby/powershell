function Get-RunningProcesses {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName,

        [string]$ErrorLogs = "C:\Temp\NotOnline.txt",
        [switch]$LogErrors

    )

    BEGIN {

    }

    PROCESS {

        foreach ($computer in $ComputerName) {

            Try {

                $continue = $true

                $IDS = Get-WmiObject -Class Win32_Service -ComputerName $computer -ErrorAction Stop | Where-Object {$_.State -eq "running"} | Select-Object -ExpandProperty ProcessID -

            } Catch {

                $continue = $false

                if ($LogErrors) {

                    $computer | Out-File $ErrorLogs -Append

                    Write-Warning "$Computer is unreachable at this time, logged to $ErrorLogs"

                }

            }

            if ($continue) {

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

    }

    END {

    }

}