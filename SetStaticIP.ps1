param($VM, $Sleep=150, $User="vagrant", $Password="vagrant", $IP, $DNS="default", $DNS2="8.8.8.8", $Prefix="24", $Eth="Ethernet", $vSwitch="vSwitch")
$Password=ConvertTo-SecureString $Password -AsPlainText -Force
$Cred=New-Object System.Management.Automation.PSCredential($User,$Password)
$ExtractIP=$IP.Split(".")[0] + "." + $IP.Split(".")[1] + "." + $IP.Split(".")[2]
$Gateway=$ExtractIP + '.1'
If ($DNS -eq "default") {
   $DNS=$Gateway 
}
Write-Host "Sleep $Sleep seconds before connect"
Start-Sleep -Seconds $Sleep
Write-Host "Start remote connection"
$Session=New-PSSession -VMName $VM -Credential $Cred
Invoke-Command -Session $Session -ArgumentList $Eth, $IP, $Prefix, $Gateway, $DNS, $DNS2 -ScriptBlock {
    param($Eth, $IP, $Prefix, $Gateway, $DNS, $DNS2)
    New-NetIPAddress -InterfaceAlias $Eth -AddressFamily "IPv4" -IPAddress $IP -PrefixLength $Prefix -DefaultGateway $Gateway
    Set-DnsClientServerAddress -InterfaceAlias $Eth -ServerAddresses ($DNS,$DNS2)
}
Remove-PSSession -Session $Session
Write-Host "Connection ends"
Get-VM $VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName $vSwitch
Write-Host "Move to vSwitch: $vSwitch"