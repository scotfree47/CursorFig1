# Windows Setup Script
# Requires PowerShell 5.1 or later

# Error handling
$ErrorActionPreference = "Stop"

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "Please run this script as Administrator"
    exit 1
}

# Check for package manager (winget)
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Windows Package Manager (winget) is required. Please install it from the Microsoft Store."
    exit 1
}

# Install required packages
Write-Host "Installing required packages..."
winget install -e --id OpenJS.NodeJS
winget install -e --id Git.Git
winget install -e --id Python.Python.3
winget install -e --id Amazon.AWSCLI

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Create necessary directories
$cursorDir = "$env:USERPROFILE\.cursor"
$vsCodeDir = "$env:USERPROFILE\.vscode"

New-Item -ItemType Directory -Force -Path "$cursorDir\config" | Out-Null
New-Item -ItemType Directory -Force -Path "$vsCodeDir\extensions" | Out-Null

# Install global npm packages
Write-Host "Installing global npm packages..."
npm install -g typescript @typescript-eslint/parser @typescript-eslint/eslint-plugin

# Copy configurations
Write-Host "Copying configurations..."
Copy-Item -Path "config\windows\*" -Destination "$cursorDir\config" -Recurse -Force
Copy-Item -Path ".vscode\*" -Destination $vsCodeDir -Recurse -Force

# Set correct permissions
$acl = Get-Acl $cursorDir
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "$env:USERDOMAIN\$env:USERNAME",
    "FullControl",
    "ContainerInherit,ObjectInherit",
    "None",
    "Allow"
)
$acl.SetAccessRule($rule)
Set-Acl $cursorDir $acl

# Check WSL installation
$wslInstalled = $false
try {
    wsl --status | Out-Null
    $wslInstalled = $true
}
catch {
    Write-Warning "WSL is not installed. For best experience, please install WSL2"
}

Write-Host "Setup complete for Windows"
if ($wslInstalled) {
    Write-Host "WSL detected - configurations will work in both Windows and WSL environments"
}
Write-Host "Please restart your IDE for changes to take effect"
