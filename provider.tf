terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.0.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # set to false in production if you have valid certs
  allow_unverified_ssl = true
}
