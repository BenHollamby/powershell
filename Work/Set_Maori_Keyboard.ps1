$path = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Keyboard Layouts\00000409' -Name "Layout File").'Layout File'

if ($path -ne "KBDUS.DLL") { 

        Write-Host -ForegroundColor Yellow "Layout File is $path"

}else {

    try {

        Set-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Keyboard Layouts\00000409\' -Name "Layout File" -Value KBDMAORI.DLL
        
    }
    catch {

        Write-Host -ForegroundColor Red "Failed to change the layout file"

    }
    
}

$output = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Keyboard Layouts\00000409' -Name "Layout File").'Layout File'

if ($output -eq "KBDMAORI.DLL") {

    Write-host -ForegroundColor Green "Value is $output"

    }else {

        Write-Host -ForegroundColor Red "Value is $output"

        }