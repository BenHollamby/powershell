#Mocking Import-CSV to test the Get-Employee function
#below mocks a csv file to import and the second it block asserts that the command was mocked
#and was mocked one times exactly, both times and exactly optional
function Get-Employee {

    Import-Csv -Path C:\Employees.csv

}

describe 'Get-Employee' {

    mock 'Import-Csv' {

        [pscustomobject]@{
        FirstName = 'Adam'
        LastName = 'Bertram'
        UserName = 'abertram'
        
    }

    }

    it 'returns all expected users' {

        $users = Get-Employee
        $users.FirstName | should -Be 'Adam'
        $users.Lastname | should -Be 'Bertram'
        $users.UserName | should -Be 'abertram'

    }

    it 'runs the Import-csv command' {

        Assert-MockCalled -CommandName Import-Csv -Times 1 -Exactly

    }
}

