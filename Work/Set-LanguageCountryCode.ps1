$users = get-content C:\temp\nzusers.txt

foreach ($user in $users) {

    Set-ADUser -Identity $user -Country 'NZ'

    Set-ADObject -Identity $user.DistinguishedName -Replace @{preferredLanguage="en-NZ";
                                                              co="New Zealand";
                                                              countryCode="554"}
    
    }


$users = get-content C:\temp\aussieusers.txt

foreach ($user in $users) {

    Set-ADUser -Identity $user -Country 'AU'

    Set-ADObject -Identity $user.DistinguishedName -Replace @{preferredLanguage="en-AU";
                                                              co="Australia";
                                                              countryCode="036"}
    
    }