<#
You’re required to create a function that generates a string of random characters of a given length.
The string must contain a given number of non-alphanumeric characters –
the rest can be numbers or letters (at least one upper 
case, at least one lower case character and at least 1 numeric character).
The length of the string and the number of 
non-alphanumeric characters must be under the users control.
#>

function Get-RandomString {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                   ValueFromPipeline)]
        [int]$Length

    )

    foreach($l in $Length) {

        $Characters = 33..126
        $Random = Get-Random $Characters
        Write-Output [char]$Random

    }

}


