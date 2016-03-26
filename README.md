# Weles

## What is it for ?
It's simple powershell script, dependency free! That manage and automate installing your packages,
so you can even keep your configuraton somewhere on the internet or locally.
All you need to have is Powershell.

## How can I provide my config ?
Simply you can provide link to any txt file or read config file from same location as this
script.

## How should my file looks like ?
Right now it's just simply list of all your programs each program in a new line.
Possibly in the future we going to develop some json-like format to support more bespoke
provisioning of your enviroment.  


#TODO :
1. ~~Install should output message of chocolatey~~
2. Updating all packages
3. Does diff on what is actually installed and source from internet
4. Create a website that gets list of programs from chocolatey.com, and simple chooser
that will allow you to choose programs to install.
5. Create landing package
6. ~~Make sure that when Chocolatey is not installed, install itself~~
