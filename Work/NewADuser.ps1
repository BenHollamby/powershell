function New-PFOlsenUser {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory)]
        [string]$FirstName,

        
        [Parameter(Mandatory)]
        [string]$LastName,

        
        [Parameter(Mandatory)]
        [Security.securestring]$Password,

        [Parameter(Mandatory)]
        [ArgumentCompleter({(Get-ADUser -Filter * -Properties Department | Where-Object {$_.Department -ne "@ppcentral"} | Sort-Object department | Select-Object -ExpandProperty Department) | Get-Unique | ForEach-Object { "'$_'" }})]
        [string]$Department,

        [Parameter(Mandatory)]
        [ArgumentCompleter({Get-ADUser -Filter * -Properties Office | Where-Object {$_.Office -ne "Test Account"} | Sort-Object Office | Select-Object -ExpandProperty Office | Get-Unique | ForEach-Object { "'$_'" }})]
        [string]$Office,

        [Parameter(Mandatory)]
        [ArgumentCompleter({Get-ADUser -Filter * -Properties "Title" | Sort-Object Title | Select-Object -ExpandProperty Title | Get-Unique | ForEach-Object { "'$_'" }})]
        [string]$JobTitle,
        
        [Parameter(Mandatory)]
        [ArgumentCompleter({Get-ADUser -Filter * -Properties "Manager" | Sort-Object Manager | Select-Object -ExpandProperty Manager | Get-Unique | ForEach-Object {Get-ADUser "$_" | Select-Object -ExpandProperty Name | foreach-object { "'$_'" }}})]
        [string]$Manager,
        
        [Parameter(Mandatory)]
        [string]$CopyFrom 

    )

    BEGIN {

    }

    PROCESS {

    }

    END {

    }

}

