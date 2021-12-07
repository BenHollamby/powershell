$ModuleManifestName = 'PFOUtil.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe 'Format-SwarmName' {

   It 'Formats Givenames to the correct format' {

        $r = "iskaral pust" | Format-SwarmName 
        $r[4] | Should -BeExactly "Iskaral Pust"

   }

}

$GivenName
    $Surname
    $FirstName
    $LastName 
    $DisplayName
    $Company
    $UserName
    $EmailAddress
    $PrimarySMTP
    $ProxyAddress1
    $ProxyAddress2 
    $ProxyAddress3