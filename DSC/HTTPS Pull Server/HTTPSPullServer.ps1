Configuration HTTPSPullServer {

    #xPSDesiredStateConfiguration module needs to be installed
    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    node 2022DSC01 {

        WindowsFeature DSCServiceFeature {

            Ensure = "Present"
            Name   = "DSC-Service"

        }
        
        WindowsFeature IISConsole {

            Ensure = "Present"
            Name   = "Web-Mgmt-Console"

        }

        xDSCWebService PSDSCPullServer {

            Ensure                   = "Present"
            EndpointName             = "PSDSCPullServer"
            Port                     = 10443
            PhysicalPath             = "$env:SystemDrive\inetpub\wwwroot\SSLPSDSCPullServer"
            CertificateThumbPrint    = "8bf1fc91121b4fdf4f184b31bdb4e4d5ad43ae12"
            ModulePath               = "$env:ProgramFiles\WindowsPowerShell\DscService\Modules"
            ConfigurationPath        = "$env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
            State                    = "Started"
            DependsOn                = "[WindowsFeature]DSCServiceFeature"
            UseSecurityBestPractices = $false
            ConfigureFirewall        = $false

        }

        xDscWebService PSDSCComplianceServer {

            Ensure                   = "Present"
            EndpointName             = "PSDSCComplianceServer"
            Port                     = 11443
            PhysicalPath             = "$env:SystemDrive\inetpub\wwwroot\PSDSCComplianceServer"
            CertificateThumbPrint    = "8bf1fc91121b4fdf4f184b31bdb4e4d5ad43ae12"
            State                    = "Started"
            DependsOn                = "[WindowsFeature]DSCServiceFeature","[xDSCWebService]PSDSCPullServer"
            UseSecurityBestPractices = $false
            ConfigureFirewall        = $false

        }
        

    }

}

#generate MOF
HTTPSPullServer -OutputPath C:\DSC\HTTPS

#apply config
Start-DscConfiguration -Path C:\DSC\HTTPS -ComputerName 2022DSC01 -Verbose -Wait -Force
