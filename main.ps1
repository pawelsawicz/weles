function CheckChocolatey(){
  $exitCode = iex "choco"
  return $exitCode.Contains("Chocolatey");
}

function DownloadProgramsFromInternet($urlToFile){
  $listOfPrograms = iex ("((new-object net.webclient).DownloadString('{0}'))" -f $urlToFile)
  $programs = $listOfPrograms.Split("`r`n")
  return $programs;
}

function DownloadProgramsFromFile(){
 $content = iex "Get-Content fakeProvisioning.txt"
 $programs = $content.Split("`r`n")
 return $programs;
}

function DownloadProgramsFake(){
  $programsToInstall = "ilspy";
  return $programsToInstall;
}

function ExcludeExistingPackages(){
  $existingPackages = iex "choco list --local-only"
  $packagesRemote = DownloadProgramsFake
}

function UpdateAllPackages(){
  $existingPackages = iex "choco list --local-only";
  $cleanedUp = $existingPackages.Split("`r`n, ``");
}

function Main($arguments){

Write-Output "===WELES==="
Write-Output "This script, will install & restore your development program";

$chocolateyCommand = "((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))";
$programsToInstall;

if([string]::IsNullOrEmpty($arguments[0])){
  Write-Output "Read form local file..."
  $programsToInstall = DownloadProgramsFromFile;
}
else{
  Write-Output "Read from internet file..."
  $programsToInstall = DownloadProgramsFromInternet($arguments[0]);
}

if(CheckChocolatey){
  Write-Output "Chocolatey installed, now installing your apps";
  foreach($program in $programsToInstall){
    Write-Output ("Installing {0}" -f $program);
    $result = (iex ("choco install {0} -y -v" -f $program))
    if(!$result -eq 0){
      Write-Output "Exit code was not 0";
    }
    else{
      Write-Output "Package was installed succesfully";
    }
  }
}
else{
  Write-Output "You don't have installed Chocolatey, it will install itself"
  iex $chocolateyCommand
  Main($arguments)
  }
}

Main($args)
