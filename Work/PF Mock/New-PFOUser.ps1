function New-PFOUser {

    <#
    .SYNOPSIS
    New-PFOUser will create a new Pxxxx user with all the domain specific attributes and assigns them.
    .DESCRIPTION
    Creates a new user. You can either pass through a CSV file with the bare minimum of properties, such as Name,
    Title, Department, Manager and Permissions, or can extend it to have more attributes.

    Alternatively, you can create a new user with parameters, running the command will force you to enter the
    mandatory parameters.

    For familiar users, you do not need to state the mandatory parameters. Run help New-PFOUser -examples
    for an example. 

    If you use the bare minimum parameters, New-PFOUser will assume that the user is based in NZ, and is a
    permanent employee.

    If you do not specify a password either in a CSV or using the parameter -Password, this command will
    automatically generate a 12 character string that will be listed at the end.

    Run "Help New-PFOUser -Examples" to see different ways you can use this command. 
    .PARAMETER Name
    Takes a name in a "firstname lastname" format, and will put out a GivenName, Surname, FirstName
    LastName, DisplayName, UserName, EmailAddress, PrimarySMTP, and three proxy addresses that are in the
    firstname.lastname@xxxxx.com, firstname.lastname@xxxxx.co.nz, username@xxxxx.com, and username@xxxxx.com.
    It will also capitalise the name if lowercase is used.
    When it sets the username, if the employee is flagged as a permanent employee it will take the first
    four characters of the last name and the first character of the first name and create a username.
    If the user has been flagged as a contractor, there will be an _ placed between the first
    four characters of the last name and the first character of the first name.
    If a last name is less than four characters, sequential characters from the first name will be used
    to pad the username to five characters.
    .PARAMETER Title
    Takes the title and captialises if lowercase was used.
    .PARAMETER Department
    Takes the department and captialises if lowercase was used.
    .PARAMETER Manager
    Takes a name in a "firstname lastname" format, and will check active directory, and if the user
    exists, will set the manager of the new user.
    .PARAMETER Permissions
    Takes a name in a "firstname lastname" format, and will check active directory, and if the user
    exists, will assign all groups that user is a member of and assign them to your new user.
    .PARAMETER Password
    Completely optional. If not used, a 12 character random string will be generated and supplied
    with the new user details.
    .PARAMETER EmploymentType
    Tab complete for Permanent or Contractor. If the parameter is not used, EmploymentType has a default
    value of Permanent. If user is flagged as a contractor, the Organisational Unit will be set as
    <OU PATH>.
    .PARAMETER Country
    Tab complete for Australia or New Zealand. If the parameter is not used, the country parameter
    has a default value of New Zealand, and will set the Organisational Unit to <OU PATH>. If the
    country is set to Australia, the Organisational Unit will be set to <OU PATH>.
    .PARAMETER Office
    Takes the office name and captialises if lowercase was used.
    .PARAMETER WorkPhone
    Takes the WorkPhone number, splits it a more human readable format XX-XXX-XXXX.
    .PARAMETER Mobile
    Takes the Mobile number, splits it a more human readable format XXX-XXX-XXXX.
    .EXAMPLE
    New-SwarmHVVM
    #>

    [cmdletbinding()]

    param (

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    Position = 0,
                    HelpMessage = 'Please enter a name in a firstname lastname format, with a space,  in quotes like "john doe"'
                    )]
        [string]$Name,

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    Position = 1,
                    HelpMessage = 'Title is mandatory'
                    )]
        [string]$Title,

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    Position = 2,
                    HelpMessage = 'Department is a mandatory parameter'
                    )]
        [string]$Department,

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    Position = 3,
                    HelpMessage = 'Manager is mandatory, please enter in a "firstname lastname" format.'
                    )]
        [string]$Manager,

        [Parameter(
                    Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    Position = 4,
                    HelpMessage = 'Please enter user to base permissions on in a "firstname lastname" format'
                    )]
        [string]$Permissions,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    Position = 5
                    )]
        [string]$Password,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    HelpMessage = 'Please use tab complete to select either Permanent or Contractor'
                    )]
        [ArgumentCompleter({'Permanent', 'Contractor'})]
        [ValidateSet("Permanent", "Contractor")]
        [string]$EmploymentType = "Permanent",

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    HelpMessage = 'Please use tab complete to select either "New Zealand" or Australia'
                    )]
        [ArgumentCompleter({'"New Zealand"', "Australia"})]
        [ValidateSet("New Zealand","Australia")]
        [string]$Country = "New Zealand",

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Office,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$WorkPhone,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Mobile
   
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

            if (-not($EmploymentType)) {                                                  #If Employment variable not used 

                $EmploymentType = 'Permanent'                                             #Set as Permanent employee

            }

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
                $Webpage              = "www.swarm.com"                                   #Variable for web page

                #############################################################################
                ##################### Start of WorkPhone Block ##############################
                #############################################################################

                if ($WorkPhone) {

                    $WPhone1              = $Workphone.substring(0,2)                         #Split area code
                    $WPhone2              = $Workphone.substring(2,3)                         #First three digits after area code  
                    $WPhone3              = $Workphone.substring(5)                           #Remaining digits  
                    $WorkPhone            = "$WPhone1 $WPhone2 $WPhone3"                      #Variable in a more human readable form

                }

                #############################################################################
                ##################### End of WorkPhone Block ################################
                #############################################################################

                #############################################################################
                ##################### Start of Mobile Block #################################
                #############################################################################

                if ($Mobile) {

                    $MPhone1              = $Mobile.Substring(0,3)                            #First three digits in mobile
                    $Mobile2              = $Mobile.Substring(3,3)                            #Second three digits in mobile
                    $Mobile3              = $Mobile.Substring(6)                              #Remaining digits
                    $Mobile               = "$MPhone1 $Mobile2 $Mobile3"                      #Mobile in a more readable format

                }

                #############################################################################
                ###################### End of Mobile Block ##################################
                #############################################################################

                #############################################################################
                ####################### Start of Country block ##############################
                #############################################################################

                if (-not($Country)) {

                    $Country = "New Zealand"

                }
                
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
                $Webpage              = "www.swarm.com"                                   #Variable for web page
                
                #############################################################################
                ##################### Start of WorkPhone Block ##############################
                #############################################################################

                if ($WorkPhone) {

                    $WPhone1              = $Workphone.substring(0,2)                         #Split area code
                    $WPhone2              = $Workphone.substring(2,3)                         #First three digits after area code  
                    $WPhone3              = $Workphone.substring(5)                           #Remaining digits  
                    $WorkPhone            = "$WPhone1 $WPhone2 $WPhone3"                      #Variable in a more human readable form

                }

                #############################################################################
                ##################### End of WorkPhone Block ################################
                #############################################################################

                #############################################################################
                ##################### Start of Mobile Block #################################
                #############################################################################

                if ($Mobile) {

                    $MPhone1              = $Mobile.Substring(0,3)                            #First three digits in mobile
                    $Mobile2              = $Mobile.Substring(3,3)                            #Second three digits in mobile
                    $Mobile3              = $Mobile.Substring(6)                              #Remaining digits
                    $Mobile               = "$MPhone1 $Mobile2 $Mobile3"                      #Mobile in a more readable format

                }

                #############################################################################
                ###################### End of Mobile Block ##################################
                #############################################################################

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

                Write-Verbose "Adding proxy addresses to $NewUser"
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

