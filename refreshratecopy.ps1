Set-ExecutionPolicy RemoteSigned

Sleep 1
clear
Sleep 1

#Locates BSG launcher and executes the process

$nl = [Environment]::NewLine
Start-Process -FilePath "C:\Battlestate Games\BsgLauncher\BsgLauncher.exe"

$Tarkov = Get-Process BsgLauncher -ErrorAction SilentlyContinue


#Checks to see if it is running or not and changes directory
if ($Tarkov)

{
Sleep 1
Write-Host -ForegroundColor GREEN “BSG Launcher is currently running...”

} 

else

{
Sleep 1
Write-Host -ForegroundColor RED   “BSG Launcher is not running...”

}

#Changing to Desktop to get local.ini file

$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
cd $DesktopPath

#Detecting to see if refresh rate 60 line exists in our file

$RefreshRateLineDesktop = Get-Content local.ini| Select -Index 4
Write-Host -ForegroundColor RED "Refresh Rate line in our Desktop local.ini file:" + $RefreshRateLineDesktop

$TarkovSettingsDirectory = "C:\Users\Who\Documents\Escape from Tarkov" 
cd $TarkovSettingsDirectory

$RefreshRateLineTarkov = Get-Content local.ini| Select -Index 4
Write-Host -ForegroundColor RED "Refresh Rate line in our Tarkov Settings Folder local.ini file:" + $RefreshRateLineTarkov

if ($RefreshRateLineDesktop -eq $RefreshRateLineTarkov)
{
Write-Host -ForegroundColor GREEN "Both lines in files match!"

}

else

{
Write-Host -ForegroundColor YELLOW "Lines in files are different!"
Write-Host "Exiting program..."

#Next we will add a menu choice to 1) exit program or 2) copy the local.ini file from Desktop if it contains 60 to documents folder
 
}

Copy-Item -Path "C:\Users\Who\Desktop\local.ini" "C:\Users\Who\Documents\Escape from Tarkov"

#Beginning copy of file

Write-Host -ForegroundColor GREEN "Beginning to copy local settings file..."
Sleep 1
try {$CopyFile} 
catch {"Couldn't copy the local.ini file..."}
finally {"Copy of file succeeded..."}
Sleep 1

[void](Write-Host -ForegroundColor GREEN 'Press any key to continue...')
$nl



#Attempts to locate BsgLauncher.exe and EscapeFromTarkov.exe in task manager and tries to set process priority to high

while (get-process "BsgLauncher" -ea SilentlyContinue) 

{
Write-Host -ForegroundColor GREEN "Trying to set process priority to high..."

Sleep 10

Get-WmiObject Win32_process -filter 'name = "BsgLauncher.exe"' | foreach-object { $_.SetPriority(128) }

Get-WmiObject Win32_process -filter 'name = "EscapeFromTarkov.exe"' | foreach-object { $_.SetPriority(128) }

Sleep 10

if (Get-WmiObject Win32_process -filter 'name = "EscapeFromTarkov.exe"' | foreach-object { $_.SetPriority(128) })

{
Write-Host -ForegroundColor GREEN "Set priority to high...exiting"

Sleep 5
exit
}

}


