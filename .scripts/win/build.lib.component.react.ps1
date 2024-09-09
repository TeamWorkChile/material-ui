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

clear

Write-Host "*********************************************************************" -ForegroundColor white
Write-Host "*                                                                   *" -ForegroundColor white
Write-Host "*          Welcome to the" -ForegroundColor white -NoNewline
Write-Host " React component" -ForegroundColor Blue -NoNewline
Write-Host " creation wizard!          *" -ForegroundColor white
Write-Host "*                                                                   *" -ForegroundColor white
Write-Host "*********************************************************************" -ForegroundColor white

Write-Host ""
Write-Host "Name of the React component to create: " -ForegroundColor Blue
$componentName = Read-Host

Write-Host ""
Write-Host $componentName

Write-Host ""
Write-Host "The React component named has been successfully created " -NoNewline -ForegroundColor Green
Write-Host $componentName