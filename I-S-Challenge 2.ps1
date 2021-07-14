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

function Convert-Temperature([string]$Celcius, [string]$Fahrenheit) { 

    if ($Celcius -ne "") {

        Write-Host -ForegroundColor Green "Yo what's up $Celcius"

    } elseif ($Fahrenheit -ne "") {
    
    Write-Host -ForegroundColor Yellow "Yo what's up $Fahrenheit"

    }

}

($c*1.8)+32



($f-32)/1.8
