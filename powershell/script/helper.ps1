function Get-Path {

    [OutputType([string])]

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$path
    )

    if($path -eq "") {
        return $path;
    }

    if($path -like "*%%SCRIPT_RELATIVE%%*") {
        $path = $path.Replace("%%SCRIPT_RELATIVE%%", "$(Split-Path $PSScriptRoot -Parent)");
    }

    return $path;
}



















function Get-RandomString {
    
    [OutputType([string])]

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][int]$length
    )

    return -Join ((48..57) + (97..122) | Get-Random -Count $length | % {[char]$_});
}

function Get-TextBetween {

    [OutputType([string[]])]

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$data,
        [Parameter(Mandatory=$true, Position=1)][string]$start,
        [Parameter(Mandatory=$true, Position=2)][string]$end,
        [Parameter(Mandatory=$true, Position=3)][string]$value
    )

    # Generate RegEx template
    [string]$template = [string]::Format("(?<=\{0}){1}(?={2})", $start, $value, $end);
    
    # Retrieve values from data
    [string[]]$values = [Regex]::Matches($data, $template);

    # Retrun values
    return $values;
}

function Replace-Server {

    [OutputType([string])]

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$data,
        [Parameter(Mandatory=$true, Position=1)][PSCustomObject]$fileServers
    )

    # Check if data is null
    if($data -eq "") {
        return $data;
    }

    # Check if data has server key word
    if($data -like "*%%FILESERVER#*") {
        # Retrieve all server indexes
        [int[]]$serverIndexes = (Get-TextBetween $data "%%FILESERVER#" "%%" "[0-9]+");
        # Check if data is found
        if($serverIndexes.Length -gt 0) {
            foreach($index in $serverIndexes) {
                if(($index - 1 -ge 0) -and ($index - 1 -lt $fileServers.Length)) {
                    $template = "%%FILESERVER#$($index)%%";
                    $data = $data.Replace($template, $fileServers[$index - 1].name);
                } else {
                    Throw-ErrorConfiguration "Information is not provided for server: $($index - 1).";
                }
            }
        } else {
            Throw-ErrorConfiguration "Failed to get server information for the path: $($data).";
        }
    }

    if($data -like "*%%SCRIPT_RELATIVE%%*") {
        $data = $data.Replace("%%SCRIPT_RELATIVE%%", "$(Split-Path $PSScriptRoot -Parent)");
    }

    return $data;
}

function Replace-Special {

    [OutputType([string])]

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$data,
        [Parameter(Mandatory=$false, Position=1)][string]$key,
        [Parameter(Mandatory=$false, Position=2)][string]$value
    )

    if($data -eq "") {
        return $data;
    }

    $data = $data.Replace($key, $value);

    return $data;
}

function Replace-Date {

    [OutputType([string])]

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$data,
        [Parameter(Mandatory=$false, Position=1)][string]$dateFormat
    )

    if($data -eq "") {
        return $data;
    }

    if($data -like "*%%CURRENTDATE%%*") {
        if($dateFormat -eq $null -or $dateFormat -eq "") { $dateFormat = "yyyyMMdd"; }
        $data = $data.Replace("%%CURRENTDATE%%", (Get-Date -Format $dateFormat).ToString());
    }
    
    if($data -like "*%%CURRENTTIME%%*") {
        if($dateFormat -eq $null -or $dateFormat -eq "") { $dateFormat = "hhmmss"; }
        $data = $data.Replace("%%CURRENTTIME%%", (Get-Date -Format $dateFormat).ToString());
    }
    
    if($data -like "*%%CURRENTDATETIME%%*") {
        if($dateFormat -eq $null -or $dateFormat -eq "") { $dateFormat = "yyyyMMddhhmmss"; }
        $data = $data.Replace("%%CURRENTDATETIME%%", (Get-Date -Format $dateFormat).ToString());
    }

    if($data -like "*%%YESTERDAY%%*") {
        if($dateFormat -eq $null -or $dateFormat -eq "") { $dateFormat = "yyyyMMdd"; }
        $data = $data.Replace("%%YESTERDAY%%", (Get-Date (Get-Date).AddDays(-1) -Format $dateFormat).ToString());
    }

    return $data;
}

function Replace-Path {

    [OutputType([string])]

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$data
    )

    if($data -eq "") {
        return $data;
    }

    if($data -like "*%%SCRIPT_RELATIVE%%*") {
        $data = $data.Replace("%%SCRIPT_RELATIVE%%", "$(Split-Path $PSScriptRoot -Parent)");
    }

    return $data;
}