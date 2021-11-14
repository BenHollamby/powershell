$ModuleManifestName = 'SwarmUsers.psd1'
$ModuleManifestPath = "C:\Users\Kallor\devops\powershell\Work\SwarmUsers\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should -Be $true

    }
}

Describe 'Test-Number' {

    It "times number by itself" {
        Test-Number -Number 3 | Should -Be 9
    }
}