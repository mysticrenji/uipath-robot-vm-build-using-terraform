[CmdletBinding()]

param
(
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$AdmincredsUserName,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$AdmincredsPassword
)

$username = $AdmincredsUserName
$password = ConvertTo-SecureString -AsPlainText $AdmincredsPassword -Force
$Cred = New-Object System.Management.Automation.PSCredential ($username, $password)

# Install ActiveDirectory Module
Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature

### UiPath Prerequisites for Unattended and High-density robot
$isRDSHostInstalled = Get-WindowsFeature -Name  RDS-RD-Server
if ($isRDSHostinstalled.InstallState -eq "Installed") {
    Write-Host "Windows feature 'Remote Desktop Session Host' is installed" -ForegroundColor Green
}
else {
    Write-Host "Windows feature 'Remote Desktop Session Host' is not installed, proceeding with installation" -ForegroundColor Yellow`
    Add-WindowsFeature  RDS-RD-Server #Installing Remote Desktop Session Host feature  ### Prerequisite only for HD Unattended Robots
}

### Step 1) Install Chocolatey when needed
if (-not (Test-Path -Path "$env:ProgramData\Chocolatey\choco.exe" -PathType Leaf)) {
    # from https://chocolatey.org/install
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

###  Step 2) Define the array of packages you are offering
$Packages = '7zip', 'adobereader', 'cutepdf', 'tightvnc', 'splunk-universalforwarder',
'corretto11jdk', 'microsoft-edge'

###  Step 3) Install defined apps
ForEach ($Package in $Packages) {
    choco upgrade $Package -y
}
