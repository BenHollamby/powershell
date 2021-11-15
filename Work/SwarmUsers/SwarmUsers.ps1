function Format-SwarmNamePermanent {

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [string]$Name

    )

    foreach ($i in $Name) {

        $GivenName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of full name to titlecase.
        $Surname              = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase.
        $FirstName            = (Get-Culture).TextInfo.ToTitleCase($i.Split()[0]) #Sets variable of first name to titlecase. Doubled up so the New-ADUser parameters are clearer.
        $LastName             = (Get-Culture).TextInfo.ToTitleCase($i.Split()[1]) #Sets variable of last name to titlecase. Doubled up so the New-ADUser parameters are clearer.
        $DisplayNamePreSuffix = (Get-Culture).TextInfo.ToTitleCase($i)            #Sets variable of displayt name to titlecase.
        $DisplayName          = "$DisplayNamePreSuffix$SuffixValue"
        
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

        $UserNameMod          = "$LastNameMod$FirstNameMod$SuffixValue"           #joins last four characters of the last name and the first character of the first name in a variable
        $UserName             = (Get-Culture).TextInfo.ToLower($UserNameMod)      #sets the username variable to lowercase
        $EmailAddress         = "$FirstName.$LastName$SuffixValue@Swarm.com"      #creates the email address variable
        $PrimarySMTP          = $EmailAddress                                     #Primary SMTP variable
        $ProxyAddress1        = "$UserName@swarm.com"                             #Proxy address username .com             
        $ProxyAddress2        = "$UserName@swarm.co.nz"                           #proxy address username .co.nz
        $ProxyAddress3        = "$FirstName.$LastName$SuffixValue@swarm.co.nz"    #proxy address first name last name .co.nz

    }

    $GivenName 
    $Surname            
    $FirstName  
    $LastName     
    $DisplayNamePreSuffix
    $DisplayName 
    $UserNameMod 
    $UserName       
    $EmailAddress  
    $PrimarySMTP   
    $ProxyAddress1 
    $ProxyAddress2 
    $ProxyAddress3  
    
}