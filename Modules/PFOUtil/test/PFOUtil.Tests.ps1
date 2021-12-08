$ModuleManifestName = 'PFOUtil.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe 'Format-SwarmName Parameters' -Tag 'Format-SwarmName' {

   It 'Tests for mandatory string Name parameter' {

        Get-Command Format-SwarmName | Should -HaveParameter 'Name' -Type String -Mandatory

   }

}

Describe 'Tests output of Format-SwarmName' -Tag 'Format-SwarmName' {

    it 'Tests given name' {

        $Objects = Format-SwarmName -Name 'anomander rake' | Test-FormatName

        $Objects.GivenName     | Should -BeExactly 'Anomander'
        $Objects.Surname       | Should -BeExactly 'Rake'
        $Objects.FirstName     | Should -BeExactly 'Anomander'
        $Objects.LastName      | Should -BeExactly 'Rake'
        $Objects.DisplayName   | Should -BeExactly 'Anomander Rake'
        $Objects.UserName      | Should -BeExactly 'rakea'
        $Objects.EmailAddress  | Should -BeExactly 'Anomander.Rake@swarm.com'
        $Objects.PrimarySMTP   | Should -BeExactly 'Anomander.Rake@swarm.com'
        $Objects.ProxyAddress1 | Should -BeExactly 'rakea@swarm.com'
        $Objects.ProxyAddress2 | Should -BeExactly 'rakea@swarm.co.nz'
        $Objects.ProxyAddress3 | Should -BeExactly 'Anomander.Rake@swarm.co.nz'

    }

}