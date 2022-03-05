param($VM)
#Enable SR-IOV
#https://www.starwindsoftware.com/blog/automate-the-hyper-v-virtual-machine-deployment-with-powershell
Get-VMNetworkAdapter -VMName $VM | Set-VMNetworkAdapter -IovQueuePairsRequested 2 `
                                                                    -IovInterruptModeration Default `
                                                                    -IovWeight 100
Write-Host 'SR-IOV Enabled for' $VM
Get-VMNetworkAdapter -VMName $VM | Set-VMNetworkAdapterRdma -RdmaWeight 100
Get-VMNetworkAdapter -VMName $VM | Set–VMNetworkAdapter -MacAddressSpoofing off