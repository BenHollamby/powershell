## Dot source my script in to make the function available
. .\Pester\CsvFunction.ps1
describe 'Get-Employee' {

    BeforeEach {

        mock 'Import-CSV' -MockWith {

            [PSCustomObject]@{

                FirstName = 'Adam'
                LastName = 'Bertram'
                UserName = 'abertram'

            }

        }

    }

    it 'returns all expected users' {

        $users = Get-Employee
        $users.FirstName | should -Be 'Adam'
        $users.Lastname | should -Be 'Bertram'
        $users.UserName | should -Be 'abertram'

    }

    it 'Test Import-CSV is run' {

        Get-Employee Should -Invoke -CommandName Import-CSV  #This tests that the command has run in 5.3

    }

 }
