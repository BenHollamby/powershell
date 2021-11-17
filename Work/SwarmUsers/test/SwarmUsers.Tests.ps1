$ModuleManifestName = 'SwarmUsers.psd1'
$ModuleManifestPath = "C:\Users\Kallor\devops\powershell\Work\SwarmUsers\$ModuleManifestName"

Describe 'Module Manifest Lowers' {
    It 'Passes Lower-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should -Be $true

    }
}

Describe 'Format-SwarmNamePermanent' {

    BeforeAll {

        $Lower = Format-SwarmNamePermanent -Name "iskaral pust"
        $Upper = Format-SwarmNamePermanent -Name "ISKARAL PUST"
        $Pipeline = 'iskaral pust' | Format-SwarmNamePermanent

    }

    It "Spilts the first name and title case" {

        $Lower[0] | Should -Be "Iskaral"
        $Lower[1] | Should -Be "Pust"
        $Lower[2] | Should -Be "Iskaral"
        $Lower[3] | Should -Be "Pust"
        $Lower[4] | Should -Be "Iskaral Pust"
        $Lower[5] | Should -Be "Iskaral Pust"
        $Lower[6] | Should -Be "PustI"
        $Lower[7] | Should -Be "pusti"
        $Lower[8] | Should -Be "Iskaral.Pust@Swarm.com"
        $Lower[9] | Should -Be "Iskaral.Pust@Swarm.com"
        $Lower[10] | Should -Be "Iskaral.Pust@swarm.co.nz"
        $Lower[11] | Should -Be "pusti@swarm.com"
        $Lower[12] | Should -Be "pusti@swarm.co.nz" 
        $Lower[13] | Should -Be "Iskaral.Pust@swarm.co.nz"
        $Lower[14] | Should -Be "pusti"
    }

    It "Spilts the first name, lowercases the name and title cases" {

        $Upper[0] | Should -Be "Iskaral"
        $Upper[1] | Should -Be "Pust"
        $Upper[2] | Should -Be "Iskaral"
        $Upper[3] | Should -Be "Pust"
        $Upper[4] | Should -Be "Iskaral Pust"
        $Upper[5] | Should -Be "Iskaral Pust"
        $Upper[6] | Should -Be "PustI"
        $Upper[7] | Should -Be "pusti"
        $Upper[8] | Should -Be "Iskaral.Pust@Swarm.com"
        $Upper[9] | Should -Be "Iskaral.Pust@Swarm.com"
        $Upper[10] | Should -Be "Iskaral.Pust@swarm.co.nz"
        $Upper[11] | Should -Be "pusti@swarm.com"
        $Upper[12] | Should -Be "pusti@swarm.co.nz" 
        $Upper[13] | Should -Be "Iskaral.Pust@swarm.co.nz"
        $Upper[14] | Should -Be "pusti"

    }

    It "Spilts the first name, lowercases the name and title cases" {

        $Pipeline[0] | Should -Be "Iskaral"
        $Pipeline[1] | Should -Be "Pust"
        $Pipeline[2] | Should -Be "Iskaral"
        $Pipeline[3] | Should -Be "Pust"
        $Pipeline[4] | Should -Be "Iskaral Pust"
        $Pipeline[5] | Should -Be "Iskaral Pust"
        $Pipeline[6] | Should -Be "PustI"
        $Pipeline[7] | Should -Be "pusti"
        $Pipeline[8] | Should -Be "Iskaral.Pust@Swarm.com"
        $Pipeline[9] | Should -Be "Iskaral.Pust@Swarm.com"
        $Pipeline[10] | Should -Be "Iskaral.Pust@swarm.co.nz"
        $Pipeline[11] | Should -Be "pusti@swarm.com"
        $Pipeline[12] | Should -Be "pusti@swarm.co.nz" 
        $Pipeline[13] | Should -Be "Iskaral.Pust@swarm.co.nz"
        $Pipeline[14] | Should -Be "pusti"

    }

}