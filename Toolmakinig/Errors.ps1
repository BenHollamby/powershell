function Get-Errors {

    [cmdletbinding()]

    param (

    [switch]$LogErrors

    )

    $services = "bits","foo","Winrm"

    foreach ($service in $services) {

        Try {

            Get-Service -Name $service -ErrorAction Stop

        }

        Catch {

            $msg = "$Service does not exist as a service"

            if ($LogErrors) {

                "[$(Get-Date)] $msg" | Out-File C:\Temp\serviceerror.txt
                
            }

            else {

                Write-Warning $msg

            }

        }

    }

}