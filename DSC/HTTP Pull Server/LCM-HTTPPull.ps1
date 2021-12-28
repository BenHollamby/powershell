[DSCLocalConfigurationManager()]
Configuration LCM_HTTPPull {

    param (

        [Parameter(Mandatory)]
        [string[]]$ComputerName,

        [Parameter(Mandatory)]
        [string[]]$Guid

    )

    Node $ComputerName {

        Settings {

            AllowModuleOverwrite = $true
            ConfigurationMode    = 'ApplyAndAutoCorrect'
            RefreshMode          = 'Pull'
            ConfigurationID      = $Guid

        }

        ConfigurationRepositoryWeb DSCHTTP {

            ConfigurationNames = @('DSCHTTP')
            ServerURL = 'http://2022APP01.swarm.com:8080/PSDSCPullServer.svc'
            AllowUnsecureConnection = $true

        }

    }

}

$ComputerName = 'localhost'

$Guid = [guid]::NewGuid()

LCM_HTTPPull -ComputerName $ComputerName -Guid $Guid -OutputPath C:\DSC\HTTP