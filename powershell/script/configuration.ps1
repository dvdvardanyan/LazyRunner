function Load-Configuration {

    [OutputType([PSCustomObject])]

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$path
    )

    if(-Not (Test-Path $path -PathType leaf)) {
        throw "Configuration file could not be found.";
    }

    $config = Get-Content -Raw -Path $path | ConvertFrom-Json;

    return $config;
}