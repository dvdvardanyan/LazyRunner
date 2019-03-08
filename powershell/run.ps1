clear

# Load functions
. "$($PSScriptRoot)\script\configuration.ps1";
. "$($PSScriptRoot)\script\log.ps1";
. "$($PSScriptRoot)\script\helper.ps1";
. "$($PSScriptRoot)\script\assembly.ps1";
. "$($PSScriptRoot)\script\folder.ps1";

# Variable flag to write into log file
[bool]$WriteLog = $false;

try {

    # Load configuration file
    $config = Load-Configuration ((Join-Path $PSScriptRoot "config.json"));

    # Setup log file
    if($config.runtimeConfiguration.log -ne $null -and (-Not([string]::IsNullOrWhiteSpace($config.runtimeConfiguration.log.directory)))) {
        $WriteLog = $true;
        Init-Log (Get-Path($config.runtimeConfiguration.log.directory));
    }
    
    # Loading assemblies
    if($config.runtimeConfiguration.assemblies -ne $null -and $config.runtimeConfiguration.assemblies.Length -gt 0) {
        Load-Assemblies $config.runtimeConfiguration.assemblies;
    }

    # Run actions
    if($config.run -ne $null -and $config.run.Length -gt 0) {
        foreach($item in $config.run) {
            switch($item.type) {
                
                "SetupFolderStructure" {
                    foreach($action in $item.actions) {
                        Setup-FolderStructure $action;
                    }
                }

                "MoveFolders" {
                    foreach($setting in $item.actions) {
                        Move-Folder $setting;
                    }
                }
            }
        }
    }
} catch {
    
    if($WriteLog) {
        Log-Error ($_.Exception.Message);
    }
    
    Write-Host ($_.Exception.Message);
}