function Clone-HVVM {

    <#
    .SYNOPSIS
    Clone-HVVM will create a new Hyper-V virtual machine from a template
    .DESCRIPTION
    This creates a brand new virtual machine cloned from a template. 
    Currently only have a Server 2022 template, but all set up configuration
    is complete via an unattend file set up in the template
    .PARAMETER Name
    Mandatory
    Names the VM
    .PARAMETER Template
    Mandatory
    Tab complete for template
    Only have Server 2022 as a template at this stage
    .PARAMETER Path
    Mandatory
    Tab complete for drive. If the drive is anything other than C:\ (or F:\ cause space)
    Sets the variable to the VMs folder location
    .PARAMETER Processors
    Optional
    Tab complete going 1 through 8. Default set to 4.
    .PARAMETER Memory
    Optional
    Tab complete going 1 through 8. Default set to 4.
    .EXAMPLE
    Clone-HVVM -Name Test88 -Template Server2022 -Path H:\
    #>

    [cmdletbinding()]

    param (

        [Parameter(Mandatory,
                   ValueFromPipeline
                   )]
        [string]$Name,

        [Parameter(Mandatory)]
        [ArgumentCompleter({"Server2022", "Server2019"})]
        [string]$Template,

        [Parameter(Mandatory)]
        [ArgumentCompleter({Get-PSDrive | Where-Object {$_.Provider -like "*FileSystem*" -and $_.Name -ne "F"} | Select-Object -ExpandProperty Root})]
        [string]$Path,

        [ArgumentCompleter({1..8})]
        [int]$Processors = 4,

        [ArgumentCompleter({1..8})]
        [int]$Memory = 4

    )

    BEGIN {

        Write-Verbose "Starting BEGIN block"

        Write-Verbose "Setting Path variable"
        if ($Path -eq "C:\") {

            $Path = "C:\Users\Public\Documents\Hyper-V\VMs"

        } else {

            $Path = "$path\VMs"

        }

        Write-Verbose "Converting Memory variable from GB to Bytes"
        $MemoryBytes = $Memory * ([math]::Pow(1024,3))

        Write-Verbose "Setting VHDX path for Template variable"
        if ($Template -eq "Server2022") {

            $VHDX = 'H:\Server Templates\Server2022Template\Virtual Hard Disks\Server2022Template.vhdx'

        }

    }

    PROCESS {

        Write-Verbose "Starting Process Block"

        Try {

            $Continue = $true
            Write-Verbose "Creating Gen 2 VM named $Name with $Memory GB of Memory"
            New-VM -Name $Name -MemoryStartupBytes $MemoryBytes -Generation 2 | Out-Null -ErrorAction Stop
        
        } Catch {

            $Continue = $false
            Write-Warning "Failed to create New-VM"

        }

        if ($Continue){

            Try {

                Write-Verbose "Setting $Processors vCPUs on $Name and disabling automatic checkpoints"
                Set-VM -Name $Name -ProcessorCount $Processors -AutomaticCheckpointsEnabled $false -ErrorAction Stop

            } Catch {
                
                Write-Warning "Unable to set VM processor count or disable automatic checkpoints"

            }

            Try {

                Write-Verbose "Disabling dynamic memory"
                Set-VMMemory -VMName $Name -DynamicMemoryEnabled $false

            } Catch {

                Write-Warning "Unable to disable dynamic memory"

            }
            
            Try {

                Write-Verbose "Connecting Network Adapter to VM $Name"
                Connect-VMNetworkAdapter -VMName $Name -SwitchName "Default Switch"

            } Catch {

                Write-Warning "Unable to connect Default Switch network adapter to $VMName"

            }

            Try {

                Write-Verbose "Creating VM location"
                $vmpath = New-Item -Name $Name -ItemType Directory -Path $Path -ErrorAction Stop

            } Catch {

                $Continue = $false
                Write-Warning "Unable to create VM directory"

            }

            if ($Continue) {

                Try {

                    Write-Verbose "Creating vm disk directory"
                    $vmdiskpath = New-Item -Name "Virtual Hard Disks" -ItemType Directory -Path $vmpath -ErrorAction Stop

                } Catch {
                    $Continue = $false
                    Write-Warning "Unable to create disk directory"

                }

                if ($Continue) {

                    Try {

                        Write-Verbose "Copying Server Template"
                        Copy-Item -Path $VHDX -Destination $vmdiskpath -ErrorAction Stop

                    } Catch {

                        $Continue = $false
                        Write-Warning "Unable to copy server template"

                    }

                    if ($Continue) {

                        Try {

                            Write-Verbose "Attaching disk to VM"
                            Add-VMHardDiskDrive -VMName $Name -Path "$vmdiskpath\Server2022Template.vhdx" -ErrorAction Stop

                        } Catch {

                            $Continue = $false
                            Write-Warning "Unable to attach disk"

                        }

                        if ($Continue) {

                            Write-Verbose "Setting Boot Order"
                            $BootOrder = (Get-VMFirmware $Name).BootOrder
                            $PXE = $BootOrder[0]
                            $HDD = $BootOrder[1]
                            
                            Try {

                                Set-VMFirmware -VMName $Name -BootOrder $HDD,$PXE -ErrorAction Stop

                            } Catch {

                                Write-Warning "Unable to set bootorder"

                            }

                        }

                    }

                } 

            }

        } 

    }

    END {

        Write-Verbose "Starting END block"

        Try {

            Write-Verbose "Starting VM"
            Start-VM $name -ErrorAction Stop

        } Catch {

            Write-Warning "Unable to start VM"

        } 

    }

}