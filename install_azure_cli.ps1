param()

$ErrorActionPreference = 'Stop'

Write-Output "Checking for existing az CLI..."
$az = Get-Command az -ErrorAction SilentlyContinue
if ($az) {
    Write-Output "Azure CLI already installed at: $($az.Source)"
    az --version
    exit 0
}

Write-Output "Attempting install via winget (if available)..."
if (Get-Command winget -ErrorAction SilentlyContinue) {
    try {
        winget install --id Microsoft.AzureCLI -e --accept-package-agreements --accept-source-agreements
    } catch {
        Write-Output "winget install failed: $_"
    }
}

$az = Get-Command az -ErrorAction SilentlyContinue
if ($az) {
    Write-Output "Azure CLI installed via winget: $($az.Source)"
    az --version
    exit 0
}

Write-Output "Downloading MSI installer from official URL..."
$temp = Join-Path $env:TEMP 'AzureCLI.msi'
Invoke-WebRequest -Uri 'https://aka.ms/installazurecliwindows' -OutFile $temp -UseBasicParsing
Write-Output "Running MSI installer (may require admin/UAC)..."
try {
    Start-Process -FilePath msiexec.exe -ArgumentList "/I `"$temp`" /qn /norestart" -Wait -ErrorAction Stop
} catch {
    Write-Output "Non-elevated install failed, retrying with elevation (you will see a UAC prompt)..."
    Start-Process -FilePath msiexec.exe -ArgumentList "/I `"$temp`" /qn /norestart" -Verb RunAs -Wait
}

Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue

$az = Get-Command az -ErrorAction SilentlyContinue
if ($az) {
    Write-Output "Azure CLI successfully installed: $($az.Source)"
    az --version
    exit 0
} else {
    Write-Output "Azure CLI installation finished but 'az' not found in PATH. You may need to restart your shell."
    exit 1
}
