# Mount Azure File Share with storage account access keys
[CmdletBinding()]

param
(
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$AdmincredsUserName,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$AdmincredsPassword,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$StorageAccountName,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$FileShareName,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$StorageAccountKeys
)

function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

$storageAccountName = $StorageAccountName
$fileShareName = $FileShareName
$storageAccountKeys = $StorageAccountKeys

$connectTestResult = Test-NetConnection -ComputerName $("$storageAccountName.file.core.windows.net") -Port 445

if ($connectTestResult.TcpTestSucceeded) {
    $password = ConvertTo-SecureString -String $storageAccountKeys -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential -ArgumentList "AZURE\$($storageAccountName)", $password
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$($storageAccountName).file.core.windows.net\$($fileShareName)" -Credential $credential -Persist
}
else {
    Write-Output "$(Get-TimeStamp) Unable to reach the Azure storage account via port 445. Please check your network connection." | Out-File C:\FileShareMount.txt -Append
}
