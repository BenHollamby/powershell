<#
The Chairman is very taken with the idea of automation and deployment pipelines. 
He is intrigued by all of the options available to IT Pros and his Iron Scripters.
 To that end, he is proposing this warm-up challenge to continue preparing you for 
 the Iron Scripter event at the upcoming PowerShell + DevOps Global Summit.

The Challenge
Using Azure, AWS or any virtualization technology you prefer, i.e. VMware or Hyper-V, 
create a PowerShell solution you can initiate from a PowerShell prompt to create and 
start a virtual machine that meets the following configuration criteria:

Requirements
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

Comments
You don’t have to necessarily create the virtual machine entirely from scratch using PowerShell.
 It is perfectly acceptable to assume you have some sort of baseline server image that you can 
 launch and configure. Using a container may be another option.

Good Automating!
#>

function New-SwarmHVVM {

     <#
    .SYNOPSIS
    New-SwarmHVVM will create a new Hyper-V virtual machine
    .DESCRIPTION
    This creates a brand new virtual machine. This is 0.0.1 version. 
    Need to re-edit so others can use in a more friendly way with more parameters.
    .PARAMETER VMName
    Mandatory
    Names the VM
    .PARAMETER Number
    Optional
    Set to 4 GB. Need to change this to a more friendly GB version
    .PARAMETER Processors
    Optional
    Sets number of processors. Defaults set to 4 processors.
    .EXAMPLE
    New-SwarmHVVM
    #>

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                   ValueFromPipeline 
                   )]
        [string]$VMName,

        [int64]$Memory = 4294967296, #could make this smarter...

        [int]$Processors = 4

    )

    BEGIN {

        New-VM -Name $VMName -MemoryStartupBytes $Memory -Generation 2 | Out-Null
        
        $Path = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\$VMNAME.vhdx"
        New-VHD -Path $Path -SizeBytes 40GB -Dynamic | Out-Null
        Add-VMHardDiskDrive -VMName $VMName -Path $Path
        
        Add-VMDvdDrive -VMName $VMName -Path H:\Server2022.iso
        
        Set-VM -Name $VMName -ProcessorCount $Processors -AutomaticCheckpointsEnabled $false
        
        Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
        
        Connect-VMNetworkAdapter -VMName $VMName -SwitchName "Default Switch"
        
    }

    PROCESS {

        Start-VM -Name $VMName

    }

    END {

    }
    
}