#Prepare Playbook based on VM name.
#ABC-TYPE-OS
param($VM = "ABC-TEST-WIN", $Ansible = "D:\Ansible")
$Count = $VM.Split("-").count
If ($Count -ne 3) {
    throw "Error: VM Name"
}
$Type = $VM.Split("-")[$Count - 2]
$OS = $VM.Split("-")[$Count - 1]
If ($OS -eq "WIN") {
    $OS = "Windows"
}
elseif ($OS -eq "LNX") {
    $OS = "Linux"
}
Write-Host "Playbook----Type: $Type, OS: $OS"
Copy-Item "$Ansible\playbook-$Type-$OS.yml" ".\playbook.yml"