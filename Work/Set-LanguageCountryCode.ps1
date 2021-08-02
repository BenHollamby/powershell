#1. NZ Users AD set C, CO and countryCode

$users = get-content C:\temp\nzusers.txt

foreach ($user in $users) {

    Set-ADUser -Identity $user -Country 'NZ'

    Set-ADObject -Identity $user.DistinguishedName -Replace @{preferredLanguage="en-NZ";
                                                              co="New Zealand";
                                                              countryCode="554"}
    
    }


#2. AU Users AD set C, CO and countryCode

$users = get-content C:\temp\aussieusers.txt

foreach ($user in $users) {

    Set-ADUser -Identity $user -Country 'AU'

    Set-ADObject -Identity $user.DistinguishedName -Replace @{preferredLanguage="en-AU";
                                                              co="Australia";
                                                              countryCode="036"}
    
    }


#3. Set Aussie Users mailboxes date, time, language, region

$users = Get-Content C:\Temp\AussieMailboxes.txt

foreach ($user in $users) {

    Set-MailboxRegionalConfiguration -Identity $user -Language en-AU -DateFormat d/MM/yyyy -TimeFormat "HH:mm" -TimeZone "AUS Eastern Standard Time"

    }

#4. Set Kangaroo Island users mailboxes date, time, language, region
$users = Get-Content C:\Temp\kangarooisland.txt

foreach ($user in $users) {

    Set-MailboxRegionalConfiguration -Identity $user -Language en-AU -DateFormat d/MM/yyyy -TimeFormat "HH:mm" -TimeZone "AUS Central Standard Time"

    }

#5. Set NZ Users mailboxes date, time, language, region
$users = Get-Content C:\Temp\nzusers.txt

foreach ($user in $users) {

    Set-MailboxRegionalConfiguration -Identity $user -Language en-NZ -DateFormat d/MM/yyyy -TimeFormat "HH:mm" -TimeZone "New Zealand Standard Time" -WhatIf

    }