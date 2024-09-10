$os = Get-CimInstance Win32_OperatingSystem

if($os.Caption -notmatch "Windows"){
    Write-Host "Error: This script is only compatible with windows." -ForegroundColor Red
    Write-Host ""
    Write-Host "You can use the following npm command to run from" -NoNewline -ForegroundColor white
    Write-Host " macOs" -ForegroundColor Blue -NoNewline
    Write-Host ":" -ForegroundColor white
    Write-Host ""
    Write-Host "> npm run macos:create:lib:component:react" -ForegroundColor Blue
    exit
}

function title {
    Write-Host "*********************************************************************" -ForegroundColor white
    Write-Host "*                                                                   *" -ForegroundColor white
    Write-Host "*          Welcome to the" -ForegroundColor white -NoNewline
    Write-Host " React component" -ForegroundColor Blue -NoNewline
    Write-Host " creation wizard!          *" -ForegroundColor white
    Write-Host "*                                                                   *" -ForegroundColor white
    Write-Host "*********************************************************************" -ForegroundColor white
}

clear

title

while ($true) {
    Write-Host ""
    Write-Host "Name of the React component to create: " -ForegroundColor Blue
    $component = Read-Host

    $componentName = $component.toLower()

    if($componentName -eq ""){
        clear
        Write-Host ""
        Write-Host "Error: No component name provided. Please try again." -ForegroundColor Red
    }elseif($componentName -eq "." -or $componentName -eq "node_modules" -or $componentName -eq ".scripts" -or $componentName -eq "clear"){
        clear
        Write-Host ""
        Write-Host "Error: Invalid component name. Please choose a different name." -ForegroundColor Red
    }elseif(Test-Path -Path $componentName -PathType Container){
        clear

        $chooises = @("Choose a different name", "Overwrite the existing component", "Cancel creation")
        $option = 0
        
        while($true){
            Write-Host ""
            Write-Host "Error: A folder with the name " -NoNewline -ForegroundColor Red
            Write-Host $componentName -NoNewline -ForegroundColor white
            Write-Host " already exists. Please choose a different name." -ForegroundColor Red
    
            Write-Host ""
            Write-Host "What would you like to do?" -ForegroundColor Blue
            Write-Host ""
    
            for ($i = 0; $i -lt $chooises.Count; $i++) {
                if($option -eq $i){
                    Write-Host "> $($chooises[$i])" -ForegroundColor Magenta
                }else {
                    Write-Host "  $($chooises[$i])" -ForegroundColor white
                }
            }
    
            $key = [System.Console]::ReadKey($true).Key

            if($key -eq "UpArrow")
            {
                if ($option -le 0) {
                    $option = $chooises.Count - 1
                } else {
                    $option = $option - 1
                }
            }

            if($key -eq "DownArrow"){
                if ($option -ge $chooises.Count - 1) {
                    $option = 0
                } else {
                    $option = $option + 1
                }
            }

            if($key -eq "Enter"){
                break
            }

            if($key -eq "Escape"){
                $option = 2
                break
            }
            
            clear
        }

        if($option -eq 0){
            clear
        }

        if($option -eq 1){
            Write-Host ""
            Write-Host "Are you sure you want to overwrite the component " -ForegroundColor yellow -NoNewline
            Write-Host $componentName -NoNewline -ForegroundColor yellow
            Write-Host "?" -NoNewline -ForegroundColor yellow
            Write-Host " (y/n)" -ForegroundColor white
            $confirm = Read-Host
            if($confirm -eq "y"){
                Remove-Item -Path $componentName -Recurse -Force
                break
            }
            else{
                Write-Host ""
                Write-Host "The creation of the React component has been canceled. Bye." -ForegroundColor Red
                exit
            }
        }

        if($option -eq 2){
            Write-Host ""
            Write-Host "The creation of the React component has been canceled. Bye." -ForegroundColor Red
            exit
        }
    }
    else{
        break
    }
}

clear

if(-not (Test-Path -Path $componentName -PathType Container)){
    mkdir $componentName
}
if(-not (Test-Path -Path $componentName/src -PathType Container)){
    mkdir $ComponentName/src
}

Copy-Item -Path ./.scripts/config/_package.json -Destination $componentName/package.json
Copy-Item -Path ./.scripts/config/_vite.config.js -Destination $componentName/vite.config.js
Copy-Item -Path ./.scripts/config/_tsconfig.json -Destination $componentName/tsconfig.json

Set-Content -Path "$componentName/package.json" -Value (Get-Content "$componentName/package.json" -Raw | ForEach-Object { $_ -replace '{{component}}', $componentName })
Set-Content -Path "$componentName/vite.config.js" -Value (Get-Content "$componentName/vite.config.js" -Raw | ForEach-Object { $_ -replace '{{component}}', $componentName })

$capitalizedComponentName = $componentName.Substring(0,1).ToUpper() + $componentName.Substring(1)

$newFilePath = "$componentName/src/index.tsx"
$content = @"
import React, { ReactElement } from 'react';

export const $capitalizedComponentName = (): ReactElement => {
  return <>React component created under the name of $capitalizedComponentName</>;
};
"@

New-Item -Path $newFilePath -ItemType File -Force
Set-Content -Path $newFilePath -Value $content

$newFilePathCSS = "$componentName/src/$componentName.scss"
$contentCSS = @"
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

@import url('https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap');

// here you can incorporate all your CSS for the React component named $component_name_capitalized
"@

New-Item -Path $newFilePathCSS -ItemType File -Force
Set-Content -Path $newFilePathCSS -Value $contentCSS

$packageJsonContent = Get-Content -Path ./package.json -Raw | ConvertFrom-Json

if (-not ($packageJsonContent.scripts["win:build:$componentName"])) {
    $packageJsonContent | Add-Member -MemberType NoteProperty -Name scripts["win:build:$componentName"] -Value "cd $componentName && npm run win:build"
}

if (-not ($packageJsonContent.scripts["macos:build:$componentName"])) {
    $packageJsonContent | Add-Member -MemberType NoteProperty -Name scripts["macos:build:$componentName"] -Value "cd $componentName && npm run macos:build"
}

Set-Content -Path ./package.json -Value $packageJsonContent

Write-Host ""
Write-Host "The React component named has been successfully created " -NoNewline -ForegroundColor Green
Write-Host $componentName -ForegroundColor white