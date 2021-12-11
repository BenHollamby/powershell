# Implement your module commands in this script.
function Format-SwarmName {

    [cmdletbinding()]

    param(

        [Parameter(Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName)]
        [string]$Name

    )

    BEGIN {

    }

    PROCESS {

        $PrimaryDomain = "@swarm.com"
        $SecondaryDomain = "@swarm.co.nz"

        

        $Script:GivenName     = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0]) #Sets variable of full name to titlecase.
        $Script:Surname       = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1]) #Sets variable of last name to titlecase.
        $Script:FirstName     = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0]) #Sets variable of first name to titlecase. Doubled up so the New-ADUser parameters are clearer.
        $Script:LastName      = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1]) #Sets variable of last name to titlecase. Doubled up so the New-ADUser parameters are clearer.
        $Script:DisplayName   = (Get-Culture).TextInfo.ToTitleCase($Name)            #Sets variable of displayt name to titlecase.
        
        if ($LastName.Length -eq 3) {                                                #if lastname is less than 3 do

            $Length           = $LastName.Length                                     #Gets length of last name  
            $LastNameMod      = $LastName.Substring(0,$Length)                       #Gets length number of characters 
            $FirstNameMod     = $FirstName.Substring(0,2)                            #Gets first two letters of the firstname
            
        } #end of lastname equals 3 block
        
        elseif ($lastname.Length -le 2) {                                            #if name less than or equal to two characters  
        
            $Length           = $LastName.Length                                     #Gets length of last name  
            $LastNameMod      = $LastName.Substring(0,$Length)                       #Gets length number of characters
            $FirstNameMod     = $FirstName.Substring(0,3)                            #Gets first three letters of the firstname
        
        } #end of last name less than or equal to block
        
        else {
        
            $LastNameMod      = $LastName.Substring(0,4)                             #grabs the first four characters of last name.   
            $FirstNameMod     = $firstname[0]                                        #grabs the first character of the first name.   
            
        } #end of catch all block

        $UserNameMod          = "$LastNameMod$FirstNameMod"                          #joins last four characters of the last name and the first character of the first name in a variable
        $Script:UserName      = (Get-Culture).TextInfo.ToLower($UserNameMod)         #sets the username variable to lowercase
        $Script:EmailAddress  = "$FirstName.$LastName$PrimaryDomain"                 #creates the email address variable
        $Script:PrimarySMTP   = $EmailAddress                                        #Primary SMTP variable
        $Script:ProxyAddress1 = "$UserName$PrimaryDomain"                            #Proxy address username .com             
        $Script:ProxyAddress2 = "$UserName$SecondaryDomain"                          #proxy address username .co.nz
        $Script:ProxyAddress3 = "$FirstName.$LastName$SecondaryDomain"               #proxy address first name last name .co.nz

    }

    END {

    }

}

function Test-FormatName {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                    ValueFromPipeline)]
        $Object

    )

    $testobject = [PSCustomObject] @{

        GivenName     = $GivenName
        Surname       = $Surname
        FirstName     = $FirstName
        LastName      = $LastName 
        DisplayName   = $DisplayName
        UserName      = $UserName
        EmailAddress  = $EmailAddress
        PrimarySMTP   = $PrimarySMTP
        ProxyAddress1 = $ProxyAddress1
        ProxyAddress2 = $ProxyAddress2 
        ProxyAddress3 = $ProxyAddress3

    }

    $testobject

}

function Format-SwarmNameContractor {

    [cmdletbinding()]

    param(

        [Parameter(Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName)]
        [string]$Name

    )

    BEGIN {

    }

    PROCESS {
        
        $PrimaryDomain = "@swarm.com"
        $SecondaryDomain = "@swarm.co.nz"

        $Script:GivenName            = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0]) #Sets variable of full name to titlecase.
        $Script:Surname              = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1]) #Sets variable of last name to titlecase.
        $Script:FirstName            = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0]) #Sets variable of first name to titlecase. Doubled up so the New-ADUser parameters are clearer.
        $Script:LastName             = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[1]) #Sets variable of last name to titlecase. Doubled up so the New-ADUser parameters are clearer.
        $Script:DisplayName          = "$FirstName $LastName"               #Sets Displayname with suffix to variable  
        
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

        $ContractorMod        = "_"                                                   #underscore variable for contractor
        $UserNameMod          = "$LastNameMod$ContractorMod$FirstNameMod" #joins last four characters of the last name and the first character of the first name in a variable
        $Script:UserName             = (Get-Culture).TextInfo.ToLower($UserNameMod)          #sets the username variable to lowercase
        $Script:EmailAddress         = "$FirstName.$LastName$PrimaryDomain"          #creates the email address variable
        $Script:PrimarySMTP          = $EmailAddress                                         #Primary SMTP variable
        $Script:ProxyAddress1        = "$UserName$PrimaryDomain"                                 #Proxy address username .com             
        $Script:ProxyAddress2        = "$UserName$SecondaryDomain"                               #proxy address username .co.nz
        $Script:ProxyAddress3        = "$FirstName.$LastName$SecondaryDomain"        #proxy address first name last name .co.nz


    }

    END {

    }

}

function Test-FormatNameContractor {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                    ValueFromPipeline)]
        $Object

    )

    $testobject = [PSCustomObject] @{

        GivenName     = $GivenName
        Surname       = $Surname
        FirstName     = $FirstName
        LastName      = $LastName 
        DisplayName   = $DisplayName
        UserName      = $UserName
        EmailAddress  = $EmailAddress
        PrimarySMTP   = $PrimarySMTP
        ProxyAddress1 = $ProxyAddress1
        ProxyAddress2 = $ProxyAddress2 
        ProxyAddress3 = $ProxyAddress3

    }

    $testobject

}


function Format-SwarmNameApostrophe {

    [cmdletbinding()]

    param(

        [Parameter(Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName)]
        [string]$Name

    )

    BEGIN {

    }

    PROCESS {

        $PrimaryDomain = "@swarm.com"
        $SecondaryDomain = "@swarm.co.nz"

        $Script:FirstName = (Get-Culture).TextInfo.ToTitleCase($Name.Split()[0])

        $Script:ApostropheIndex = $Name.Split()[1].IndexOf("'") + 1
        $Script:PostApostropheCharacterToReplace = ($Name.Split()[1])[$ApostropheIndex]
        $Script:PostApostropheCharacterReplacement = ($Name.Split()[1])[$ApostropheIndex].ToString().ToUpper()
        $Script:LastName = ((Get-Culture).TextInfo.ToTitleCase($Name.Split()[1])) -replace "$PostApostropheCharacterToReplace","$PostApostropheCharacterReplacement"
        $Script:GivenName = "$FirstName"
        $Script:Surname = $LastName
        $Script:DisplayName = "$FirstName $LastName"
        $Script:EditedLastName = $LastName -replace "'"

        if ($EditedLastName.Length -eq 3) {                                                #if lastname is less than 3 do

            $Length           = $EditedLastName.Length                                     #Gets length of last name  
            $LastNameMod      = $EditedLastName.Substring(0,$Length)                       #Gets length number of characters 
            $FirstNameMod     = $FirstName.Substring(0,2)                            #Gets first two letters of the firstname
            
        } #end of lastname equals 3 block
        
        elseif ($lastname.Length -le 2) {                                            #if name less than or equal to two characters  
        
            $Length           = $EditedLastName.Length                                     #Gets length of last name  
            $LastNameMod      = $EditedLastName.Substring(0,$Length)                       #Gets length number of characters
            $FirstNameMod     = $FirstName.Substring(0,3)                            #Gets first three letters of the firstname
        
        } #end of last name less than or equal to block
        
        else {
        
            $LastNameMod      = $EditedLastName.Substring(0,4)                             #grabs the first four characters of last name.   
            $FirstNameMod     = $firstname[0]                                        #grabs the first character of the first name.   
            
        } #end of catch all block

        $UserNameMod          = "$LastNameMod$FirstNameMod"                          #joins last four characters of the last name and the first character of the first name in a variable
        $Script:UserName      = (Get-Culture).TextInfo.ToLower($UserNameMod)         #sets the username variable to lowercase
        $Script:EmailAddress  = "$FirstName.$LastName$PrimaryDomain"                 #creates the email address variable
        $Script:PrimarySMTP   = $EmailAddress                                        #Primary SMTP variable
        $Script:ProxyAddress1 = "$UserName$PrimaryDomain"                            #Proxy address username .com             
        $Script:ProxyAddress2 = "$UserName$SecondaryDomain"                          #proxy address username .co.nz
        $Script:ProxyAddress3 = "$FirstName.$LastName$SecondaryDomain"               #proxy address first name last name .co.nz

        }

    END {

    }

}

function Test-FormatNameApostrophe {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                    ValueFromPipeline)]
        $Object

    )

    $testobject = [PSCustomObject] @{

        GivenName     = $GivenName
        Surname       = $Surname
        FirstName     = $FirstName
        LastName      = $LastName
        EditedLastName = $EditedLastName 
        DisplayName   = $DisplayName
        UserName      = $UserName
        EmailAddress  = $EmailAddress
        PrimarySMTP   = $PrimarySMTP
        ProxyAddress1 = $ProxyAddress1
        ProxyAddress2 = $ProxyAddress2 
        ProxyAddress3 = $ProxyAddress3

    }

    $testobject

}


# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-*
