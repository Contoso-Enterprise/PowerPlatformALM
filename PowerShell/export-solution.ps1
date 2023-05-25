param(
    [Parameter (Mandatory = $true)]
    $orgURL = 'https://org1b29da34.crm.dynamics.com',
    [Parameter (Mandatory = $true)]
    $solutionName
)
$outputPath = 'solutions'
$srcPath = 'src'
git pull
pac auth create --url $orgURL
pac solution export --name ($solutionName) --path  ($outputPath + '\' + $solutionName +'.zip') -ow
pac solution export --name ($solutionName) --path  $outputPath  + '\' + $solutionName +'_managed.zip'-m -ow
pac solution unpack -z ($outputPath+'\' +$solutionName + '.zip') -f ($srcPath +'\' + $solutionName )-p both -pca
pac auth clear

git add ($srcPath +'\' + $solutionName + '\*')
git commit -m 'update solution'
git push
