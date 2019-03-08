function Setup-FolderStructure {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][PSCustomObject]$folderStructure
    )

    # Check if root folder is provided
    if($folderStructure.root -eq $null -or $folderStructure.root -eq "") {
        throw "Root folder cannot be empty in configuration file for folder structure setup.";
    }

    # Check if root folder exists
    if(-Not (Test-Path $folderStructure.root -PathType container)) {
        throw "Folder not found: $($folderStructure.root).";
    }

    # Write-Host "[ INFO ] - Checked folder: $($folderStructure.root)" -ForeGroundColor Yellow;

    # Setup folder structure
    if($folderStructure.children.Length -ne 0) {
        Check-FolderChildFolders $folderStructure.root $folderStructure.children;
    }
}

function Check-FolderChildFolders {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][string]$parent,
        [Parameter(Mandatory=$true, Position=1)][PSCustomObject]$children
    )

    foreach($child in $children) {

        $childPath = (Join-Path $parent $child.name);
        $childPath = Replace-Date $childPath;

        if(-Not (Test-Path $childPath -PathType container)) {
            New-Item -Path $childPath -ItemType directory | Out-Null;
            #Write-Host "[ DONE ] - Created folder: $($childPath)" -ForeGroundColor Green;
        } else {
            #Write-Host "[ INFO ] - Checked folder: $($childPath)" -ForeGroundColor Yellow;
        }

        if($child.children.Length -ne 0) {
            Check-FolderChildFolders $childPath $child.children;
        }
    }
}

function Move-Folder {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)][PSCustomObject]$settings
    )

    if($settings -ne $null) {

        # Check source folder
        if($settings.sourceFolder -eq $null -or $settings.sourceFolder -eq "") {
            throw "Source folder is not specified for folder operation.";
        }

        # Check destination folder, except when operation is delete
        if($settings.action -ne "delete" -and ($settings.destinationFolder -eq $null -or $settings.destinationFolder -eq "")) {
            throw "Destination folder is not specified for file operation.";
        }

        # Get the complete path for source folder
        $settings.sourceFolder = Replace-Date $settings.sourceFolder;

        # Get the complete path for destination folder, except when operation is delete
        if($settings.action -ne "delete") {
            $settings.destinationFolder = Replace-Date $settings.destinationFolder;
        }

        if(-not (Test-Path $settings.sourceFolder)) {
            throw "Source folder '$($settings.sourceFolder)' could not be found";
        }

        if($settings.action -eq "delete") {
            Remove-Item -Path $settings.sourceFolder;
            #Write-Host ([string]::Format("[ DONE ] - Deleted folder '{0}'", $settings.sourceFolder)) -ForeGroundColor Green;
        } else {

            # Check if file exists and if should be replaced
            if(-not $settings.replaceExisting) {
                if(Test-Path $settings.destinationFolder) {
                    $settings.destinationFolder += " (" + (Get-RandomString 5) + ")";
                }
            }
            
            switch($settings.action) {

                "copy" {
                    Copy-Item -Path $settings.sourceFolder -Destination $settings.destinationFolder;
                    #Write-Host ([string]::Format("[ DONE ] - Copied folder '{0}' as '{1}'", $settings.sourceFolder, $settings.destinationFolder)) -ForeGroundColor Green;
                }

                "move" {
                    Move-Item -Path $settings.sourceFolder -Destination $settings.destinationFolder;
                    #Write-Host ([string]::Format("[ DONE ] - Moved folder '{0}' as '{1}'", $settings.sourceFolder, $settings.destinationFolder)) -ForeGroundColor Green;
                }

                default {
                    throw ([string]::Format("Unknown folder action: {0}", $settings.action));
                }
            }

        }
        
    } else {
        #Write-Host "[ FAIL ] - File action is not defined." -ForeGroundColor Red;
        throw "File action is not defined.";
    }
}



