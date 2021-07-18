<#You should write a function to convert a Fahrenheit temperate to Celsius 
and a second function to do the opposite. The functions can be very simple
with a single parameter for the value to convert. You don’t need to worry
about passing values from the pipeline, error handling or anything advanced.
The function can simply write the converted value to the pipeline as a result.
If you are feeling a bit more confident, have your function write an object to
the pipeline with the original and converted values.
Even though this is a basic and beginner challenge,
you should still follow PowerShell scripting best practices such as
using a proper verb-noun naming convention. If you feel a bit more skilled,
feel free to include error handling, parameter validation and pipeline input.
#>

function Convert-Temperature { 

    Param
    (
        [parameter(Mandatory=$true,
        ParameterSetName="Celcius")]
        [Int]
        $Celcius,
        
        [parameter(Mandatory=$true,
        ParameterSetName="Fahrenheit")]
        [Int]
        $Fahrenheit

    )

    if ($Celcius -ne "") {

        $convert = ($Celcius*1.8)+32

        Write-host "$Celcius degrees celcius converted to fahrenheit is $convert"

    }elseif ($Fahrenheit -ne "") {

        $convert = ($Fahrenheit-32)/1.8
        
        Write-Host "$Fahrenheit degrees fahrenheit converted to celcius is $convert"

    }
}


