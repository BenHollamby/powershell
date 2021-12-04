<#SHOULD OPERATORS
-BeNullOrEmpty
-Be
-BeExactly
-BeLessThan
-BeLessOrEqual
-BeGreaterThan
-BeLessOrEqual
-BeLike
-BeLikeExactly
-Match
-MatchExactly
-BeTrue
-BeFalse
-Contain
-BeIn
-HaveCount
-BeOfType
-HaveParameter
-FileContentMatch           -Removed doesnt work
-FileContentMatchExactly    -Removed doesnt work
-FileContentMatchMultiline  -Removed doesnt work
-Exist
-Throw
-Because                    -Add at the end of any should to explain why a test failed
#>

$variable = 'somevalue'

Describe 'BeNullOrEmpty' {

    it 'tests variable is not empty' {
        
        $variable | Should -Not -BeNullOrEmpty
    
    }

}

#Be
#the be operater tests for a simple thing like a string or a 
#integer

$string = 'somevalue'

Describe 'Be' {

    it 'tests string' {
        
        $string | Should -Be 'somevalue'
    
    }

}

$integer = 1

Describe 'Be' {

    it 'tests integer' {
        
        $integer | Should -Be 1
    
    }

}

#BeExactly
#is the same as Be but tests for casesensitivity
$string = 'SomeValue'

Describe 'Be' {

    it 'tests case sensitivity of a string' {
        
        $string | Should -BeExactly 'SomeValue'
    
    }

}

#BeLessThan 
$Number = 2

Describe 'BeLessThan' {

    it 'tests Number is less than 4' {
        
        $Number | Should -BeLessThan 4
    
    }

}

#BeLessOrEqual
$Number = 2

Describe 'BeLessOrEqual' {
    
    it 'tests Number is less than or equal to 2 ' {

    $Number | Should -BeLessOrEqual 2

    }

}

#BeGreaterThan
$Number = 2

Describe 'BeGreaterThan' {

    it 'tests Number is greater than 0' {
        
        $Number | Should -BeGreaterThan 0
    
    }

}

#BeGreaterOrEqual
$Number = 2

Describe 'BeGreaterOrEqual' {
    
    it 'tests Number is less than or equal to 2' {

    $Number | Should -BeLessOrEqual 2

    }

}

#BeLike
$variable = 'word'

Describe 'BeLike' {

    it 'tests whether there is a match using wildcards' {

        $variable | Should -BeLike '*o*'

    }

}

#BeLikeExactly
$variable = 'WORD'

Describe 'BeLikeExactly' {

    it 'tests whether there is a match using wildcards, case sensitive version' {

        $variable | Should -BeLikeExactly '*O*'

    }

}

#Match
$string = 'word'

Describe 'Match' {

    It 'matches against a regex expression' {

        $string | Should -Match '^w'

    }

}

#MatchExactly
$string = 'Word'

Describe 'MatchExactly' {

    It 'matches against a case sensitive regex expression' {

        $string | Should -MatchExactly '^W'

    }

}

#BeTrue
$var = $true

Describe 'BeTrue' {

    It 'asserts should be True' {

        $var | Should -BeTrue

    }

}

#BeFalse
$var = $false

Describe 'BeFalse' {

    It 'asserts should be False' {

        $var | Should -BeFalse

    }

}

$collection = @(

    'red'
    'green'
    'yellow'

)

Describe 'Contain' {

    It 'tests if an array contains a particular item' {

        $collection | Should -Contain 'green'

    }

}

Describe 'BeIn' {

    It 'tests if an item is in a particular item' {

        'red' | Should -BeIn $collection

    }

}

Describe 'HaveCount' {

    It 'checks the number of items in an array' {

        $collection | Should -HaveCount 3

    }

}

$collection = @(

    'red'
    'green'
    'yellow'

)

Describe 'Contain' {

    It 'tests if an array contains a particular item' {

        $collection | Should -Contain 'green'

    }

}

Describe 'BeIn' {

    It 'tests if an item is in a particular item' {

        'red' | Should -BeIn $collection

    }

}

Describe 'HaveCount' {

    It 'checks the number of items in an array' {

        $collection | Should -HaveCount 3

    }

}

$varstring = 'hello'
$varint = 1
$varcustom = [pscustomobject]@{Property = 'foo'}

Describe 'BeOfType' {

    It 'tests that object it a type of string' {

        $varstring | Should -BeOfType System.String

    }

    It 'tests that object type is an integer' {

        $varint | Should -BeOfType System.Int32

    }

    It 'tests that object type is a [PSCustomObject]' {

        $varcustom | Should -BeOfType [PSCustomObject]

    }


}


##### HAVE PARAMETER #####
function Get-Thing {

    [CmdletBinding()]

    param(
    
    [Parameter(Mandatory)]
    [string]$MyParam
    
    )

}

Describe 'HaveParameter' {

    It 'tests whether parameter exists, object type, whether mandatory' {

        Get-Command 'Get-Thing' | Should -HaveParameter 'MyParam' -Type 'string' -Mandatory

    }
}

function Get-Thing {

    [CmdletBinding()]

    param(
    
    [Parameter(Mandatory)]
    [string]$MyParam = 'defaultvalue'
    
    )

}

Describe 'Have Parameter' {

    It 'tests whether parameter exists, object type, and default value' {

        Get-Command 'Get-Thing' | Should -HaveParameter 'MyParam' -Type 'string' -DefaultValue 'defaultvalue'

    }
}


Describe 'Throw' {

    It 'Tests hard terminating exception error'{

        
        {Throw "fail"} | Should -Throw 'fail'

    }

    It 'tests exceptions fully qualified error id' {

        {Throw "fail"} | Should -Throw -ErrorId 'fail'

    }

    It 'tests exception type of errror' {

        {throw ([System.NotImplementedException]::new())} | Should -Throw -ExceptionType ([System.NotImplementedException])

    }

}

