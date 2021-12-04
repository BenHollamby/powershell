function Set-Computer {

    param($ComputerName)

    if ($ComputerName -like '*SRV') {
    
        ## Do something because it's a server -example BIGSRV1
        'Did that thing to the server'

    } else {
        
        ## Do something else because it's probably a client -example smallcomp1
        'Did that thing to the client'

    }

}

describe 'Set-Computer' {

    it 'when a server name is passed, it returns the right string' {

        Set-Computer -ComputerName 'MYSRV' | should -Be 'Did that thing to the server'

    }

    it 'when anything other than server name is passed, it returns the right string'{

        Set-Computer -ComputerName 'MYCLIENT' | should -Be 'Did that thing to the client'

    }

}


describe 'TestCases' {

    $testCases = @( 
        
        @{ ComputerName = 'TESTSRV' }
        @{ ComputerName = 'CLIESRV' }
        @{ ComputerName = '1SRV' }
        @{ ComputerName = '1SRV' }

    )

    It 'tests multiple items against an array of hashtables' -TestCases $testCases {

        param($ComputerName)
        Set-Computer -ComputerName $ComputerName | Should -Be 'Did that thing to the server'

    }

}

Describe 'TestName' {

    $testCases = @( 
        
        @{ ComputerName = 'TESTSRV';    TestName = 'SRV at the end' }
        @{ ComputerName = 'CLIENT SRV'; TestName = 'space in the name' }
        @{ ComputerName = '1*SRV';      TestName = 'asterix in the name' }
        @{ ComputerName = '1SRVSRV';    TestName = 'two iterations of SRV in the name' }

    )

    It 'tests multiple items against an array of hashtables that sets the name of the test: <TestName>' -TestCases $testCases {

        param($ComputerName)
        Set-Computer -ComputerName $ComputerName | Should -Be 'Did that thing to the server'

    }

}