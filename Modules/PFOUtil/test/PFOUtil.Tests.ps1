$ModuleManifestName = 'PFOUtil.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe 'Format-SwarmName' -Tag 'Format-SwarmName' {

   It 'Tests for mandatory string Name parameter' {

        Get-Command Format-SwarmName | Should -HaveParameter 'Name' -Type String -Mandatory

   }

}

