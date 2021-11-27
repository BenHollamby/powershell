function Disable-AclInheritance {
   
    [CmdletBinding(SupportsShouldProcess=$true)]

    param(

        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('PSPath')]
        [string]$Path,
        
        [Switch]
        $Preserve

    )
        
    $acl = Get-Acl -Path $Path
    if( -not $acl.AreAccessRulesProtected ) {

        Write-Verbose -Message ("[{0}] Disabling access rule inheritance." -f $Path)
        $acl.SetAccessRuleProtection( $true, $Preserve )
        $acl | Set-Acl -Path $Path

    }
}
