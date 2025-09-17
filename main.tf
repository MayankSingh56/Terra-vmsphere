data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "net" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Render cloud-init userdata from file
data "template_file" "cloudinit" {
  template = file("${path.module}/cloudinit.tpl")
  vars = {
    username = "deployer"
    ssh_pub  = var.ssh_public_key
  }
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id

  num_cpus = var.vm_cpus
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.net.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.template.disks.0.size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.vm_name
        domain    = "local"
      }
    }
  }

  # pass cloud-init via guestinfo.userdata (base64)
  extra_config = {
    "guestinfo.userdata"          = base64encode(data.template_file.cloudinit.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }

  lifecycle {
    ignore_changes = [extra_config]
  }
}

output "vm_id" { value = vsphere_virtual_machine.vm.id }
output "vm_ip" { value = vsphere_virtual_machine.vm.default_ip_address }
