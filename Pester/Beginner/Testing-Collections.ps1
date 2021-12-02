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