#Test registry is essentially the same as testdrive but for Windows Registry

function Get-InstallPath($path, $key) {

    Get-ItemProperty -Path $path -Name $key | Select-Object -ExpandProperty $key

}

<#
To build a test for this to ensure when you call Get-InstallPath, it queries the expected
registry key. To test this, you could use TestRegistry to create a virtual registry key at the expected
path, call the function passing in that virtual registry key path and key name and then test to ensure
the function queried the expected key as shown below.
#>

describe 'Get-InstallPath' {

    New-Item -Path TestRegistry:\ -Name TestLocation
    New-ItemProperty -Path 'TestRegistry:\TestLocation' -Name 'InstallPath' -Value 'C:\Program Files\MyApplication'

    It 'reads the install path from the registry' {

        Get-InstallPath -Path 'TestRegistry:\TestLocation' -Key 'InstallPath' | Should -Be 'C:\Program Files\MyApplication'

    }

}