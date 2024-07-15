import-module './PowerShell/dataverse-webapi-functions.psm1' -force

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
function Connect-Dataverse
{
    param (
        [Parameter(Mandatory)] [String]$tenantID,
        [Parameter(Mandatory)] [String]$clientId,
        [Parameter(Mandatory)] [String]$clientSecret,
        [Parameter(Mandatory)] [String]$dataverseHost,
        [String]$aadHost = 'login.microsoftonline.com'
    )
    $token = Get-SpnToken -tenantID $tenantID -clientId $clientId -clientSecret $clientSecret -dataverseHost $dataverseHost -aadHost $aadHost
    return $token
}
function Get-DataverseSolutions
{
    param (
        [Parameter(Mandatory)] [String]$token,
        [Parameter(Mandatory)] [String]$dataverseHost

    )
    $response = Invoke-DataverseHttpGet -token $token -dataverseHost $dataverseHost -requestUrlRemainder 'solutions'
    return $response.value
}
function Get-DataverseSolution
{
    param (
        [Parameter(Mandatory)] [String]$token,
        [Parameter(Mandatory)] [String]$dataverseHost,
        [Parameter(Mandatory)] [String]$solutionUniqueName
    )
    $response = Invoke-DataverseHttpGet -token $token -dataverseHost $dataverseHost -requestUrlRemainder ('solutions?$filter=uniquename%20eq%20%27' + $solutionUniqueName + '%27')
    return $response.value
}
function Get-SolutionVersion
{
    param (
        [Parameter(Mandatory)] [String]$solutionName,
        [String]$folderPath = ''
    )
    if ($folderPath -eq '')
    {
        $SolutionFilePath = "src/$solutionName/Other/Solution.xml"
    }
    else {
        $SolutionFilePath = "$folderPath/src/$solutionName/Other/Solution.xml"
    }
    if (Test-Path -LiteralPath $SolutionFilePath ) 
    {
        try{
            [xml]$solutionXml = Get-Content -Path $SolutionFilePath
        }
        catch {
            write-Error $_
            break
        }
        $version = $solutionXml.ImportExportXml.SolutionManifest.Version
        return $version
    }
    else {
        write-host "$SolutionFilePath not found"
    }
    return $null
}
