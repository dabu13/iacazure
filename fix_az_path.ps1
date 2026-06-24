$ErrorActionPreference = 'Stop'

Write-Output "Searching common install locations for az..."
$searchPaths = @(
  'C:\Program Files',
  'C:\Program Files (x86)',
  'C:\ProgramData',
  'C:\Users\deepa\AppData\Local\Programs',
  'C:\Users\deepa\AppData\Local\Microsoft\WindowsApps'
)

$found = @()
foreach ($p in $searchPaths) {
  if (Test-Path $p) {
    try {
      $items = Get-ChildItem -Path $p -Filter 'az.*' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^az(\\.exe|\\.cmd|\\.ps1)?$' }
      foreach ($it in $items) { $found += $it.FullName }
    } catch { }
  }
}

if ($found.Count -eq 0) {
  Write-Output "No az executables found in common paths."
  Write-Output "If installation completed, try restarting your shell or Windows."
  exit 1
}

Write-Output "Found the following az files:"
$found | ForEach-Object { Write-Output " - $_" }


# Prefer candidates that look like Azure CLI installs (contain Azure, CLI2, wbin)
$preferred = $found | Where-Object { $_ -match 'Azure|CLI2|wbin|AzureCLI' }
if ($preferred.Count -gt 0) {
  $first = $preferred | Select-Object -First 1
} else {
  $first = $found | Select-Object -First 1
}

$dir = Split-Path -Path $first -Parent
Write-Output "Using path: $dir"

# Build a new User PATH that places the Azure CLI dir first (to override WindowsApps shims)
$userPath = [Environment]::GetEnvironmentVariable('PATH','User')
$existing = @()
if (-not [string]::IsNullOrWhiteSpace($userPath)) { $existing = $userPath.Split(';') | Where-Object { $_ -ne '' } }
$newList = @($dir) + ($existing | Where-Object { $_ -ne $dir })
$newUserPath = $newList -join ';'

[Environment]::SetEnvironmentVariable('PATH', $newUserPath, 'User')
Write-Output "Prepended $dir to User PATH (if not already present)."

# Update current session PATH by prepending
$env:PATH = "$dir;$env:PATH"
Write-Output "Updated current session PATH. Verifying 'az --version'..."

try {
  az --version
  exit 0
} catch {
  Write-Output "'az' still not found in current session; please restart your shell or log out/in."
  exit 1
}
