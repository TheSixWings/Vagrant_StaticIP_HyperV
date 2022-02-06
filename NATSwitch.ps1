#Use NATSwitch to set static IP
#https://superuser.com/questions/1354658/hyperv-static-ip-with-vagrant/1379582#1379582
param($VirtualMachine, $NATIP='10.0.0.1', $PrefixLength=24)
If ("NATSwitch" -in (Get-VMSwitch | Select-Object -ExpandProperty Name) -eq $FALSE) {
    Write-Host 'Creating Internal-only switch named "NATSwitch" on Windows Hyper-V host...'

    New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal

    New-NetIPAddress -IPAddress $NetIP -PrefixLength $PrefixLength -InterfaceAlias "vEthernet (NATSwitch)"

    New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix $NATIP.SubString(0,$NATIP.Length) + "0/" + $PrefixLength
}
else {
    Write-Host '"NATSwitch" for static IP configuration already exists; skipping'
}

If ($NATIP -in (Get-NetIPAddress | Select-Object -ExpandProperty IPAddress) -eq $FALSE) {
    Write-Host 'Registering new IP address ' + $NATIP + ' on Windows Hyper-V host...'

    New-NetIPAddress -IPAddress $NATIP -PrefixLength $PrefixLength -InterfaceAlias "vEthernet (NATSwitch)"
}
else {
    Write-Host '"' + $NATIP + '" for static IP configuration already registered; skipping'
}

If ($NATIP.SubString(0,$NATIP.Length) + "0/" + $PrefixLength -in (Get-NetNAT | Select-Object -ExpandProperty InternalIPInterfaceAddressPrefix) -eq $FALSE) {
    Write-Host 'Registering new NAT adapter for ' + $NATIP.SubString(0,$NATIP.Length) + "0/" + $PrefixLength + ' on Windows Hyper-V host...'

    New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix $NATIP.SubString(0,$NATIP.Length) + "0/" + $PrefixLength
}
else {
    Write-Host $NATIP.SubString(0,$NATIP.Length) + "0/" + $PrefixLength + '" for static IP configuration already registered; skipping'
}

Get-VM $VirtualMachine | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "NATSwitch"