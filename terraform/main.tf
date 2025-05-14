terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

provider "virtualbox" {}

# pfSense: dos interfaces, una WAN (hostonly), una LAN (interna)
resource "virtualbox_vm" "pfsense" {
  name   = "pfsense-fw"
  image  = "../boxes/pfsense.box"
  cpus   = 2
  memory = "1024 mib"
  status = "running"

  network_adapter {
    type           = "hostonly"              # WAN
    host_interface = "vboxnet0"
  }

  network_adapter {
    type           = "intnet"                # LAN interna
    host_interface = "intnet1"
  }
}

# Kali: solo interfaz interna, conectada a la LAN de pfSense
resource "virtualbox_vm" "kali" {
  name   = "kali-attacker"
  image  = "../boxes/kali.box"
  cpus   = 2
  memory = "2048 mib"
  status = "running"

  network_adapter {
    type           = "intnet"
    host_interface = "intnet1"
  }
}

# Ubuntu Server: solo interfaz interna, conectada a la LAN de pfSense
resource "virtualbox_vm" "ubuntu" {
  name   = "ubuntu-server"
  image  = "../boxes/ubuntu-server.box"
  cpus   = 2
  memory = "2048 mib"
  status = "running"

  network_adapter {
    type           = "intnet"
    host_interface = "intnet1"
  }
}

# Outputs para obtener fácilmente las IPs
output "pfsense_wan_ip" {
  value = virtualbox_vm.pfsense.network_adapter.0.ipv4_address
}

output "pfsense_lan_ip" {
  value = virtualbox_vm.pfsense.network_adapter.1.ipv4_address
}

output "kali_ip" {
  value = virtualbox_vm.kali.network_adapter.0.ipv4_address
}

output "ubuntu_ip" {
  value = virtualbox_vm.ubuntu.network_adapter.0.ipv4_address
}

