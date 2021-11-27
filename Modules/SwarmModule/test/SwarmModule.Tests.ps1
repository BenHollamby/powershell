$ModuleManifestName = 'SwarmModule.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe 'Test-Number Result' {

    It 'Times number by itself' {

        Test-Number -Number 2 | Should be 4

    }

}

Describe 'Test World' {

    It 'prints hello world' {

        Test-World | Should Be "Hello World"

    }

}