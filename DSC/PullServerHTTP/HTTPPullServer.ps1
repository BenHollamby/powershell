Configuration HTTPPullServer {

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
            EndpointName             = "PSDSCPullServer"
            Port                     = 8080
            PhysicalPath             = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            CertificateThumbPrint    = "AllowUnencryptedTraffic"
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
            Port                     = 9080
            PhysicalPath             = "$env:SystemDrive\inetpub\wwwroot\PSDSCComplianceServer"
            CertificateThumbPrint    = "AllowUnencryptedTraffic"
            State                    = "Started"
            DependsOn                = "[WindowsFeature]DSCServiceFeature","[xDSCWebService]PSDSCPullServer"
            UseSecurityBestPractices = $false
            ConfigureFirewall        = $false

        }
        

    }

}

#generate MOF
HTTPPullServer -OutputPath C:\DSC\HTTP