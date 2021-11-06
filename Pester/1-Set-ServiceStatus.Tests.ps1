. .\Pester\1-Set-ServiceStatus.ps1

Describe "Set-ServiceStatus" {

    It "starts BITS" {

        Stop-Service BITS
        $result = Set-ServiceStatus BITS
        $result.status | Should -Be 'Running'

    }

    It "starts BITS, skips FAKE" {

        Stop-Service BITS
        $result = Set-ServiceStatus BITS,FAKE
        $result.status | Should -Be 'Running'

    }

    It "starts 2 services" {

        Stop-Service BITS
        $result = Set-ServiceStatus BITS,TimeBrokerSvc
        $result | Select-Object -First 1 -ExpandProperty Status | Should -Be 'Running'
        $result | Select-Object -Last 1 -ExpandProperty Status | Should -Be 'Running'

    }

}