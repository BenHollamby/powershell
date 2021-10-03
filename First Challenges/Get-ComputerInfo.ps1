function Get-SystemInfo {

    [CmdletBinding()]

    param (
        
        [Parameter(Mandatory = $True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer name or IP Address")]
        [ValidateCount(1,10)]
        [ValidateNotNullorEmpty()] 
        [string[]]$ComputerName,

        [string]$ErrorLog = "C:\Temp\infolog.txt",
        [switch]$LogErrors

    )

    BEGIN {

        Write-Verbose "Error log will be $ErrorLog"

    }

    PROCESS {

        if (Test-Path $ErrorLog) {

            Remove-Item $ErrorLog
        }

        Write-Verbose "Beginning PROCESS block"

        foreach ($computer in $ComputerName) {

            Write-Verbose "Querying $computer"

            Try {
                
                $everything_ok = $true

                $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer -ErrorAction Stop

            } Catch {

                $everything_ok = $false

                Write-Warning "$computer failed to connect"

                if ($LogErrors) {

                    $computer | Out-File $ErrorLog -Append

                    Write-Warning "Logged to $ErrorLog"

                    }

            }

            if ($everything_ok) {
            
                $comp = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer

                $bios = Get-WmiObject -Class Win32_BIOS -ComputerName $computer

                $properties = @{'ComputerName'=$computer;
                                'OSVersion'=$os.version;
                                'SPVersion'=$os.servicepackmajorversion;
                                'BIOSSerial'=$bios.serialnumber;
                                'Manufacturer'=$comp.manufacturer;
                                'Model'=$comp.model}

                Write-Verbose "WMI queries complete"

                $object = New-Object -TypeName PSObject -Property $properties

                Write-Output $object
            
            }

        }

    }

    END {               

    }
}

#Get-SystemInfo -ComputerName localhost, localhost
