#cloud-config
users:
  - name: ${username}
    gecos: Simple Deployer
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: false
    ssh_authorized_keys:
      - ${ssh_pub}

package_update: true
package_upgrade: true
packages:
  - cloud-init

runcmd:
  - [ cloud-init, status, --wait ]
  - hostnamectl set-hostname ${username}-vm
  - echo "Cloud-init finished"
