<#
System event log size set to 2GB
Create a folder called C:\Data with sub-folders of abbreviated month names
Install the following Windows Features
Windows Server Backup
Telnet Client
FTP Server
Enhanced Storage
Make sure the following Windows Features are NOT installed
SNMP
PowerShell v2
Create a local administrator account for RoyGBiv with a decent password.
Set the PowerShell Execution policy to RemoteSigned
Add 172.16.100.* to TrustedHosts
Install the PSScriptTools module from the PowerShell Gallery
Other than manually initiating the process, this should be a completely hands-free experience.
#>

function Complete-VMBuild {

    [cmdletbinding()]

    param (

    )

    BEGIN {

        Write-Verbose "creating directories"

        New-Item -Name Temp -Path C:\ -ItemType Directory | Out-Null
        New-Item -Name Data -Path C:\ -ItemType Directory | Out-Null

        Write-Verbose "Setting PS policy to remote siged"
        Set-ExecutionPolicy remotesigned

        Write-Verbose "creating folders in C:\Data"
        $monthnames = (New-Object System.Globalization.DateTimeFormatInfo).MonthNames

        $months = $monthnames | Select-Object -SkipLast 1

        foreach ($month in $months) {

            $smonth = $month.Substring(0,3)

            New-Item -Name $smonth -Path C:\Data | Out-Null
    
        }

        Try {

            Write-Verbose "Setting system event log size to 2GB"
            Limit-EventLog -LogName Systems -MaximumSize 2GB -ErrorAction Stop


        } Catch {

            $Error[0] | Out-File -FilePath C:\Temp\Errorlog.txt -Append

        }

    }

    PROCESS {

        Try {

            Write-Verbose "Installing Windows Server Backup"
            Install-WindowsFeature -Name Windows-Server-Backup -IncludeAllSubFeature -IncludeManagementTools | Out-Null -ErrorAction Stop

        } Catch {
            
            Write-Warning "Failed to install Windows Server Backup"
            $Error[0] | Out-File -FilePath C:\Temp\Errorlog.txt -Append

        }

        Try {

            Write-Verbose "Installing Telnet Client"
            Install-WindowsFeature -Name Telnet-Client -IncludeAllSubFeature -IncludeManagementTools | Out-Null -ErrorAction Stop

        } Catch {

            Write-Warning "Failed to install Telnet Client"
            $Error[0] | Out-File -FilePath C:\Temp\Errorlog.txt -Append

        }

        Try {

            Write-Verbose "Installing FTP Server"
            Install-WindowsFeature -Name Web-Ftp-Server -IncludeAllSubFeature -IncludeManagementTools | Out-Null -ErrorAction Stop

        } Catch {

            Write-Warning "Failed to install FTP Server"
            $Error[0] | Out-File -FilePath C:\Temp\Errorlog.txt -Append

        }

        Try {

            Write-Verbose "Installing Enhanced Storage"
            Install-WindowsFeature -Name EnhancedStorage -IncludeAllSubFeature -IncludeManagementTools | Out-Null -ErrorAction Stop

        } Catch {

            Write-Warning "Failed to install Enhanced Storage"
            $Error[0] | Out-File -FilePath C:\Temp\Errorlog.txt -Append

        }

    }

    END {

        if ((Get-WindowsFeature -Name SNMP-Service).InstallState -eq "Installed") {

            Try {
                
                Write-Verbose "Uninstalling SNMP-Service"
                Remove-WindowsFeature -Name SNMP-Service -ErrorAction Stop

            } Catch {

                Write-Warning "Failed to uninstall SNMP Service"
                $Error[0] | Out-File -FilePath C:\Temp\Errorlog.txt -Append

            }

        }

        if ((Get-WindowsFeature -Name SNMP-Service).InstallState -eq "Installed") {

            Try {

                Remove-WindowsFeature -Name PowerShell-V2 -ErrorAction Stop

            } Catch {

                Write-Warning "Failed to uninstall SNMP Service"
                $Error[0] | Out-File -FilePath C:\Temp\Errorlog.txt -Append

            }

        }

        Try {

            New-LocalUser -AccountNeverExpires:$true -Password ( ConvertTo-SecureString -AsPlainText -Force 'Notsecurepassword!') -Name RoyGBiv | Add-LocalGroupMember -Group Administrators -ErrorAction Stop

        } Catch {

            Write-Warning "Failed to create user and add to local admin"
            $Error[0] | Out-File -FilePath C:\Temp\Errorlog.txt -Append

        }

    }

}