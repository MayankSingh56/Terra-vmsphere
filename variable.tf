# vSphere connection / provider inputs
variable "vsphere_server" {
  type = string
}

variable "vsphere_user" {
  type      = string
  sensitive = true
}

variable "vsphere_password" {
  type      = string
  sensitive = true
}

# Infrastructure placement
variable "datacenter" {
  type = string
}

variable "cluster" {
  type = string
}

variable "datastore" {
  type = string
}

variable "network" {
  type = string
}

variable "template_name" {
  type        = string
  description = "Cloud-ready template name (Ubuntu cloud image etc.)"
}

# VM configuration
variable "vm_name" {
  type    = string
  default = "simple-linux-vm"
}

variable "vm_cpus" {
  type    = number
  default = 2
}

variable "vm_memory" {
  type    = number
  default = 4096 # MB
}

# Replace with your SSH public key (recommended) or set blank to use password (less secure)
variable "ssh_public_key" {
  type    = string
  default = "ssh-rsa AAAA... replace-with-your-key"
}
