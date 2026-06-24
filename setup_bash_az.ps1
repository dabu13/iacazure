$bashrc = "$HOME\.bashrc"

$azPath = 'export PATH="/c/Program Files/Microsoft SDKs/Azure/CLI2/wbin:$PATH"'

if (Test-Path $bashrc) {
  $content = Get-Content -LiteralPath $bashrc -Raw
  if ($content -notmatch [regex]::Escape("/c/Program Files/Microsoft SDKs/Azure/CLI2/wbin")) {
    Add-Content -LiteralPath $bashrc -Value "`n# Azure CLI path`n$azPath"
    Write-Output "Added Azure CLI path to existing ~/.bashrc"
  } else {
    Write-Output "Azure CLI path already in ~/.bashrc"
  }
} else {
  Set-Content -LiteralPath $bashrc -Value @(
    '# Bash profile for Git Bash'
    '# Azure CLI path'
    $azPath
  ) -Encoding UTF8
  Write-Output "Created ~/.bashrc with Azure CLI path"
}

Write-Output "Restart your bash shell or run: source ~/.bashrc"
