<#
In 2019 the security of your network and data center should be a primary responsibility.
As beneficial as it is to use PowerShell to manage things, the default implementation, 
especially from a remote administration perspective, may be overly broad.
To remotely manage a server with PowerShell requires more administrative access 
 than you may feel comfortable giving.

This is the reason for Just Enough Administration, also known as JEA. 
With this technology you can create secure remoting connections that 
designated non-administrators can use to fulfill a job role. 
The Chairman is a vocal JEA proponent and expects his Iron Scripters 
to be able to understand the PowerShell concepts and commands behind it.

The Challenge
Create a PowerShell module to be used in a JEA configuration with a role capability
 for BITS administration. If you have previous JEA experience you should understand 
 this request. If not, you will need to do some homework.

The JEA solution should only allow the following activities in a remote session:

full Access to the BitsTransfer cmdlets
Access to Get-CimInstance but only for the Win32_Service class and the Bits service
Access to Get-Date
Access to the gsv and gcim aliases
Access to all of the -Service cmdlets, except New-Service, and only for the Bits service
Access to the Bitsadmin.exe command line utility
Access to the netstat.exe command line utility
Access to the filesystem but only to the C:\BitsDownloads folder
You will need a RoleCapabilities folder with a corresponding  .psrc file. Set up the JEA configuration and endpoint on a remote server.

Hints
This will be easier to create in an Active Directory environment
Create an Active Directory group for BITS Administrators and put the account for
 the BITS administrator in this group
You may want to create your own proxy functions.
New to JEA? The Chairman recommends you start at https://docs.microsoft.com/en-us/powershell/jea/overview
#>