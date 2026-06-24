$folder = 'C:\Users\deepa\OneDrive\Documents\Deepak Resume\azure_terraform'
$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User')

if ([string]::IsNullOrEmpty($userPath)) {
    [Environment]::SetEnvironmentVariable('PATH', $folder, 'User')
    Write-Output "User PATH set to: $folder"
} elseif ($userPath.Split(';') -contains $folder) {
    Write-Output "Folder already in user PATH"
} else {
    [Environment]::SetEnvironmentVariable('PATH', "$userPath;$folder", 'User')
    Write-Output "Appended folder to user PATH"
}

# Update current session PATH so terraform is available now
$env:PATH = $env:PATH + ";" + $folder
Write-Output "Updated current session PATH"

# Verify terraform is runnable
try {
    terraform.exe -version
} catch {
    Write-Output "terraform not found in current session PATH"
}
