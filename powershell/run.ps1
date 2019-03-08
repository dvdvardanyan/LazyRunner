clear

# Load functions
. "$($PSScriptRoot)\script\configuration.ps1";
. "$($PSScriptRoot)\script\log.ps1";
. "$($PSScriptRoot)\script\helper.ps1";
. "$($PSScriptRoot)\script\assembly.ps1";

try {

    # Variable to write into log file
    [bool]$WriteLog = $false;

    # Load configuration file
    $config = Load-Configuration ((Join-Path $PSScriptRoot "config.json"));

    # Setup log file
    if($config.runtimeConfiguration.logFileDirectory -ne $null -and $config.runtimeConfiguration.logFileDirectory -ne "") {
        $WriteLog = $true;
        Init-Log (Get-Path($config.runtimeConfiguration.logFileDirectory));
    }
    
    # Loading assemblies
    if($config.runtimeConfiguration.assemblies -ne $null -and $config.runtimeConfiguration.assemblies.Length -gt 0) {
        Load-Assemblies $config.runtimeConfiguration.assemblies;
    }

} catch {
    Write-Host ($_.Exception.Message);
}