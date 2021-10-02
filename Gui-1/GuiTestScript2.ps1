#region Setup
Set-Location $PSScriptRoot
Remove-Module PSScriptMenuGui -ErrorAction SilentlyContinue
try {
    Import-Module PSScriptMenuGui -ErrorAction Stop
}
catch {
    Write-Warning $_
    Write-Verbose 'Attempting to import from parent directory...' -Verbose
    Import-Module '..\'
}
#endregion

$params = @{
    csvPath = 'C:\Users\Kallor\devops\powershell\Gui-1\test1.csv'
    windowTitle = "Chris's bitchin GUI"
    buttonForegroundColor = 'Azure'
    buttonBackgroundColor = '#000000' #eb4034
    hideConsole = $true
    noExit = $true
    Verbose = $true
}
Show-ScriptMenuGui @params