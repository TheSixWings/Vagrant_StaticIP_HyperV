HOSTNAME = "server001"
SWITCH = "vSwitch"
Vagrant.configure("2") do |config|
  config.vm.define "ubuntu2004" do |u|
    u.vm.box = "generic/ubuntu2004"
    u.vm.provider "hyperv"
    u.vm.network "public_network", bridge: SWITCH
    u.vm.synced_folder ".", "/vagrant", disabled: true
    u.vm.provider "hyperv" do |h|
      h.cpus = 2
      h.memory = 2048
      h.vmname = HOSTNAME
      h.enable_virtualization_extensions = true
      h.linked_clone = true
    end   
    u.vm.hostname = HOSTNAME
    u.vm.provision "shell" do |s|
      s.inline = 'echo rebooting'
      s.reboot = true
    end
    u.vm.provision "ansible" do |a|
      a.verbose = "v"
      a.playbook = "playbook.yaml"
    end
  end
  config.trigger.before :"VagrantPlugins::HyperV::Action::StartInstance", type: :action do |t|
    t.info = "Trigger Fired: Before-StartInstance"
    t.only_on = "ubuntu2004"
    t.run = {inline: "Powershell.exe ./EnableSRIOV.ps1 -VirtualMachine " + HOSTNAME}
  end
  config.trigger.after :"VagrantPlugins::HyperV::Action::StartInstance", type: :action do |t|
    t.info = "Trigger Fired: After-StartInstance"
    t.only_on = "ubuntu2004"
    t.run_remote = {path: "SetStaticIP.sh"}
  end
  config.trigger.before :"VagrantPlugins::HyperV::Action::WaitForIPAddress", type: :action do |t|
    t.info = "Trigger Fired: Before-WaitForIPAddress"
    t.only_on = "ubuntu2004"    
    t.run = {inline: "Powershell.exe Get-VM " + HOSTNAME + "| Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName " + SWITCH}
  end
end