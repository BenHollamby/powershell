# Implement your module commands in this script.

function Test-Number {

    param(

        [int]$Number

    )

    $results = $Number * $Number

    $results

}


function Test-World {

    $result = Write-Output "hello world"
    $result
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function Test-Number, Test-World

