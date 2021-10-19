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
                $Title                = (Get-Culture).TextInfo.ToTitleCase($Title)        #Sets the title variable to titlecase
                $Department           = (Get-Culture).TextInfo.ToTitleCase($Department)   #Sets the department variable to titlecase
                $Office               = (Get-Culture).TextInfo.ToTitleCase($Office)       #Sets the office variable to titlecase
                $Company              = (Get-Culture).TextInfo.ToTitleCase("s company")   #Sets a variable for company name
                $Description          = $Company                                          #Sets a variable for description which is currently the same as company
                
                if ($LastName.Length -eq 3) {                                             #if lastname is less than 3 do

                    $Length = $LastName.Length                                            #Gets length of last name  
                    $LastNameMod = $LastName.Substring(0,$Length)                         #Gets length number of characters 
                    $FirstNameMod = $FirstName.Substring(0,2)                             #Gets first two letters of the firstname
                    
                } #end of lastname equals 3 block
                
                elseif ($lastname.Length -le 2) {                                         #if name less than or equal to two characters  
                
                    $Length = $LastName.Length                                            #Gets length of last name  
                    $LastNameMod = $LastName.Substring(0,$Length)                         #Gets length number of characters
                    $FirstNameMod = $FirstName.Substring(0,3)                             #Gets first three letters of the firstname
                
                } #end of last name less than or equal to block
                
                else {
                
                    $LastNameMod = $LastName.Substring(0,4)                               #grabs the first four characters of last name.   
                    $FirstNameMod = $firstname[0]                                         #grabs the first character of the first name.   
                    
                } #end of catch all block

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
                $WPhone1              = $Workphone.substring(0,2)                         #Split area code
                $WPhone2              = $Workphone.substring(2,3)                         #First three digits after area code  
                $WPhone3              = $Workphone.substring(5)                           #Remaining digits  
                $WorkPhone            = "$WPhone1 $WPhone2 $WPhone3"                      #Variable in a more human readable form
                $MPhone1              = $Mobile.Substring(0,3)                            #First three digits in mobile
                $Mobile2              = $Mobile.Substring(3,3)                            #Second three digits in mobile
                $Mobile3              = $Mobile.Substring(6)                              #Remaining digits
                $Mobile               = "$MPhone1 $Mobile2 $Mobile3"                      #Mobile in a more readable format
                $Webpage              = "www.swarm.com"                                   #Variable for web page

                #### Start of Country block ####

                if ($Country -eq "New Zealand") {

                    Write-Verbose "Country flagged as New Zealand"

                    $OU    = "OU=Swarm Groups,OU=Swarm,DC=swarm,DC=com"                   #Sets OU to x 
                    $C     = "NZ"                                                         #Sets C to NZ 
                    $CO    = "New Zealand"                                                #Sets CO to New Zealand
                    $CCode = "554"                                                        #Sets country code to NZ

                } #end of Country is NZ block

                elseif ($Country -eq "Australia") {

                    Write-Verbose "Country flagged as Australia"

                    $OU    = "OU=Swarm Users,OU=Swarm,DC=swarm,DC=com"                    #Sets OU to x 
                    $C     = "AU"                                                         #Sets C to AU 
                    $CO    = "Australia"                                                  #Sets Country to Australia
                    $CCode = "036"                                                        #Sets country code to Australia 

                } #end of Country is NZ block

                #### End of Country block ####

                #### Start of Manager Block ####

                Write-Verbose " Checking Manager exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}) {                                     #tests if manager exists with that name

                    Write-Verbose "Assigning $Manager to variable"

                    $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}                #If test is true sets ManagerIs variable

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})) {                           #If test is false 

                    Write-Warning "Unable to find $Manager in directory, please set manually after creation" #write warning
                    $ManagerIs = $null                                                                       #Set ManagerIs to null

                }

                #### End of Manager block ####

                #### Start of Permissions block ####

                Write-Verbose "Checking $Permissions exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}) {

                    $GroupMemberShips = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}
                    $Groups = (Get-ADUser $GroupMemberShips -Properties MemberOf).MemberOf

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"})) {

                    Write-Warning "$Permissions does not exist in the directory, please set groups manually"
                    $Groups = $null

                }

                #### End of Permissions block ####

            } #end of if employment type is permanent block

            elseif ($EmploymentType -eq 'Contractor') {

                Write-Verbose "$i has been flagged as a contractor"

                $GivenName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of full name to titlecase.
                $Surname              = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase.
                $FirstName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of first name to titlecase. Doubled up so the New-ADUser parameters are clearer.
                $LastName             = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase. Doubled up so the New-ADUser parameters are clearer.
                $DisplayName          = (Get-Culture).TextInfo.ToTitleCase($i)            #Sets variable of displayt name to titlecase.
                $Title                = (Get-Culture).TextInfo.ToTitleCase($Title)        #Sets the title variable to titlecase
                $Department           = (Get-Culture).TextInfo.ToTitleCase($Department)   #Sets the department variable to titlecase
                $Office               = (Get-Culture).TextInfo.ToTitleCase($Office)       #Sets the office variable to titlecase
                $Company              = (Get-Culture).TextInfo.ToTitleCase("s company")   #Sets a variable for company name
                $Description          = $Company                                          #Sets a variable for description which is currently the same as company
                
                if ($LastName.Length -eq 3) {                                             #if lastname is less than 3 do

                    $Length = $LastName.Length                                            #Gets length of last name  
                    $LastNameMod = $LastName.Substring(0,$Length)                         #Gets length number of characters 
                    $FirstNameMod = $FirstName.Substring(0,2)                             #Gets first two letters of the firstname
                    
                } #end of lastname equals 3 block
                
                elseif ($lastname.Length -le 2) {                                         #if name less than or equal to two characters  
                
                    $Length = $LastName.Length                                            #Gets length of last name  
                    $LastNameMod = $LastName.Substring(0,$Length)                         #Gets length number of characters
                    $FirstNameMod = $FirstName.Substring(0,3)                             #Gets first three letters of the firstname
                
                } #end of last name less than or equal to block
                
                else {
                
                    $LastNameMod = $LastName.Substring(0,4)                               #grabs the first four characters of last name.   
                    $FirstNameMod = $firstname[0]                                         #grabs the first character of the first name.   
                    
                } #end of catch all block

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
                $WPhone1              = $Workphone.substring(0,2)                         #Split area code
                $WPhone2              = $Workphone.substring(2,3)                         #First three digits after area code  
                $WPhone3              = $Workphone.substring(5)                           #Remaining digits  
                $WorkPhone            = "$WPhone1 $WPhone2 $WPhone3"                      #Variable in a more human readable form
                $MPhone1              = $Mobile.Substring(0,3)                            #First three digits in mobile
                $Mobile2              = $Mobile.Substring(3,3)                            #Second three digits in mobile
                $Mobile3              = $Mobile.Substring(6)                              #Remaining digits
                $Mobile               = "$MPhone1 $Mobile2 $Mobile3"                      #Mobile in a more readable format
                $Webpage              = "www.swarm.com"                                   #Variable for web page
                
                #### Country block ####

                if ($Country -eq "New Zealand") {

                    Write-Verbose "Country flagged as New Zealand"

                    $OU    = "OU=Swarm Contractors,OU=Swarm,DC=swarm,DC=com"
                    $C     = "NZ"
                    $CO    = "New Zealand"
                    $CCode = "554"

                }

                elseif ($Country -eq "Australia") {

                    Write-Verbose "Country flagged as Australia"
                    $OU    = "OU=Swarm Contractors,OU=Swarm,DC=swarm,DC=com"
                    $C     = "AU"
                    $CO    = "Australia"
                    $CCode = "036"

                }

                #### End of Country block ###

                #### Manager Block ######

                Write-Verbose " Checking Manager exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}) {                                     #tests if manager exists with that name

                    Write-Verbose "Assigning $Manager to variable"

                    $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}                #If test is true sets ManagerIs variable

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})) {                           #If test is false 

                    Write-Warning "Unable to find $Manager in directory, please set manually after creation" #write warning
                    $ManagerIs = $null                                                                       #Set ManagerIs to null

                }

                #### End of manager block #####
                
                #### Start of Permissions block ####

                Write-Verbose "Checking $Permissions exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}) {

                    $GroupMemberShips = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}
                    $Groups = (Get-ADUser $GroupMemberShips -Properties MemberOf).MemberOf

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"})) {

                    Write-Warning "$Permissions does not exist in the directory, please set groups manually"
                    $Groups = $null

                }

                #### End of Permissions block ####

            } #end of if employment type is contractor block

            #### Random Password block ####

            if (-not($Password)) {

                $Number = 12
                $Count = 0
                $RandomPassword = ""
                while ($Count -ne $Number) {
    
                    foreach($l in $Number) {
    
                        $Count += 1
    
                        $Characters = 33..126
                        $Random = Get-Random $Characters
                        $string = [char]$Random
                        $RandomPassword += $string
    
                    }
    
                }

                $PasswordIs = $RandomPassword

             }

             elseif ($Password) {

                 $PasswordIs = $Password

             }

             $PasswordWillBe = (ConvertTo-SecureString -AsPlainText $PasswordIs -Force)

            #### End of random password block ####

            #### CREATE USER BLOCK #################################################################################

                $Arguments = @{

                    Path = $OU
                    Name = $DisplayName
                    Title = $Title
                    Office = $Office
                    OfficePhone = $WorkPhone
                    Company = $Description
                    Description = $Description
                    Department = $Department
                    MobilePhone = $Mobile
                    EmailAddress = $EmailAddress
                    AccountPassword = $PasswordWillBe
                    Enabled = $true
                    DisplayName = $DisplayName
                    GivenName = $GivenName
                    Surname = $Surname
                    UserPrincipalName = $UserName
                    SamAccountName = $UserName
                    Manage = $ManagerIs
                    ChangePasswordAtLogon = $true
                    ErrorAction = "Stop"

                }

            Try {

                Write-Verbose "Attempting to create $DisplayName"
                New-ADUser @Arguments

            } Catch {

                Write-Warning "Unable to create $DisplayName"

            }
            
            ##### Permissions ####

            $NewUser = Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$DisplayName"}

                foreach ($Group in $Groups) {
                    
                    Try {

                        Write-Verbose "Assigning $NewUser to $Group Group"
                        Add-ADGroupMember -Identity $Group -Members $NewUser -ErrorAction Stop

                    } Catch {

                        Write-Warning "Unable to add $NewUser to $Group group"

                    }

                }

            <#
           
            $PrimarySMTP
            $ProxyAddress1
            $ProxyAddress2
            $ProxyAddress3
            $MailUserIdentity
            $ExternalEmailAddress
            $RemoteMailbox
            $RemoteRoutingAddress
            
            $C
            $CO
            $CCode
           
            $Webpage
           
            #>


        } #end of foreach $i in $name block

    } #end of PROCESS block

    END {

    } #end of END block

}