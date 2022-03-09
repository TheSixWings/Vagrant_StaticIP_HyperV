#For running Vagrant in WSL2 with Hyper-V as the provider
#Vagrantfile that supports to setup a static IP for Hyper-V VM.
#At boot, change to NATSwitch, configure IP within the guest OS, restart and then change back to Virtual Switch.

#define
HOSTNAME = "Server01-TEST-WIN" #Windows: -WIN / Linux: -LNX
StaticIP = "192.168.30.4"
BOX = "gusztavvargadr/windows-server"
SWITCH = "vSwitch"
Ansible = "D:\\Ansible"

Vagrant.configure("2") do |config|
  config.vm.define HOSTNAME do |u|
    u.vm.box = BOX
    u.vm.provider "hyperv"
    u.vm.network "public_network", bridge: SWITCH
    u.vm.synced_folder ".", "/vagrant", disabled: true
    u.vm.provider "hyperv" do |h|
      h.cpus = 2
      h.memory = 4096
      h.vmname = HOSTNAME
      h.enable_virtualization_extensions = true
      h.linked_clone = true
    end
    u.vm.hostname = HOSTNAME
    u.vm.provision "shell", inline: "echo Reboot_VM_to_apply_Static_IP"
    u.vm.provision "shell", reboot: true
    u.vm.provision "ansible" do |a|
      a.verbose = "v"
      a.playbook = "playbook.yml"
    end
  end
  #HyperV Triggers
  config.trigger.before :'VagrantPlugins::HyperV::Action::StartInstance', type: :action do |t|
    t.info = "Trigger Fired: Before-StartInstance"
    t.run = {inline: "Powershell.exe ./EnableSRIOV.ps1 -VM " + HOSTNAME +
                     "; Powershell.exe ./NATSwitch.ps1 -VM " + HOSTNAME + " -IP " + StaticIP}
  end
  config.trigger.after :up, :reload, :provision do |t|
    t.info = "Trigger Fired: After-Up,Reload"
    t.run = {inline: "Powershell.exe 'Get-VM " + HOSTNAME + " | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName " + SWITCH + "'" +
                      "; Powershell.exe 'Remove-Item playbook.yml'"}
  end
  #Ansible Triggers
  config.trigger.before :up, :reload, :provision do |t|
    t.info = "Trigger Fired: Before-Up,Reload,Provision"
    t.run = {inline: "Powershell.exe ./PreparePlaybook.ps1 -VM " + HOSTNAME + " -Ansible '" + Ansible + "'"}
  end
  #Linux Triggers
  config.trigger.before :reload, :halt, :provision do |t|
    t.info = "Trigger Fired: Before-Reload,Halt"
    t.only_on = /-LNX$/
    t.run_remote = {path: "SetStaticIP.sh", args: "-i " + StaticIP}
  end
  config.trigger.after :'Vagrant::Action::Builtin::SetHostname', type: :action do |t|
    t.info = "Trigger Fired: After-SetHostname"
    t.only_on = /-LNX$/
    t.run_remote = {path: "SetStaticIP.sh", args: "-i " + StaticIP}
  end
  #Windows Triggers
  config.trigger.after :'VagrantPlugins::HyperV::Action::WaitForIPAddress', type: :action do |t|
    t.info = "Trigger Fired: After-WaitForIPAddress"
    t.only_on = /-WIN$/
    t.run = {inline: "Powershell.exe ./SetStaticIP.ps1 -VM " + HOSTNAME + " -IP " + StaticIP + " -vSwitch " + SWITCH}
  end
end