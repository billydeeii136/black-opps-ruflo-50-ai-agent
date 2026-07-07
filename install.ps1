param(
  [Parameter(Mandatory = $true)]
  [string]$AssetName,
  [Parameter(Mandatory = $true)]
  [string]$BinaryName,
  [string]$InstallDir = "$env:USERPROFILE\AppData\Local\Programs\PublicCli\bin"
)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $scriptDir "install-windows.ps1") -AssetName $AssetName -BinaryName $BinaryName -InstallDir $InstallDir
