function Test-Debuggin {

    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [int]$Number

    )

    BEGIN {

    }

    PROCESS {

        Write-Debug "Number is $Number"
        $R = $Number * $Number
        Write-Debug "$Number x $Number = $R"

    }

    END {

        $R

    }

}

Describe "Test-Debuggin" {

    It "times a number by itself" {

        $Result = Test-Debuggin -Number 3
        $result | Should Be 9

    }

    It "times a number by itself" {

        $Result = Test-Debuggin -Number 6
        $result | Should Be 36

    }

    It "times a number by itself" {

        $Result = Test-Debuggin -Number 0
        $result | Should Be 0

    }


}