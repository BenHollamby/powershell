#this script checks if you are in Australia or NZ, and then sets your primary language.
#if you are in NZ, it also sets you keyboard to use Maori keyboard.

$location = Get-WinHomeLocation | Select-Object -ExpandProperty HomeLocation

if ($location -eq "New Zealand") { 

    Write-Host -ForegroundColor Green "Country is NZ"

    $language = New-WinUserLanguageList -Language "en-NZ"
    $language.add("en-US")                                      #Copy this line as many times as you like and paste directly below it to add more languages. You can also remove this line altogether to ditch the US keyboard.

    try {

        Set-WinUserLanguageList -LanguageList $language -Force
        Set-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Keyboard Layouts\00000409\' -Name "Layout File" -Value KBDMAORI.DLL

        }
        catch {

            Write-Host -ForegroundColor Red "Catastrophic failure of unknown proportions"
            
            }        

}elseif ($location -eq "Australia") {

    Write-Host -ForegroundColor Yellow "Country is Australia"

    $language = New-WinUserLanguageList -Language "en-AU"
    $language.add("en-US")                                      

    try {

        Set-WinUserLanguageList -LanguageList $language -Force

        }
        catch {

            Write-Host -ForegroundColor Red "Catastrophic failure of unknown proportions"

            }

}else {

    Write-Host -ForegroundColor Red "Country not either NZ or Australia, leaving alone."

} 


