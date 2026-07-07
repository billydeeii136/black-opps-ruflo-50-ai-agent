@echo off
setlocal
if "%~2"=="" (
  echo Usage: install.cmd ^<asset_name^> ^<binary_name^> [install_dir]
  exit /b 1
)
set "ASSET_NAME=%~1"
set "BINARY_NAME=%~2"
set "INSTALL_DIR=%~3"
if "%INSTALL_DIR%"=="" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-windows.ps1" -AssetName "%ASSET_NAME%" -BinaryName "%BINARY_NAME%"
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-windows.ps1" -AssetName "%ASSET_NAME%" -BinaryName "%BINARY_NAME%" -InstallDir "%INSTALL_DIR%"
)
