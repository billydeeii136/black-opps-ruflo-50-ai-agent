param(
  [Parameter(Mandatory = $true)]
  [string]$Repo,

  [Parameter(Mandatory = $true)]
  [string]$AssetName,

  [Parameter(Mandatory = $true)]
  [string]$BinaryName,

  [string]$InstallDir = "$env:USERPROFILE\AppData\Local\Programs\PublicCli\bin"
)

$ErrorActionPreference = "Stop"

$apiUrl = "https://api.github.com/repos/$Repo/releases/latest"
Write-Host "Fetching latest release metadata: $apiUrl"
$release = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "public-cli-installer" }

$asset = $release.assets | Where-Object { $_.name -eq $AssetName } | Select-Object -First 1
if (-not $asset) {
  throw "Could not find asset '$AssetName' in latest release of '$Repo'."
}

$tmpRoot = Join-Path $env:TEMP ("public-cli-install-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tmpRoot | Out-Null

try {
  $archivePath = Join-Path $tmpRoot $AssetName
  Write-Host "Downloading: $($asset.browser_download_url)"
  Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archivePath

  $extractDir = Join-Path $tmpRoot "extract"
  New-Item -ItemType Directory -Path $extractDir | Out-Null

  if ($AssetName -match "\.zip$") {
    Expand-Archive -Path $archivePath -DestinationPath $extractDir -Force
  } else {
    Copy-Item $archivePath (Join-Path $extractDir $BinaryName) -Force
  }

  $candidate = Get-ChildItem -Path $extractDir -Recurse -File |
    Where-Object { $_.Name -eq $BinaryName -or $_.Name -eq "$BinaryName.exe" } |
    Select-Object -First 1

  if (-not $candidate) {
    throw "Binary '$BinaryName' not found after extracting '$AssetName'."
  }

  New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
  $destName = if ($candidate.Name.ToLower().EndsWith(".exe")) { $candidate.Name } else { $BinaryName }
  $destPath = Join-Path $InstallDir $destName
  Copy-Item $candidate.FullName $destPath -Force

  if (-not $destPath.ToLower().EndsWith(".exe")) {
    $exePath = "$destPath.exe"
    Move-Item $destPath $exePath -Force
    $destPath = $exePath
  }

  $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if (-not $currentUserPath) { $currentUserPath = "" }
  $pathEntries = $currentUserPath -split ";" | Where-Object { $_ -ne "" }
  if ($pathEntries -notcontains $InstallDir) {
    $newPath = if ($currentUserPath.Trim()) { "$currentUserPath;$InstallDir" } else { $InstallDir }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Added to user PATH: $InstallDir"
  }

  Write-Host "Installed to: $destPath"
  Write-Host "Open a new terminal session to use the command."
}
finally {
  Remove-Item -Path $tmpRoot -Recurse -Force -ErrorAction SilentlyContinue
}
