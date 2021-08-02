$users = Get-ADUser -Filter * | Where-Object {$_.Name -like "drone*"} | Select-Object -ExpandProperty SamAccountName

foreach ($user in $users) {

    Get-ADuser -Identity $user | Get-ADObject -Properties * | Select-Object sAMAccountName, c, co, countryCode, Country, preferredlanguage |ft
    
    }