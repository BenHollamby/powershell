function New-PFOUser {

    <#
    .SYNOPSIS
    New-PFOUser will create a new Pxxxx user and formats names into values aligning with the environment
    .DESCRIPTION
    Creates a new user. You can either pass through a CSV file with the bare minimum of properties, such as Name,
    Title, and Department. With the bare minimum parameters, it will assume a NZ user on a permanent contract,
    and create a 12 character random string as the password.
    You may create 
    .PARAMETER VMName
    Mandatory
    Names the VM
    .PARAMETER Number
    Optional
    Set to 4 GB. Need to change this to a more friendly GB version
    .PARAMETER Processors
    Optional
    Sets number of processors. Defaults set to 4 processors.
    .EXAMPLE
    New-SwarmHVVM
    #>

    [cmdletbinding()]

    param (

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    HelpMessage = 'Please enter a name in a firstname lastname format, with a space,  in quotes like "john doe"'
                    )]
        [string]$Name,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    HelpMessage = 'Please use tab complete to select either Permanent or Contractor'
                    )]
        [ArgumentCompleter({'Permanent', 'Contractor'})]
        [string]$EmploymentType = "Permanent",

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    HelpMessage = 'Please use tab complete to select either "New Zealand" or Australia'
                    )]
        [ArgumentCompleter({'"New Zealand"', "Australia"})]
        [string]$Country = "New Zealand",

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    HelpMessage = 'Title is mandatory'
                    )]
        [string]$Title,

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    HelpMessage = 'Title is mandatory'
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
        [string]$Permissions,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Password

    )

    BEGIN {

        Write-Verbose "Start of BEGIN block by $env:USERNAME"

            ##########################################################################################
            ################# Random Password block ##################################################
            ##########################################################################################

            if (-not($Password)) {                                                                     #If password parameter not used
            
                Write-Verbose "-Password parameter not used, generating random 12 character password "                                                    
                                                                
                $Number = 12
                $Count = 0
                $RandomPassword = ""
                while ($Count -ne $Number) {
    
                    foreach($l in $Number) {
    
                        $Count += 1                             
                        $Characters = 33..126
                        $Random = Get-Random $Characters
                        $string = [char]$Random
                        $RandomPassword += $string                                                      #While loop creates 12 character password 
    
                    } #end of foreach block
    
                } #end of while block

                $PasswordIs = $RandomPassword                                                           #Assigns randomly generated password to PasswordIs Variable 

            }

             elseif ($Password) {                                                                       #if password parameter is used

                Write-Verbose "Password parameter used, assigning to Password Is variable"

                 $PasswordIs = $Password                                                                #Assigns password to PasswordIs Variable

             }

             $PasswordWillBe = (ConvertTo-SecureString -AsPlainText $PasswordIs -Force)                 #Converts password to secure string

            #############################################################################
            ###################### End of random password block #########################
            #############################################################################

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
                $WPhone1              = $Workphone.substring(0,2)                         #Split area code
                $WPhone2              = $Workphone.substring(2,3)                         #First three digits after area code  
                $WPhone3              = $Workphone.substring(5)                           #Remaining digits  
                $WorkPhone            = "$WPhone1 $WPhone2 $WPhone3"                      #Variable in a more human readable form
                $MPhone1              = $Mobile.Substring(0,3)                            #First three digits in mobile
                $Mobile2              = $Mobile.Substring(3,3)                            #Second three digits in mobile
                $Mobile3              = $Mobile.Substring(6)                              #Remaining digits
                $Mobile               = "$MPhone1 $Mobile2 $Mobile3"                      #Mobile in a more readable format
                $Webpage              = "www.swarm.com"                                   #Variable for web page

                #############################################################################
                ####################### Start of Country block ##############################
                #############################################################################

                if ($Country -eq "New Zealand") {

                    Write-Verbose "Country flagged as New Zealand"

                    $OU                = "OU=Swarm Groups,OU=Swarm,DC=swarm,DC=com"       #Sets OU to x 
                    $C                 = "NZ"                                             #Sets C to NZ 
                    $CO                = "New Zealand"                                    #Sets CO to New Zealand
                    $CCode             = "554"                                            #Sets country code to NZ
                    $PreferredLanguage = "en-NZ"                                          #Sets preferred language to en-NZ             

                } #end of Country is NZ block

                elseif ($Country -eq "Australia") {

                    Write-Verbose "Country flagged as Australia"

                    $OU                = "OU=Swarm Users,OU=Swarm,DC=swarm,DC=com"        #Sets OU to x 
                    $C                 = "AU"                                             #Sets C to AU 
                    $CO                = "Australia"                                      #Sets Country to Australia
                    $CCode             = "036"                                            #Sets country code to Australia
                    $PreferredLanguage = "en-AU"                                          #Sets preferred language to en-AU 

                } #end of Country is NZ block

                #############################################################################
                ######################## End of Country block ###############################
                #############################################################################

                #############################################################################
                ####################### Start of Manager Block ##############################
                #############################################################################

                Write-Verbose " Checking Manager exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}) {                          #tests if manager exists with that name

                    Write-Verbose "Assigning $Manager to variable"
                    $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}                #Set Manager to ManagerIs variable if true

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})) {                #If Manager does not exist 

                    Write-Warning "Unable to find $Manager in directory, please set manually after creation" #write warning
                    $ManagerIs = $null                                                                       #Set ManagerIs to null

                }

                #############################################################################
                ######################## End of Manager block ###############################
                #############################################################################

                #############################################################################
                ##################### Start of Permissions block ############################
                #############################################################################

                Write-Verbose "Checking $Permissions exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}) {                       #If user exists in directory

                    $GroupMemberShips = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}      #Get User and assign to variable
                    $Groups = (Get-ADUser $GroupMemberShips -Properties MemberOf).MemberOf                    #Assign all groups to a variable    

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"})) {             #If user does not exist in directory

                    Write-Warning "$Permissions does not exist in the directory, please set groups manually"
                    $Groups = $null                                                                           #Sets Groups variable to null

                }

                #############################################################################
                ###################### End of Permissions block #############################
                #############################################################################

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
                $WPhone1              = $Workphone.substring(0,2)                         #Split area code
                $WPhone2              = $Workphone.substring(2,3)                         #First three digits after area code  
                $WPhone3              = $Workphone.substring(5)                           #Remaining digits  
                $WorkPhone            = "$WPhone1 $WPhone2 $WPhone3"                      #Variable in a more human readable form
                $MPhone1              = $Mobile.Substring(0,3)                            #First three digits in mobile
                $Mobile2              = $Mobile.Substring(3,3)                            #Second three digits in mobile
                $Mobile3              = $Mobile.Substring(6)                              #Remaining digits
                $Mobile               = "$MPhone1 $Mobile2 $Mobile3"                      #Mobile in a more readable format
                $Webpage              = "www.swarm.com"                                   #Variable for web page
                
                #############################################################################
                ####################### Start of Country block ##############################
                #############################################################################

                if ($Country -eq "New Zealand") {                                         #If country NZ 

                    Write-Verbose "Country flagged as New Zealand"

                    $OU    = "OU=Swarm Contractors,OU=Swarm,DC=swarm,DC=com"              #Sets OU to NZ OU
                    $C     = "NZ"                                                         #Sets Country to NZ
                    $CO    = "New Zealand"                                                #Sets Country to New Zealand
                    $CCode = "554"                                                        #Sets Country Code to NZ
                    $PreferredLanguage = "en-NZ"                                          #Sets preferred language to en-NZ

                }

                elseif ($Country -eq "Australia") {                                       #If country Australia  

                    Write-Verbose "Country flagged as Australia"                          
                    $OU    = "OU=Swarm Contractors,OU=Swarm,DC=swarm,DC=com"              #Sets OU to Australian Users
                    $C     = "AU"                                                         #Sets Country to AU
                    $CO    = "Australia"                                                  #Sets Country to Australia  
                    $CCode = "036"                                                        #Sets Country Code to Australia  
                    $PreferredLanguage = "en-AU"                                          #Sets preferred language to en-AU

                }

                #############################################################################
                ####################### End of Country block ################################
                #############################################################################

                #############################################################################
                ####################### Start of Manager Block ##############################
                #############################################################################

                Write-Verbose " Checking Manager exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}) {                          #If manager exists in directory

                    Write-Verbose "Assigning $Manager to variable"

                    $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}                #If Manager exists, assigned to ManagerIs variable

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})) {                #If Manager does not exist

                    Write-Warning "Unable to find $Manager in directory, please set manually after creation" #write warning
                    $ManagerIs = $null                                                                       #Set ManagerIs to null

                }

                #############################################################################
                ######################## End of Manager Block ###############################
                #############################################################################
                
                #############################################################################
                ##################### Start of Permissions block ############################
                #############################################################################

                Write-Verbose "Checking $Permissions exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}) {

                    $GroupMemberShips = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}
                    $Groups = (Get-ADUser $GroupMemberShips -Properties MemberOf).MemberOf

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"})) {

                    Write-Warning "$Permissions does not exist in the directory, please set groups manually"
                    $Groups = $null

                }

                #############################################################################
                ##################### End of Permissions block ##############################
                #############################################################################

            } #end of if employment type is contractor block


            #############################################################################
            ######################## CREATE USER BLOCK ##################################
            #############################################################################

                $Arguments = @{                                                 #Sets all the parameter arguments for New-ADUser

                    Path                  = $OU
                    Name                  = $DisplayName
                    Title                 = $Title
                    Office                = $Office
                    OfficePhone           = $WorkPhone
                    Company               = $Description
                    Description           = $Description
                    Department            = $Department
                    Country               = $C
                    MobilePhone           = $Mobile
                    EmailAddress          = $EmailAddress
                    AccountPassword       = $PasswordWillBe
                    Enabled               = $true
                    DisplayName           = $DisplayName
                    GivenName             = $GivenName
                    Surname               = $Surname
                    UserPrincipalName     = $ProxyAddress1
                    SamAccountName        = $UserName
                    Manage                = $ManagerIs
                    ChangePasswordAtLogon = $true
                    ErrorAction           = "Stop"

                }

            Try {

                Write-Verbose "Attempting to create $DisplayName"
                New-ADUser @Arguments                                                            #Create new user with arguments splatt

            } Catch {

                Write-Warning "Unable to create $DisplayName"

            }

            #############################################################################
            ###################### END OF CREATE USER BLOCK #############################
            #############################################################################
            
            #############################################################################
            ######################### PERMISSIONS BLOCK #################################
            #############################################################################

            $NewUser = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$DisplayName"}          #Assign newly created user to NewUser Variable 
            
            Write-Verbose "$NewUser assigned to NewUser variable"

                foreach ($Group in $Groups) {                                                    #Iterating through each user group

                    Write-Verbose "Grabbing $Group"
                    
                    Try {

                        Write-Verbose "Assigning $NewUser to $Group Group"
                        Add-ADGroupMember -Identity $Group -Members $NewUser -ErrorAction Stop   #Assigning group to user

                    } Catch {

                        Write-Warning "Unable to add $NewUser to $Group group"

                    }

                }

            #############################################################################
            ################### END OF PERMISSIONS BLOCK ################################
            #############################################################################

            #############################################################################
            ################### CONFIGURE ATTRIBUTES ####################################
            #############################################################################

            Try {

                Write-Verbose "Setting ADObjects for $NewUser"
                Set-ADObject -Identity $NewUser.DistinguishedName `
                    -Replace @{preferredLanguage = "$PreferredLanguage";                        #Sets Preferred Language
                                              co = $CO;                                         #Sets Country
                                     countryCode = $CCode;                                      #Sets Country Code
                                     wWWHomePage = $Webpage                                     #Sets Webpage
                               } -ErrorAction Stop
                                                                                                
            } Catch {

                Write-Warning "Unable to set language, country, country code, and webpage, please set manually."

            }

            #############################################################################
            #################### END OF CONFIGURE ATTRIBUTES ############################
            #############################################################################

            #############################################################################
            #################### CONFIGURE PROXY ADDRESSES ##############################
            #############################################################################

            Try {

                Set-ADUser -Identity $NewUser.DistinguishedName -add @{ProxyAddresses = "SMTP:$PrimarySMTP,smtp:$ProxyAddress1,smtp:$ProxyAddress2,smtp:$ProxyAddress3" -split ","} -ErrorAction Stop  #Sets Proxy addresses                                           

            } Catch {

                Write-Warning "Unable to set proxy addresses"

            }

            #############################################################################
            ################# END OF CONFIGURE PROXY ADDRESSES ##########################
            #############################################################################

            $UserObjects = @()

            $UserObjects += [PSCustomObject] @{                                          #Creates a custom Powershell object into array for outputting new user information like username password etc

                            Name = $NewUser.Name                                         #Name of user
                            Email = (Get-ADUser $NewUser -Properties *).EmailAddress     #Email address of user
                            Username = $NewUser.SamAccountName                           #Username 
                            Password = $PasswordIs                                       #Password

                           }

        } #end of foreach $i in $name block

        

        $UserObjects | Select-Object Name, Email, Username, Password                                                                    #Outputs Name, Email Address, UserName and Password
        
    } #end of PROCESS block

    END {

    } #end of END block

}

