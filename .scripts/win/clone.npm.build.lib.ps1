param (
    [string]$ComponentName
)

Write-Host $ComponentName

if(-not (Test-Path -Path $componentName -PathType Container)){
    mkdir $componentName
}

$currentDirectoryName = Split-Path -Path (Get-Location) -Leaf
$cloneDirectory = "$currentDirectoryName-npm"

$cloneDirectory