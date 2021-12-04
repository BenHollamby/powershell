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
