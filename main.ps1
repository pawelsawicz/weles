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

function GetExistingPackages(){
  $existingPackages = iex "choco list --local-only"
  $matches_found = @()
  foreach ($item in $existingPackages)
  {
      if ($item -match '^([^\s]*)'){
        $matches_found += $matches[0]
      }
  }
  return $matches_found
}

function ExcludeExistingPackages($listOfPrograms){
  return @('aaaa','bbbb')
}

function UpdateAllPackages(){
  $existingPackages = iex "choco list --local-only";
  $cleanedUp = $existingPackages.Split("`r`n, ``");
}

function InstallPackage($program){
  Write-Output ("Installing {0}" -f $program);
  iex ("choco install {0} -y -v" -f $program);
  $lastExit = $LASTEXITCODE;
  if($lastExit -eq 0){
    Write-Output "Package was installed succesfully";
  }
  else{
    Write-Output "Exit code was not 0, couldn't install package!";
  }
}

function Main($arguments){

Write-Output "===WELES==="
Write-Output "This script, will install & restore your development program";

$chocolateyCommand = ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
$downloadedPrograms;

if([string]::IsNullOrEmpty($arguments[0])){
  Write-Output "Read form local file..."
  $downloadedPrograms = DownloadProgramsFromFile;
}
else{
  Write-Output "Read from internet file..."
  $downloadedPrograms = DownloadProgramsFromInternet($arguments[0]);
}

if(CheckChocolatey){
  Write-Output "Chocolatey installed, now installing your apps";
  $programsToInstall = $downloadedPrograms #ExcludeExistingPackages($downloadedPrograms)
  foreach($program in $programsToInstall){
    InstallPackage($program);
  }
}
else{
  Write-Output "You don't have installed Chocolatey, it will install itself";
  iex $chocolateyCommand
  Main($arguments)
  }
}

Main($args)
