Configuration HTTPSPullServer {

    #xPSDesiredStateConfiguration module needs to be installed
    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    node 2022APP01 {

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
            EndpointName             = "SecurePSDSCPullServer"
            Port                     = 10443
            PhysicalPath             = "$env:SystemDrive\inetpub\wwwroot\SecurePSDSCPullServer"
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
            EndpointName             = "SecurePSDSCComplianceServer"
            Port                     = 9443
            PhysicalPath             = "$env:SystemDrive\inetpub\wwwroot\SecurePSDSCComplianceServer"
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
Start-DscConfiguration -Path C:\DSC\HTTPS -ComputerName 2022APP01 -Verbose -Wait -Force
