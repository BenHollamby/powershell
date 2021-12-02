#BeNullOrEmpty

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