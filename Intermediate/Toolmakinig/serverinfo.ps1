<#
Team periodically run commands to get the health and performance of a system
The information gathered needs to include the following:
    Computer name .
    Total number of processors (CIM_ComputerSystem)
    Total processor load
    Total Physical Memory (CIM_ComputerSystem)
    % free physical memory (CIM_OperatingSystem)
    % free space on drive c: (get-volume)
    The computer's uptime (CIM_OperatingSystem)
    Time Stamp

Other requirements are:
    Process multiple computers
    take credentials into account
    optional logging mechanism for failures 
    support verbose

##################################################################################
Design

Get-ComputerInformation -ComputerName x
Get-ComputerInformation -ComputerName x -Credential y\x
Get-ComputerInformation -ComputerName x -Credential $cred
Get-ComputerInformation -ComputerName x,x
Get-ComputerInformation -ComputerName x, -ErrorLogPath C:\Somewhere
Get-ComputerInformation -ComputerName x, -ErrorLogPath C:\Somewhere -ErrorAppend
x | Get-ComputerInformation
(Get-AdComputer -Filter *).Name | Get-Information
Get-Content servers.txt | Get-ComputerInformation | Export-CSV state.csv


Persistant connection with New-CIMSession and Remove-CIMSession to run all the queries over one connection.
Detect Errors
#>

function Get-ComputerInformation {

    [cmdletbinding()]

    param(

        [Parameter(Mandatory = $True,
                   ValueFromPipeline = $True,
                   ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias("CN","Machine","Name")]
        [string[]]$ComputerName,

        [string]$ErrorLogPath,

        [switch]$AppendLogs

    )

    BEGIN {

        Write-Verbose "Starting $MyInvocation"

    }

    PROCESS {

        foreach ($Computer in $ComputerName) {

            Write-Verbose "Querying $Computer"

            $params = @{

                ComputerName = $Computer
                ClassName    = "CIM_ComputerSystem"
                ErrorAction  = "Stop"

            }

            Write-Verbose "Querying CIM System"

            Try {
            
                $System = Get-CimInstance @params
                $OK = $True
            }

            Catch {

                $OK = $false
                Write-Warning "Unable to connect to $Computer"

            }

            if ($OK) {

                Write-Verbose "Querying and compiling OS"

                $params.ClassName = "CIM_OperatingSystem"
                $OS = Get-CimInstance @params

                Write-Verbose "Querying Disk"

                $params.ClassName = "CIM_LogicalDisk"
                $Disk = Get-CimInstance @params -Filter "DeviceID='c:'"

                Write-Verbose "Writing Information"

                [PSCustomObject]@{
                    'Computer Name' = $Computer
                    'TimeStamp'     = Get-Date
                    'Processors'    = $System.NumberOfLogicalProcessors
                    'Memory'        = $System.TotalPhysicalMemory
                    'UpTime'        = (Get-Date) - $OS.LastBootUpTime
                    'Install Date'  = $OS.InstallDate
                    'Size (GB)'     = $Disk.Size / 1gb -as [int]

                }

            }

        }

    }

    END {

        Write-Verbose "Ending $MyInvocation"

    }

}