param(
    [Parameter (Mandatory = $true)]
    $orgURL = 'https://org12a26e6e.crm.dynamics.com/',
    [Parameter (Mandatory = $true)]
    $solutionName
)


pac solution pack -z ('release\' +$solutionName + '.zip') -f ($srcPath +'\' + $solutionName ) -p Managed
pac auth create --url $orgURL
pac solution import -p  ('release\' +$solutionName + '_managed.zip')