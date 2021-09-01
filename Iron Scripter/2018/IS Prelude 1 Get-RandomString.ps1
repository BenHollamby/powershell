<#
You’re required to create a function that generates a string of random characters of a given Number.
The string must contain a given number of non-alphanumeric characters –
the rest can be numbers or letters (at least one upper 
case, at least one lower case character and at least 1 numeric character).
The Number of the string and the number of 
non-alphanumeric characters must be under the users control.
#>

function Get-RandomString {

<#
.SYNOPSIS
Get-RandomString will generate a random string of normal and special characters

.DESCRIPTION
Get-RandomString takes a mandatory input of Number which specifies how many characters
to generate. With just the Number parameter it will produce a string with normal
and special characters.
With the Specials parameter, users can specify how many special characters are
required in the string

.PARAMETER Number
Mandatory
Accepts value from pipeline
Determines how many characters will be in the string

.PARAMETER Specials
Optional
Determines how many special characters required in the string.

.EXAMPLE
Get-RandomString -Number 10 -Specials 9

<&:)_!@j:?

#>

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                   ValueFromPipeline)]
        [int]$Number,

        [int]$Specials

    )

    $Count = 0

    $SCharacters = ""

    while ($Count -ne $Number) {

        foreach($l in $Number) {

            $Count += 1
            
            $Characters = 33..126
            $Random = Get-Random $Characters
            $string = [char]$Random
            
            $SCharacters += $string

        }

    }

    if($Specials) {

         DO {

                $Count = 0

                $SCharacters = ""

                while ($Count -ne $Number) {

                    foreach($l in $Number) {

                        $Count += 1
            
                        $Characters = 33..126
                        $Random = Get-Random $Characters
                        $string = [char]$Random
            
                        $SCharacters += $string

                    }

                }

                $arrays = $SCharacters.ToCharArray()

                $normal = ''
                $special = ''

                foreach ($array in $arrays) {

                    if ($array -match '[^a-zA-Z0-9]') {

                        $special += $array

                    } else {

                        $normal += $array

                    }

                }

            } Until ($special.Length -ge $Specials)

            $SCharacters

        } else {

            $SCharacters

        }

}