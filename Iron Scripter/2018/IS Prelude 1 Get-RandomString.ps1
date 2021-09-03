<#
You’re required to produce a function to move AD user accounts between OUs. The user should have their current 
group memberships removed and be added to the groups of the other users in the OU. Assume that all users in the 
OU will have the same group membership. 
Any user that hasn’t logged on for more than 90 days should be moved to a holding OU BUT should retain their 
group memberships. These accounts should be disabled.
Your solution will be judged on:
#>

function Move-SwarmUser {

    <#
    .SYNOPSIS
    Move-SwarmUser will move a user, and change the groups based on the OU you select.
    
    .DESCRIPTION
    Move-SwarmUser is a function to move AD user accounts between OUs. The user should have their current 
    group memberships removed and be added to the groups of the other users in the OU. Assume that all users in the 
    OU will have the same group membership. 
    Any user that hasn’t logged on for more than 90 days should be moved to a holding OU BUT should retain their 
    group memberships. These accounts should be disabled.
    
    .PARAMETER User
    Mandatory
    SamAccountName works best
    
    .PARAMETER OU
    Mandatory
    Tab select to complete
    
    .EXAMPLE
    Move-SwarmUser -User dronesix -OU OUZEROONE
    
    #>
    
    
        [cmdletbinding(SupportsShouldProcess)]
    
        param (
    
            [Parameter(Mandatory,
                       Position=0)]
            #[ValidateNotNullOrEmpty]
            [string]$User,
    
            [Parameter(Mandatory)]
            [ArgumentCompleter({(Get-ADOrganizationalUnit -Filter * | Where-Object {$_.Name -like "*ZERO*"}).Name})]
            [string]$OU
    
        )
    
        BEGIN {
    
            Write-Verbose "Start of BEGIN block"
            foreach ($U in $User) {
    
                Try {
                    
                    Write-Verbose "Attempt to get AD User $U"
                    $SwarmUser = Get-ADUser $U -ErrorAction Stop
    
                } 
    
                Catch {
    
                    Write-Warning "Unable to find AD User. Check SamAccountName."
    
                }
    
                Write-Verbose "Attempting to set $OU Organisational Unit as a variable"
                $SwarmUnit = Get-ADOrganizationalUnit -LDAPFilter "(name=$OU)"
    
                Write-Verbose "If SwarmUnit variable has data, proceed variable set to true. Else set to false"
                if ($SwarmUnit) {
    
                    $Proceed = $true
    
                } else {
    
                    $Proceed = $false
                    Write-Warning "Variable is empty, please tab complete -OU"
    
                }
    
                if ($Proceed) {
    
                    Write-Verbose "Getting users from $OU"
                    $GetNewOUUser = Get-ADUser -Filter * -SearchBase $SwarmUnit.DistinguishedName
    
                    Write-Verbose "Getting the first user from $OU"
                    $LuckyUser = $GetNewOUUser[0]
    
                    Write-Verbose "Getting the groups $LuckyUser is a member of"
                    $UserGroups = Get-ADUser $LuckyUser -Properties MemberOf
    
                    Write-Verbose "Assigning all groups to Groups variable"
                    $Groups = $UserGroups.MemberOf
    
                    
                }
    
            }
    
            Write-Verbose "End of BEGIN block"
    
        }
    
        PROCESS {
    
            $SwarmUserName = $SwarmUser.toString()
            $SwarmUnitName = $SwarmUnit.toString()
    
            Write-Verbose "Start of PROCESS block"
    
            Write-Verbose "Getting all users who have not logged in, in over 90 days"
            $DisableUsers = Get-ADUser -Filter * | Where-Object {$_.LastLogonDate -gt (Get-Date).AddDays(-90)}
    
            foreach ($DisableUser in $DisableUsers) {
                
                Write-Verbose "Disabling $DisableUser account"
                if ($PSCmdlet.ShouldProcess($DisableUser,"$DisableUser account will be disabled")) {
    
                    Try {
    
                        Disable-ADAccount $DisableUser -ErrorAction Stop
    
                    } Catch {
    
                        Write-Warning "Unable to disable users $DisableUser"
    
                    }
    
                    Write-Verbose "Moving $DisableUser to holding OU"
    
                    Try {
    
                        $DisabledGroup = Get-ADOrganizationalUnit -Filter * | Where-Object {$_.Name -eq "SWARMDISABLED"}
                        $DisableUser | Move-ADObject -TargetPath $DisabledGroup  -ErrorAction Stop
    
                    } Catch {
                        
                        Write-Warning "Unable to move $DisableUser to $DisabledGroup"
    
                    }
    
                }
    
            }
    
            Write-Verbose "Getting all groups $SwarmUser is a member of"
            $SwarmUserGroups = (Get-ADUser $SwarmUser -Properties MemberOf).MemberOf
            
            foreach ($SwarmUserGroup in $SwarmUserGroups) {
                
                Write-Verbose "Removing $SwarmUser from $ $SwarmUserGroup"
    
                if ($PSCmdlet.ShouldProcess($SwarmUserGroup,"$SwarmUser will be removed as a member of")) {
    
                    Try {
    
                        Remove-ADGroupMember -Identity $SwarmUserGroup -Members $SwarmUser -Confirm:$false -ErrorAction Stop
    
                    } Catch {
    
                        Write-Warning "Unable to remove $SwarmUser from $SwarmUserGroups"
    
                    }
    
                }
    
            }
    
            Write-Verbose "Adding groups to $SwarmUser"
            foreach ($Group in $Groups) {
    
                Write-Verbose "Adding $SwarmUser to $Group"
    
                if ($PSCmdlet.ShouldProcess($Group,"$SwarmUser will be added to")) {
    
                    Try {
    
                        Add-ADGroupMember -Identity $Group -Members $SwarmUser -ErrorAction Stop
    
                    } Catch {
    
                        Write-Warning "Unable to add $SwarmUser to $Group"
    
                    }
    
                }
    
            }
            
            Write-Verbose "Moving $SwarmUser to $OU"
    
            if ($PSCmdlet.ShouldProcess($_,"$SwarmUser will be moved to")) {
    
                Try {
    
                    Move-ADObject -Identity $SwarmUserName -TargetPath $SwarmUnitName
    
                } Catch {
    
                    Write-Warning "Unable to move $SwarmUserName to $SwarmUnitName"
    
                }
    
            }
    
            Write-Verbose "End of PROCESS block"
    
        }
    
        END {
    
        }
    
    }