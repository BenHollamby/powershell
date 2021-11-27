#Test drive is a way to pretend you have a file system using psdrive
#so that you make changes to a virtual file system instead of 
#testing against a real one.

<#
function that
takes a file as an input and modifies it in some manner. The function below accepts a file path as
a parameter and when run, gets the contents of that file, replaces a string and then overwrites the
original file contents with the replaced string version
#>

function Set-File {

    param(
    [string]$FilePath
    )

    $fileContents = Get-Content -Path $FilePath -Raw
    $replacement = $fileContents -replace 'foo','bar'
    Set-Content -Path $FilePath -Value $replacement -NoNewLine
    
}

#To use test drive you'll create a dummy file using pester
#that will represent what you expect to be
#in this case, foo bar foo bar will result in bar bar bar bar

describe 'Set-File changes the file provided' {

    $testFilePath = 'TestDrive:\testFile.txt'
    Add-Content -Path $testFilePath -Value 'foo bar foo bar' -NoNewLine
    Set-File -FilePath $testFilePath

    it 'replaces foo with bar' {

        (Get-Content -Path $testFilePath -Raw) | should -Be 'bar bar bar bar'
        
    }

}

#the beauty of it is that it will clean up after itself and no real world files
#were changed