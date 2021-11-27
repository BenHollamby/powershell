<#
Lab One
create a function called Get-RemoteSMBShare, it should accept one or more computer names
either on the parameter or from the pipeline and then retrieve a list of current shared folders from each computer. 
The output must include each computers name, the sharename, the description and the path to the share
You'll be using invoke-command (Get-WmiObject -Class Win32_Share as get-smb now supports remoting)

fancy it with:
Computer name should be mandatory
Computer name should accept from pipeline
add alias of hostname for computername
ensure that at least 1 and no more that five computers are allowed each run

fancy it further with:
error handling with an output file and a switch to enable/disable, and some warnings with verbose


#>

function Get-RemoteSMBShare {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory = $True,
                   ValueFromPipeline = $True)]

        [string[]]$ComputerName,

        [string]$ErrorLogs = "C:\Temp\SMBErrors.txt",
        [switch]$LogErrors

    )

    BEGIN {

        Write-Verbose "Querying Computers"

    }

    PROCESS {

        foreach ($Computer in $ComputerName) {

            Try {

                $Continue = $True

                Invoke-Command -ComputerName $Computer -ScriptBlock {

                    $Shares = Get-SmbShare

                } -ErrorAction Stop

            } Catch {

                $Continue = $False

                if ($LogErrors) {

                    $Computer | Out-File $ErrorLogs -Append

                    Write-Warning "Unable to connect to $Computer"

                }

              }

            if ($Continue) {

                $properties = @{'Computer'=$Computer;
                                'ShareName'=$Shares.Name;
                                'Description'=$Shares.Path;
                                'Path'=$Shares.Description
                                }

                $objects = New-Object -TypeName PSObject -Property $properties

                Write-Output $objects

            }

        }

    }

    END {

    }

}
