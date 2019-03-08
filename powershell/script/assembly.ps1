function Load-Assemblies {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][PSCustomObject]$assemblies
    )

    foreach($assembly in $assemblies) {

        if($assembly.key -eq "name") {
            Add-Type -AssemblyName $assembly.value;
        } elseif($assembly.key -eq "path") {
            $apath = (Replace-Path $assembly.value);
            Add-Type -Path $apath;
        }
    }

    Write-Host "";
}