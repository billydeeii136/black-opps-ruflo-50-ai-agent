# billydeeii136/black-opps-ruflo-50-ai-agent public install
Release page: https://github.com/billydeeii136/black-opps-ruflo-50-ai-agent/releases/latest
API endpoint: https://api.github.com/repos/billydeeii136/black-opps-ruflo-50-ai-agent/releases/latest
## Web
1. Open the release page.
2. Download the asset matching your platform.
3. Extract it and run the binary.
## Mac
```bash
./install-mac.sh <asset_name> <binary_name> [install_dir]
```
## Linux
```bash
./install-linux.sh <asset_name> <binary_name> [install_dir]
```
## Lynx
```bash
./install-lynx.sh <asset_name> <binary_name> [install_dir]
```
## Windows (PowerShell)
```powershell
.\install-windows.ps1 -AssetName <asset_name> -BinaryName <binary_name> [-InstallDir <path>]
```
## Universal Unix wrapper
```bash
./install.sh <asset_name> <binary_name> [install_dir]
```
## One-liners (GitHub-style)
If these files are committed to your repo root:
```bash
curl -fsSL https://raw.githubusercontent.com/billydeeii136/black-opps-ruflo-50-ai-agent/main/install.sh | bash -s -- <asset_name> <binary_name> [install_dir]
```
```bash
wget -qO- https://raw.githubusercontent.com/billydeeii136/black-opps-ruflo-50-ai-agent/main/install.sh | bash -s -- <asset_name> <binary_name> [install_dir]
```
PowerShell download-and-run:
```powershell
iwr -useb https://raw.githubusercontent.com/billydeeii136/black-opps-ruflo-50-ai-agent/main/install-windows.ps1 -OutFile "$env:TEMP\\install-windows.ps1"; & "$env:TEMP\\install-windows.ps1" -AssetName <asset_name> -BinaryName <binary_name> [-InstallDir <path>]
```
## Package manager forms (optional)
```text
brew install <tap>/<formula>
apt install <package>
dnf install <package>
pacman -S <package>
winget install <publisher.package>
choco install <package>
scoop install <bucket>/<app>
```
