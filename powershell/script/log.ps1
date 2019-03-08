[string]$script:LOG_PS1_LogFilePath;

function Init-Log {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$path
    )

    # Check if log directory exists
    if(-Not (Test-Path $path -PathType Container)) {
        New-Item -ItemType Directory -Path $path | Out-Null;
    }

    $script:LOG_PS1_LogFilePath = Join-Path $path ([string]::Format("Log_{0}.txt", (Get-Date -Format "yyyy_MM_dd").ToString()));
}

function Log-Error {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$message
    )

    Add-Content -Path $script:LOG_PS1_LogFilePath -Value ([string]::Format("[{0}]:[ERROR] - {1}", (Get-Date), $message));
}

function Log-Info {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$message
    )

    Add-Content -Path $script:LOG_PS1_LogFilePath -Value ([string]::Format("[{0}]:[INFO] - {1}", (Get-Date), $message));
}