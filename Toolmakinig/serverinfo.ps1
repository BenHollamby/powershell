<#
Team periodically run commands to get the health and performance of a system
The information gathered needs to include the following:
    Computer name .
    Total number of processors (CIM_ComputerSystem)
    Total processor load
    Total Physical Memory (CIM_ComputerSystem)
    % free physical memory (CIM_OperatingSystem)
    % free space on drive c: (CIM_LogicalDisk)
    The computer's uptime (CIM_OperatingSystem)

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
#>

Get-CimInstance -ClassName CIM_ComputerSystem