function Get-SwarmDiskSpace {

    <#
    .SYNOPSIS
    Get-SwarmDiskSpace run on its own will query all active servers and write a warning for 
    any disk drive that is under 20%.
    Get-SwarmDiskSpace with the -All switch parameter will get all drives and list a table 
    that you can output to a file.
    .PARAMETER All
    Will list all servers and all drives with Drive Letter, Size in GB, Freespace in GB and 
    Percent Free.
    .EXAMPLE
    Get-SwarmDiskSpace
    WARNING: SWARMDEV F: is less than 20% free with 328 GB remaining from total size of 1750 GB
    WARNING: SWARMSQL H: is less than 20% free with 251 GB remaining from total size of 1736 GB
    .EXAMPLE
    Get-SwarmDiskSpace -All
    Server          Drive SizeGB FreeSpaceGB PercentFree
    ------          ----- ------ ----------- -----------
    SWARMDC02      C:        50          28 57.05 %    
    SWARMDC01      C:        50          30 60.60 %    
    SWARMDEV       C:       120          31 25.63 %    
    SWARMDEV       E:      1090         427 39.16 %    
    SWARMDEV       F:      1750         328 18.75 %    
    SWARMDEV       G:       150          65 43.68 %    
    SWARMAGENT     C:        80          40 49.91 %    
    SWARMMGMT01    C:       111          32 28.92 %    
    SWARMSQLDR     C:        70          29 41.67 %    
    SWARMSQLDR     E:       500         119 23.85 %    
    SWARMSQLDR     F:       100          53 52.55 %    
    SWARMSQLDR     G:       100         100 99.89 %    
    SWARMSQLDR     H:      1736         251 14.47 %    
    #>

    [cmdletbinding()]

    param (

        [switch]$All

    )

    if ($All) {

        $Servers = Get-ADComputer -Filter {OperatingSystem -like '*Windows Server*'} | Where-Object {$_.Enabled -eq 'True'} | Select-Object -ExpandProperty Name

        $objects = foreach ($server in $Servers) {

            $Drives = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server | Where-Object {$_.DriveType -eq 3} -ErrorAction Stop

            foreach ($Drive in $Drives) {

               [PSCustomObject] @{

                    Server      = $server
                    Drive       = $Drive.DeviceID
                    SizeGB      = $Drive.Size / 1GB -as [int]
                    FreeSpaceGB = $Drive.FreeSpace / 1GB -as [int]
                    PercentFree = ($Drive.FreeSpace / $Drive.Size).toString("P")

                } 

            }

        }

        $objects | Format-Table -AutoSize

    }

    else {

        $Servers = Get-ADComputer -Filter {OperatingSystem -like '*Windows Server*'} | Where-Object {$_.Enabled -eq 'True' -and $_.Name -ne "SWARMAPP" -and $_.Name -ne "SWARMsql02"} | Select-Object -ExpandProperty Name

        $objects = foreach ($server in $Servers) {

                $Drives = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server | Where-Object {$_.DriveType -eq 3} -ErrorAction Stop

                foreach ($Drive in $Drives) {

                   [PSCustomObject] @{

                        Server      = $server
                        Drive       = $Drive.DeviceID
                        SizeGB      = $Drive.Size / 1GB -as [int]
                        FreeSpaceGB = $Drive.FreeSpace / 1GB -as [int]
                        PercentFree = ($Drive.FreeSpace / $Drive.Size).toString("P")

                    } 

                }

            }

            foreach ($object in $objects) {

                if ($object.PercentFree -le "20.00 %") {

                    $Name  = $object.Server
                    $Drive = $object.Drive
                    $free  = $object.FreeSpaceGB
                    $size  = $object.SizeGB
                    Write-warning "$Name $Drive is less than 20% free with $free GB remaining from total size of $size GB"

          
                }
            
            }

    }

}

