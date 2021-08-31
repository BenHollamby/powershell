<#
The Chairman is very taken with the idea of automation and deployment pipelines. He is intrigued by all of the options available to IT Pros and his Iron Scripters. To that end, he is proposing this warm-up challenge to continue preparing you for the Iron Scripter event at the upcoming PowerShell + DevOps Global Summit.

The Challenge
Using Azure, AWS or any virtualization technology you prefer, i.e. VMware or Hyper-V, create a PowerShell solution you can initiate from a PowerShell prompt to create and start a virtual machine that meets the following configuration criteria:

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
You don’t have to necessarily create the virtual machine entirely from scratch using PowerShell. It is perfectly acceptable to assume you have some sort of baseline server image that you can launch and configure. Using a container may be another option.

Good Automating!
#>
