function Install-Pac-Cli{
	param(
        [Parameter()] [String]$nugetPackageVersion		
	)
    $nugetPackage = "Microsoft.PowerApps.CLI"
    $outFolder = "pac"
    if($nugetPackageVersion -ne '') {
        nuget install $nugetPackage -Version $nugetPackageVersion -OutputDirectory $outFolder
    }
    else {
        nuget install $nugetPackage -OutputDirectory $outFolder
    }
    $pacNugetFolder = Get-ChildItem $outFolder | Where-Object {$_.Name -match $nugetPackage + "."}
    $pacPath = $pacNugetFolder.FullName + "\tools"
    Write-Host "##vso[task.setvariable variable=pacPath]$pacPath"	
}
<#
This function copies the generated package deployer file (i.e., pdpkg.zip).
Moves the file to ReleaseAssets folder.
#>
function Copy-Pdpkg-File{
    param (
        [Parameter(Mandatory)] [String]$appSourcePackageProjectPath,
        [Parameter(Mandatory)] [String]$packageFileName,
        [Parameter(Mandatory)] [String]$appSourceAssetsPath,
        [Parameter(Mandatory)] [String]$binPath
    )

    Write-Host "pdpkg file found under $appSourcePackageProjectPath\$binPath"
    Write-Host "Copying pdpkg.zip file to $appSourceAssetsPath\$packageFileName"
            
    Get-ChildItem "$appSourcePackageProjectPath\$binPath" -Filter *pdpkg.zip | Copy-Item -Destination "$appSourceAssetsPath\$packageFileName" -Force -PassThru
    # Copy pdpkg.zip file to ReleaseAssets folder
    if(Test-Path "$releaseAssetsDirectory"){
        Write-Host "Copying pdpkg file to Release Assets Directory"
        Get-ChildItem "$appSourcePackageProjectPath\$binPath" -Filter *pdpkg.zip | Copy-Item -Destination "$releaseAssetsDirectory" -Force -PassThru
    }
    else{
        Write-Host "Release Assets Directory is unavailable to copy pdpkg file; Path - $releaseAssetsDirectory"
    }
}