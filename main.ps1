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
  $cleanedUp = @()
  For ($i = 0; $i -lt $matches_found.Count - 1; ++$i)
  {
      $cleanedUp += $matches_found[$i]
  }
  return $cleanedUp
}

function ExcludeExistingPackages($listOfPrograms){
  return @('aaaa','bbbb')
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

function UpgradeAllCommand(){
  Foreach ($package in GetExistingPackages)
  {
    Write-Output ("Upgrading {0}" -f $package);
    iex ("choco upgrade {0} -y -v" -f $package);
  }
}

function AddWelesToProfile(){
  $profileContent = Get-Content $PROFILE
  if(-Not $profileContent.Contains("Set-Alias weles '~\repos\weles-provisioning\main.ps1'")){
    Write-Output "Add weles to profile"
    Add-Content $PROFILE "Set-Alias weles '~\repos\weles-provisioning\main.ps1'";
  }
  else{
    Write-Output "Weles already exist in profile"
  }
}

function InstallCommand($arguments){
  $downloadedPrograms;
  if([string]::IsNullOrEmpty($arguments[1])){
    Write-Output "Read form local file..."
    $downloadedPrograms = DownloadProgramsFromFile;
  }
  else{
    Write-Output "Read from internet file..."
    $downloadedPrograms = DownloadProgramsFromInternet($arguments[1]);
  }
  Write-Output "Chocolatey installed, now installing your apps";
  $programsToInstall = $downloadedPrograms #ExcludeExistingPackages($downloadedPrograms)
  foreach($program in $programsToInstall){
    InstallPackage($program);
  }
}

function RunCommand($arguments){
  switch($arguments[0]){
    "install" {InstallCommand($arguments)}
    "check" {"Command not implemented yet"}
    "remote" {"Command not implemented yet"}
    "upgrade" {UpgradeAllCommand}
    default {"Unknown command, type -help to get an overview"}
  }
}

function Main($arguments){

Write-Output "===WELES==="
Write-Output "This script, will install & restore your development program";

$chocolateyCommand = ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
$checkChocolatey = CheckChocolatey

AddWelesToProfile

if(-Not $checkChocolatey){
  Write-Output "You don't have installed Chocolatey, it will install itself";
  iex $chocolateyCommand
  Main($arguments)
}
else{
  RunCommand($arguments)
  }
}

Main($args)
