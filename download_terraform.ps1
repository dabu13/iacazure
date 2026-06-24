param()

$ErrorActionPreference = 'Stop'

$dest = 'C:\Users\deepa\OneDrive\Documents\Deepak Resume\azure_terraform'
Set-Location -LiteralPath $dest

# Query HashiCorp checkpoint API for latest Terraform version
try {
	$resp = Invoke-RestMethod -Uri 'https://checkpoint-api.hashicorp.com/v1/check/terraform' -ErrorAction Stop
	$version = $resp.current_version
	Write-Output "Latest Terraform version detected: $version"
} catch {
	Write-Output "Warning: failed to query latest version, defaulting to 1.6.4"
	$version = '1.6.4'
}

$url = "https://releases.hashicorp.com/terraform/$version/terraform_${version}_windows_amd64.zip"
$zip = 'terraform.zip'

Write-Output "Downloading $url ..."
Invoke-WebRequest -Uri $url -OutFile $zip

Write-Output "Extracting $zip ..."
Expand-Archive -LiteralPath $zip -DestinationPath '.' -Force

Write-Output "Removing $zip ..."
Remove-Item -LiteralPath $zip -Force

Write-Output "Terraform executable location:"
Get-Command .\terraform.exe | Select-Object -Property Source
