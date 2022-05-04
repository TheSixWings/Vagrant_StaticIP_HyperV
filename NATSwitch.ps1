#Use NATSwitch to set static IP
#https://superuser.com/questions/1354658/hyperv-static-ip-with-vagrant/1379582#1379582
#If exist "NATNetwork" in Get-NetNAT, will be removed.
param($VM, $IP='10.0.0.1', $PrefixLength=24)
$ExtractIP=$IP.Split(".")[0] + "." + $IP.Split(".")[1] + "." + $IP.Split(".")[2]
$NATIPPrefix=$ExtractIP + '.0/' + $PrefixLength
$NATIP=$ExtractIP + '.1'
if ("NATSwitch" -in (Get-VMSwitch | Select-Object -ExpandProperty Name) -eq $false) {
    Write-Host 'Creating Internal-only switch named "NATSwitch" on Windows Hyper-V host...'
    New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal
    New-NetIPAddress -IPAddress $NATIP -PrefixLength $PrefixLength -InterfaceAlias "NATSwitch"
    New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix $NATIPPrefix
}
else {
    Write-Host '"NATSwitch" for static IP configuration already exists; skipping'
}
if ($NATIP -in (Get-NetIPAddress | Select-Object -ExpandProperty IPAddress) -eq $false) {
    Write-Host 'Registering new IP address' $NATIP 'on Windows Hyper-V host...'
    New-NetIPAddress -IPAddress $NATIP -PrefixLength $PrefixLength -InterfaceAlias "vEthernet (NATSwitch)"
}
else {
    Write-Host $NATIP 'for static IP configuration already registered; skipping'
}
if ($NATIPPrefix -in (Get-NetNAT | Select-Object -ExpandProperty InternalIPInterfaceAddressPrefix) -eq $false) {
    Write-Host 'Registering new NAT adapter for' $NATIPPrefix 'on Windows Hyper-V host...' 
    if (Get-NetNAT -Name "NATNetwork") {
        Remove-NetNAT -Name "NATNetwork" -Confirm:$false
    }
    New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix $NATIPPrefix
}
else {
    Write-Host $NATIPPrefix 'for static IP configuration already registered; skipping'
}
Get-VM $VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "NATSwitch"
Write-Host 'Connected to NATSwitch'