param(
    [string]$device = '',
    [string]$domain = '',
    [string]$username = '',
    [string]$password = ''
    )

$combination = $domain + "\" + $username
$pass = ConvertTo-SecureString -AsPlainText $password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $combination,$pass

Invoke-Command -ComputerName $device -ScriptBlock {

$physicaldisks = Get-PhysicalDisk 

Write-Host 	"<prtg>"

foreach ($physicaldisk in $physicaldisks) {

$deviceid = $physicaldisk.DeviceId
$wear = Get-StorageReliabilityCounter -PhysicalDisk $physicaldisk | Select -ExpandProperty "wear"

Write-Host 	"<result>" 
		"<channel>$deviceid</channel>" 
		"<value>$wear</value>"
		"<LimitMaxError>20</LimitMaxError>"
		"<LimitMode>1</LimitMode>"
		"</result>"
}
Write-Host 	"</prtg>"

}-credential $cred -ArgumentList $device