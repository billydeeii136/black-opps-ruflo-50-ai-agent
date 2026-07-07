param(
  [Parameter(Mandatory = $true)]
  [string]$AssetName,
  [Parameter(Mandatory = $true)]
  [string]$BinaryName,
  [string]$InstallDir = "$env:USERPROFILE\AppData\Local\Programs\PublicCli\bin"
)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sharedDir = Join-Path $scriptDir "_shared"
$shared = Join-Path $sharedDir "install-public-cli-windows.ps1"
& $shared -Repo "billydeeii136/black-opps-ruflo-50-ai-agent" -AssetName $AssetName -BinaryName $BinaryName -InstallDir $InstallDir
