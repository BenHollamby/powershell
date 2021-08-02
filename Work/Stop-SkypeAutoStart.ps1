$User_Keys = Get-ChildItem REGISTRY::HKEY_USERS

foreach ($User_Key in $User_Keys) {

        $length = $User_Key.ToString()
        $number = Measure-Object -InputObject $length -Character

        if ($number.Characters -gt 30) {

            $string1 = "REGISTRY::"
            $string2 = "$User_Key"
            $string3 = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
            $Key = Write-Output ($string1 + $string2 + $string3)

            if ($Key) {
            
                Try {

                    Remove-ItemProperty -Path $key -Name lync -ErrorAction SilentlyContinue

                } 
                
                Catch {

                    Write-Warning "Some inconsequential error"

                }

            }
            
        }
         
}

      