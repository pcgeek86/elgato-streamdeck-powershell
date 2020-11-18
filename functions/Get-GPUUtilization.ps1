function Get-GPUUtilization {
    <#
    .Synopsis
    Retrieves the watts being consumed by the GPU.

    .Description
    This function calls nvidia-smi.exe, which must be on your $env:PATH, in order for it to be located. The output of
    nvidia-smi.exe is parsed with a regular expression that extracts the watts consumed by the GPU.

    The function returns an integer value, containing the watts currently being consumed by the GPU.
    #>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param ()
    $null = ((nvidia-smi.exe --query --display=power) -match '(?sn)Power Draw')[0] -match '(?<watts>\d{1,3})'
    $Utilization = $Matches.watts

    LogMessage -Message ('GPU watts used: {0}' -f $Utilization)
    return $Utilization
}
