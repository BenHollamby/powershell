function New-PFOUser {

    [cmdletbinding()]

    param (

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    HelpMessage = 'Please enter a name in a firstname lastname format, with a space,  in quotes like "lord vader"'
                    )]
        [string]$Name,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [ArgumentCompleter({'Permanent', 'Contractor'})]
        [string]$EmploymentType = "Permanent",

        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
            )]
        [ArgumentCompleter({'"New Zealand"', "Australia"})]
        [string]$Country = "New Zealand",

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Title,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Department,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Office,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Manager,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$WorkPhone,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Mobile,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Permissions

    )

    BEGIN {

        Write-Verbose "Start of BEGIN block by $env:USERNAME"

    } #end of BEGIN block

    PROCESS {

        Write-Verbose "Start of PROCESS block by $env:USERNAME"

        Write-Verbose "Starting foreach loop for Name parameter"

        foreach ($i in $Name) {

            Write-Verbose "Setting format and variables for $i"

            if ($EmploymentType -eq 'Permanent') {

                Write-Verbose "$i has been flagged as a permanent user"

                $GivenName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of full name to titlecase.
                $Surname              = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase.
                $FirstName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of first name to titlecase. Doubled up so the New-ADUser parameters are clearer.
                $LastName             = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase. Doubled up so the New-ADUser parameters are clearer.
                $DisplayName          = (Get-Culture).TextInfo.ToTitleCase($i)            #Sets variable of displayt name to titlecase.
                $LastNameMod          = $LastName.Substring(0,4)                          #grabs the first four characters of last name.
                $FirstNameMod         = $FirstName[0]                                     #grabs the first character of the first name.
                $UserNameMod          = "$LastNameMod$FirstNameMod"                       #joins last four characters of the last name and the first character of the first name in a variable
                $UserName             = (Get-Culture).TextInfo.ToLower($UserNameMod)      #sets the username variable to lowercase
                $EmailAddress         = "$FirstName.$LastName@Swarm.com"                  #creates the email address variable
                $PrimarySMTP          = $EmailAddress                                     #Primary SMTP variable
                $ProxyAddress1        = "$UserName@swarm.com"                             #Proxy address username .com             
                $ProxyAddress2        = "$UserName@swarm.co.nz"                           #proxy address username .co.nz
                $ProxyAddress3        = "$FirstName.$LastName@swarm.co.nz"                #proxy address first name last name .co.nz
                $MailUserIdentity     = $EmailAddress                                     #Variable for -Identity for enable-mailuser
                $ExternalEmailAddress = "$FirstName.$LastName@swarm.onmicrosoft.com"      #variable for externalemailaddress for enable-mailuser
                $RemoteMailbox        = $DisplayName                                      #variable for Enable-RemoteMailbox on prem   
                $RemoteRoutingAddress = "$UserName@swarm.mail.onmicrosoft.com"            #variable for -remoteroutingaddress  

            } #end of if employment type is permanent block

            elseif ($EmploymentType -eq 'Contractor') {

                Write-Verbose "$i has been flagged as a contractor"

                $GivenName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of full name to titlecase.
                $Surname              = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase.
                $FirstName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of first name to titlecase. Doubled up so the New-ADUser parameters are clearer.
                $LastName             = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase. Doubled up so the New-ADUser parameters are clearer.
                $DisplayName          = (Get-Culture).TextInfo.ToTitleCase($i)            #Sets variable of displayt name to titlecase.
                $LastNameMod          = $LastName.Substring(0,4)                          #grabs the first four characters of last name.
                $FirstNameMod         = $FirstName[0]                                     #grabs the first character of the first name.
                $ContractorMod        = "_"                                               #underscore variable for contractor
                $UserNameMod          = "$LastNameMod$ContractorMod$FirstNameMod"         #joins last four characters of the last name and the first character of the first name in a variable
                $UserName             = (Get-Culture).TextInfo.ToLower($UserNameMod)      #sets the username variable to lowercase
                $EmailAddress         = "$FirstName.$LastName@Swarm.com"                  #creates the email address variable
                $PrimarySMTP          = $EmailAddress                                     #Primary SMTP variable
                $ProxyAddress1        = "$UserName@swarm.com"                             #Proxy address username .com             
                $ProxyAddress2        = "$UserName@swarm.co.nz"                           #proxy address username .co.nz
                $ProxyAddress3        = "$FirstName.$LastName@swarm.co.nz"                #proxy address first name last name .co.nz
                $MailUserIdentity     = $EmailAddress                                     #Variable for -Identity for enable-mailuser
                $ExternalEmailAddress = "$FirstName.$LastName@swarm.onmicrosoft.com"      #variable for externalemailaddress for enable-mailuser
                $RemoteMailbox        = $DisplayName                                      #variable for Enable-RemoteMailbox on prem   
                $RemoteRoutingAddress = "$UserName@swarm.mail.onmicrosoft.com"            #variable for -remoteroutingaddress  
                
            } #end of if employment type is contractor block

            $GivenName
            $Surname
            $FirstName
            $LastName
            $DisplayName
            $UserName
            $EmailAddress
            $PrimarySMTP
            $ProxyAddress1
            $ProxyAddress2
            $ProxyAddress3
            $MailUserIdentity
            $ExternalEmailAddress
            $RemoteMailbox
            $RemoteRoutingAddress
            
        } #end of foreach $i in $name block

    } #end of PROCESS block

    END {

    } #end of END block

}