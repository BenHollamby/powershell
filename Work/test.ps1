function Test-InputData {

    [cmdletbinding()]

    param (

        [Parameter(
                    ParameterSetName = 'Default',
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName
                    )]
        [array]$InputData

    )

    if ($InputData) {

        write-host "Something in the pipe!"

    } #End of Value From PipelineByPropertyName

    elseif ($InputData -eq $null) {

        Write-Host "$process was bad"

    } #End of InputData null block

}