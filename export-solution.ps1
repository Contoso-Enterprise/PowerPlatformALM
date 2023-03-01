$orgURL = 'https://org1b29da34.crm.dynamics.com'
$solutionName = 'ContosoJokesGenerator'
$outputPath = 'solutions'
$srcPath = 'src'
pac auth create --url $orgURL
pac solution export --name ($solutionName) --path  $outputPath + '\' + $solutionName +'.zip'
pac solution export --name ($solutionName) --path  $outputPath  + '\' + $solutionName +'_managed.zip'-m
pac solution unpack -z ($outputPath+'\' +$solutionName + '.zip') -f ($srcPath +'\' + $solutionName )-p both

pac solution pack -z ('release\' +$solutionName + '.zip') -f ($srcPath +'\' + $solutionName ) -p Managed
pac auth clear
pac auth create --url 'destination url'
pac solution import -p  ('release\' +$solutionName + '_managed.zip')