$variable = 'word'

Describe 'BeLike' {

    it 'tests whether there is a match using wildcards' {

        $variable | Should -BeLike '*o*'

    }

}

$variable = 'WORD'

Describe 'BeLikeExactly' {

    it 'tests whether there is a match using wildcards, case sensitive version' {

        $variable | Should -BeLikeExactly '*O*'

    }

}

$string = 'word'

Describe 'Match' {

    It 'matches against a regex expression' {

        $string | Should -Match '^w'

    }

}

$string = 'Word'

Describe 'MatchExactly' {

    It 'matches against a case sensitive regex expression' {

        $string | Should -MatchExactly '^W'

    }

}

$var = $true

Describe 'BeTrue' {

    It 'asserts should be True' {

        $var | Should -BeTrue

    }

}

$var = $false

Describe 'BeFalse' {

    It 'asserts should be False' {

        $var | Should -BeFalse

    }

}
