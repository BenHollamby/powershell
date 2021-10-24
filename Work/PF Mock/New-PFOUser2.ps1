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

    If you have a user with the same name as a user, you can supply the -Suffix parameter followed by the
    -SuffixValue parameter with one or two characters to append the name.

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
    Based on "copy user" or base permissions on a user. Takes a name in a "firstname lastname" format,
    and will check active directory, and if the user exists, will assign all groups that user 
    is a member of and assign them to your new user.
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
    .PARAMETER Suffix
    Switch for creating a user with the same name as an existing user.
    .PARAMETER SuffixValue
    Takes one or two character string and is used to append the name, username, email address
    to create a user with the same name.

    .EXAMPLE
    New-PFOUser
    Description
    Just running New-PFOUser will then prompt you for the Name, then the title, then the 
    department, then a manager, then permissions. Will assume all defaults as stated in 
    description above.
    New-PFOUser
    cmdlet New-PFOUser at command pipeline position 1
    Supply values for the following parameters:
    (Type !? for Help.)
    Name: caladan brood
    Title: high fist
    Department: forest management
    Manager: drone one
    Permissions: drone two
    Name          Email                   Username Password    
    ----          -----                   -------- --------    
    Caladan Brood Caladan.Brood@Swarm.com brooc    <password>
    .EXAMPLE
    New-PFOUser -Name "iskaral pust" -Title priest -Department clergy -Manager "drone one" -Permissions "drone two" -EmploymentType Permanent -Country 'New Zealand' -Office rotorua -WorkPhone 078885666 -Mobile 0272587116 -Password <password>
    Description
    An example of using all the parameters. Capitals are not needed. 
    Tab complete on EmploymentType and Country. 
    Output is Name, Email, Username and Password.
    Name         Email                  Username Password
    ----         -----                  -------- --------
    Iskaral Pust Iskaral.Pust@Swarm.com pusti    
    .EXAMPLE
    New-PFOUser -Name "iskaral pust" -Title priest -Department clergy -Manager "drone one" -Permissions "drone two"
    Description
    This example uses only the mandatory parameters. As stated in help, if you do not use the 
    EmploymentType parameter it will assume a default of Permanent. If you do not use the Country parameter it
    will assume a default of New Zealand. And if you do not use the Password parameter, it will automatically
    generate a random 12 character string.
    Name         Email                  Username Password    
    ----         -----                  -------- --------    
    Iskaral Pust Iskaral.Pust@Swarm.com pusti    
    .EXAMPLE
    New-PFOUser "iskaral pust" priest clergy "drone one" "drone two"
    Description
    For those that become too familiar with this particular user creation method. The mandatory
    parameters are positional allowing you to forgo typing in the parameters. They must be in order
    of Name, Title, Department, Manager, and Permissions
    Name         Email                  Username Password    
    ----         -----                  -------- --------    
    Iskaral Pust Iskaral.Pust@Swarm.com pusti    
    .EXAMPLE
    Import-Csv C:\Temp\pfotest.csv | New-PFOUser
    Description
    You have the option to pipe in users from a CSV. So long as that CSV's headers match the mandatory
    parameters. You can also add in the optional parameters.
    This will create as many users as needed. In the output below, you can see that some users have
    been flagged as contracters. Hidden from the output, users were based in both countries and have
    been created in their respective Organisational Units.
    Name         Email                  Username Password    
    ----         -----                  -------- --------    
    Kallor One   Kallor.One@Swarm.com   oneka    
    Kallor Two   Kallor.Two@Swarm.com   two_ka   
    Kallor Three Kallor.Three@Swarm.com thre_k   
    Kallor Four  Kallor.Four@Swarm.com  fourk    
    Crayon Ask   Crayon.Ask@Swarm.com   askcr    
    .EXAMPLE
    Import-Csv C:\Temp\pfotest.csv | New-PFOUser -Password <password>
    Description
    If you have a CSV and want to set a particular password you can also use the command like 
    the above example.
    Name         Email                  Username Password              
    ----         -----                  -------- --------              
    Kallor One   Kallor.One@Swarm.com   oneka    <password>
    Kallor Two   Kallor.Two@Swarm.com   two_ka   <password>
    Kallor Three Kallor.Three@Swarm.com thre_k   <password>
    Kallor Four  Kallor.Four@Swarm.com  fourk    <password>
    Crayon Ask   Crayon.Ask@Swarm.com   askcr    <password>
    .EXAMPLE
    New-PFOUser -Name "iskaral pust" -Title priest -Department clergy -Manager "drone one" -Permissions "drone two" -EmploymentType Permanent -Country 'New Zealand' -Office rotorua -WorkPhone 078885666 -Mobile 0272587116 -Password <password> -Suffix -SuffixValue M
    Description
    If you have a user fail because a user with the same name exists, re-run your command with the 
    -Suffix switch, and add -SuffixValue and add a character or two which will append the value to
    the users Display Name, Username and email address, as well as the proxy addresseses.
    Name          Email                   Username Password 
    ----          -----                   -------- -------- 
    Iskaral PustM Iskaral.PustM@Swarm.com pustim   <password>
    .EXAMPLE
    Import-Csv C:\Temp\pfotest.csv | New-PFOUser11 -Suffix -SuffixValue v
    If you have a csv file full of users with the same name you can pipe that to
    the New-PFOUser function and add -Suffix -SuffixValue <up to 2 characters>
    Name         Email                  Username Password    
    ----         -----                  -------- --------    
    Kallor Fourv Kallor.Fourv@Swarm.com fourkv   <password>
    Crayon Askv  Crayon.Askv@Swarm.com  askcrv   <password>
    Kallor Onev  Kallor.Onev@Swarm.com  onekav   <password>
    Kallor Twov  Kallor.Twov@Swarm.com  two_kav  <password>
    Kallor Th... Kallor.Threev@Swarm... thre_kv  <password>
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
        [string]$Mobile,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [Switch]$Suffix,

        [Parameter(
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$SuffixValue
   
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

        if ($Suffix) {

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
                    $InitialOne           = $FirstName[0]
                    $InitialTwo           = $LastName[0]
                    $Initials             = "$InitialOne$InitialTwo"
                    $DisplayNamePreSuffix = (Get-Culture).TextInfo.ToTitleCase($i)            #Sets variable of displayt name to titlecase.
                    $DisplayName          = "$DisplayNamePreSuffix$SuffixValue"
                    $Title                = (Get-Culture).TextInfo.ToTitleCase($Title)        #Sets the title variable to titlecase
                    $Department           = (Get-Culture).TextInfo.ToTitleCase($Department)   #Sets the department variable to titlecase
                    $Office               = (Get-Culture).TextInfo.ToTitleCase($Office)       #Sets the office variable to titlecase
                    $Company              = (Get-Culture).TextInfo.ToTitleCase("s company")   #Sets a variable for company name
                    $Description          = $Title                                          #Sets a variable for description which is currently the same as company
                    
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

                    $UserNameMod          = "$LastNameMod$FirstNameMod$SuffixValue"                       #joins last four characters of the last name and the first character of the first name in a variable
                    $UserName             = (Get-Culture).TextInfo.ToLower($UserNameMod)      #sets the username variable to lowercase
                    $EmailAddress         = "$FirstName.$LastName$SuffixValue@Swarm.com"                  #creates the email address variable
                    $PrimarySMTP          = $EmailAddress                                     #Primary SMTP variable
                    $ProxyAddress1        = "$UserName@swarm.com"                             #Proxy address username .com             
                    $ProxyAddress2        = "$UserName@swarm.co.nz"                           #proxy address username .co.nz
                    $ProxyAddress3        = "$FirstName.$LastName$SuffixValue@swarm.co.nz"                #proxy address first name last name .co.nz
                    $Webpage              = "www.swarm.com"                                   #Variable for web page

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

                } #end of if employment type is permanent block

                elseif ($EmploymentType -eq 'Contractor') {

                    Write-Verbose "$i has been flagged as a contractor"

                    $GivenName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of full name to titlecase.
                    $Surname              = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase.
                    $FirstName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of first name to titlecase. Doubled up so the New-ADUser parameters are clearer.
                    $LastName             = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase. Doubled up so the New-ADUser parameters are clearer.
                    $InitialOne           = $FirstName[0]
                    $InitialTwo           = $LastName[0]
                    $Initials             = "$InitialOne$InitialTwo"
                    $DisplayNamePreSuffix = (Get-Culture).TextInfo.ToTitleCase($i)            #Sets variable of displayt name to titlecase.
                    $DisplayName          = "$DisplayNamePreSuffix$SuffixValue"
                    $Title                = (Get-Culture).TextInfo.ToTitleCase($Title)        #Sets the title variable to titlecase
                    $Department           = (Get-Culture).TextInfo.ToTitleCase($Department)   #Sets the department variable to titlecase
                    $Office               = (Get-Culture).TextInfo.ToTitleCase($Office)       #Sets the office variable to titlecase
                    $Company              = (Get-Culture).TextInfo.ToTitleCase("s company")   #Sets a variable for company name
                    $Description          = $Title                                          #Sets a variable for description which is currently the same as company
                    
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
                    $UserNameMod          = "$LastNameMod$ContractorMod$FirstNameMod$SuffixValue"         #joins last four characters of the last name and the first character of the first name in a variable
                    $UserName             = (Get-Culture).TextInfo.ToLower($UserNameMod)      #sets the username variable to lowercase
                    $EmailAddress         = "$FirstName.$LastName$SuffixValue@Swarm.com"                  #creates the email address variable
                    $PrimarySMTP          = $EmailAddress                                     #Primary SMTP variable
                    $ProxyAddress1        = "$UserName@swarm.com"                             #Proxy address username .com             
                    $ProxyAddress2        = "$UserName@swarm.co.nz"                           #proxy address username .co.nz
                    $ProxyAddress3        = "$FirstName.$LastName$SuffixValue@swarm.co.nz"                #proxy address first name last name .co.nz
                    $Webpage              = "www.swarm.com"                                   #Variable for web page

                    #############################################################################
                    ####################### Start of Country block ##############################
                    #############################################################################

                    if (-not($Country)) {

                        $Country = "New Zealand"

                    }
                    
                    if ($Country -eq "New Zealand") {

                        Write-Verbose "Country flagged as New Zealand"

                        $OU                = "OU=Swarm Contractors,OU=Swarm,DC=swarm,DC=com"       #Sets OU to x 
                        $C                 = "NZ"                                             #Sets C to NZ 
                        $CO                = "New Zealand"                                    #Sets CO to New Zealand
                        $CCode             = "554"                                            #Sets country code to NZ
                        $PreferredLanguage = "en-NZ"                                          #Sets preferred language to en-NZ             

                    } #end of Country is NZ block

                    elseif ($Country -eq "Australia") {

                        Write-Verbose "Country flagged as Australia"

                        $OU                = "OU=Swarm Contractors,OU=Swarm,DC=swarm,DC=com"        #Sets OU to x 
                        $C                 = "AU"                                             #Sets C to AU 
                        $CO                = "Australia"                                      #Sets Country to Australia
                        $CCode             = "036"                                            #Sets country code to Australia
                        $PreferredLanguage = "en-AU"                                          #Sets preferred language to en-AU 

                    } #end of Country is NZ block

                    #############################################################################
                    ######################## End of Country block ###############################
                    #############################################################################
                    
                
                #} #end of if employment type is contractor block

                #} #end of foreach $i in $Name

                } #end of else block

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
            ####################### Start of Manager Block ##############################
            #############################################################################

            Write-Verbose " Checking Manager exists"

            if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}) {                                                          

                if ((Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}).count -ge 2) {
    
                    $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager" -and $_.SamAccountName -notlike "admin*"}

                }
    
                elseif ((Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}).count -eq 1)  {
    
                    Write-Verbose "Assigning $Manager to variable"
                    $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}  

                }       

            }

            elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})) {               

                Write-Warning "Unable to find $Manager in directory, please set manually after creation" 
                continue                                                                       

            }

            #############################################################################
            ######################## End of Manager block ###############################
            #############################################################################

            #############################################################################
            ##################### Start of Permissions block ############################
            #############################################################################

            if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}) {


                if ((Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}).count -ge 2) {
                    
                    $Groups = (Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$Permissions" -and $_.SamAccountName -notlike "admin*"}).memberof  
            
                }
                    
                elseif ((Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}).count -eq 1)  {
                    
                    $Groups = (Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$Permissions"}).memberof
            
                }                         
            
            }
            
            elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"})) {          
            
                Write-Warning "$Permissions does not exist in the directory, skipping user"
                continue
                                                                                            
            }

            #############################################################################
            ###################### End of Permissions block #############################
            #############################################################################

            #############################################################################
            ######################## CREATE USER BLOCK ##################################
            #############################################################################

            $Arguments = @{                                                 #Sets all the parameter arguments for New-ADUser

                Path                  = $OU
                Name                  = $DisplayName
                Title                 = $Title
                Office                = $Office
                Initials              = $Initials
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

            [PSCustomObject] @{                                              #Creates a custom Powershell object into array for outputting new user information like username password etc

                Name     = $NewUser.Name                                         #Name of user
                Email    = (Get-ADUser $NewUser -Properties *).EmailAddress     #Email address of user
                Username = $NewUser.SamAccountName                           #Username 
                Password = $PasswordIs                                       #Password

            }

            } #end of foreach $i in $name for suffix block

        } #end of if suffix true block

        else {

            foreach ($i in $Name) {                                                           #for each name in name

                Write-Verbose "Checking if $i exists in domain"
                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$i"}) {                 #if user exists

                    Write-Warning "$i alreadys exists or a user with the same name exists"    #Write warning that user exists or a user with the same name exists
                    continue                                                                  #skip this item

                }

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
                    ####################### Start of Country block ##############################
                    #############################################################################

                    if (-not($Country)) {

                        $Country = "New Zealand"

                    }
                    
                    if ($Country -eq "New Zealand") {

                        Write-Verbose "Country flagged as New Zealand"

                        $OU                = "OU=Swarm Contractors,OU=Swarm,DC=swarm,DC=com"       #Sets OU to x 
                        $C                 = "NZ"                                             #Sets C to NZ 
                        $CO                = "New Zealand"                                    #Sets CO to New Zealand
                        $CCode             = "554"                                            #Sets country code to NZ
                        $PreferredLanguage = "en-NZ"                                          #Sets preferred language to en-NZ             

                    } #end of Country is NZ block

                    elseif ($Country -eq "Australia") {

                        Write-Verbose "Country flagged as Australia"

                        $OU                = "OU=Swarm Contractors,OU=Swarm,DC=swarm,DC=com"        #Sets OU to x 
                        $C                 = "AU"                                             #Sets C to AU 
                        $CO                = "Australia"                                      #Sets Country to Australia
                        $CCode             = "036"                                            #Sets country code to Australia
                        $PreferredLanguage = "en-AU"                                          #Sets preferred language to en-AU 

                    } #end of Country is NZ block

                    #############################################################################
                    ######################## End of Country block ###############################
                    #############################################################################

                } #end of else block

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
                ####################### Start of Manager Block ##############################
                #############################################################################

                Write-Verbose " Checking Manager exists"

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}) {                                                          

                    if ((Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}).count -ge 2) {

                        $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager" -and $_.SamAccountName -notlike "admin*"}

                    }

                    elseif ((Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"}).count -eq 1)  {

                        Write-Verbose "Assigning $Manager to variable"
                        $ManagerIs = Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Manager"}  

                    }       

                }

                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$manager"})) {               

                    Write-Warning "Unable to find $Manager in directory, please set manually after creation" 
                    continue                                                                       

                }

                #############################################################################
                ######################## End of Manager block ###############################
                #############################################################################

                #############################################################################
                ##################### Start of Permissions block ############################
                #############################################################################

                if (Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}) {


                    if ((Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}).count -ge 2) {
                        
                        $Groups = (Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$Permissions" -and $_.SamAccountName -notlike "admin*"}).memberof  
                
                    }
                        
                    elseif ((Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"}).count -eq 1)  {
                        
                        $Groups = (Get-ADUser -Filter * -Properties MemberOf | Where-Object {$_.Name -eq "$Permissions"}).memberof
                
                    }                         
                
                }
                        
                elseif (-not(Get-ADUser -Filter * | Where-Object {$_.Name -eq "$Permissions"})) {          
                
                    Write-Warning "$Permissions does not exist in the directory, skipping user"
                    continue
                                                                                                
                }

                #############################################################################
                ###################### End of Permissions block #############################
                #############################################################################

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

                [PSCustomObject] @{                                              #Creates a custom Powershell object into array for outputting new user information like username password etc

                    Name     = $NewUser.Name                                         #Name of user
                    Email    = (Get-ADUser $NewUser -Properties *).EmailAddress     #Email address of user
                    Username = $NewUser.SamAccountName                           #Username 
                    Password = $PasswordIs                                       #Password

                }

            } #end of foreach $i in $Name block

        } #end of else block

    } #end of process block

    END {

    }

}
