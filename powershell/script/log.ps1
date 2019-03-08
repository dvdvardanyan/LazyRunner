[string]$LOG_PS1_LogFilePath;

function Init-Log {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$path
    )

    # Check if log directory exists
    if(-Not (Test-Path $path -PathType Container)) {
        New-Item -ItemType Directory -Path $path | Out-Null;
    }
}

function Log-Error {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$path
    )
}