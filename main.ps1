function CheckChocolatey(){
  $exitCode = iex "choco"
  return $exitCode.Contains("Chocolatey");
}

function DownloadPrograms(){
  $listOfPrograms = iex "((new-object net.webclient).DownloadString('https://gist.githubusercontent.com/pawelsawicz/5bc621534add80d48262/raw/27b0f910475f4f8c2cfaac72d62738ade198a08e/my-list-program.txt'))"
  $programs = $listOfPrograms.Split("`r`n")
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

function Main(){

Write-Output "My development provisioning"
Write-Output "This script, will install & restore your development program";

$chocolateyCommand = "((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))";

if(CheckChocolatey){
  Write-Output "Chocolatey installed, now installing your apps";
  foreach($program in DownloadProgramsFake){
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
  Main
  }
}

Main
