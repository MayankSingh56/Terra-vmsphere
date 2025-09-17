📌 Overview

This project provisions a Linux virtual machine (VM) on a VMware vSphere environment using Terraform.
The configuration leverages:

cloudinit.tpl for first-boot customization (users, packages, SSH keys).

Variables (variable.tf) to make the setup reusable.

⚙️ Prerequisites

Before running Terraform, ensure you have:

Access to a vSphere environment (vCenter, Datacenter, Cluster, Datastore, Network).

A cloud-ready VM template (e.g., Ubuntu cloud image) already imported into vSphere.

Installed locally:

Terraform
 v1.x or later

SSH key pair (id_rsa / id_rsa.pub) for secure access

📂 Project Structure
.
├── main.tf             # Main Terraform configuration
├── variables.tf        # Input variables
├── terraform.tfvars    # Variable values (ignored by Git usually)
├── cloudinit.tpl       # Cloud-init template (VM customization)
└── README.md           # Documentation

📝 How to Use
1. Clone the repository
git clone <your-repo-url>
cd <project-directory>

2. Configure variables

Edit terraform.tfvars to provide real-life values for your environment.

3. Initialize Terraform
terraform init

4. Validate configuration
terraform validate

5. Plan the deployment
terraform plan

6. Apply changes (create VM)
terraform apply

7. Destroy VM (when no longer needed)
terraform destroy

🔑 Variables Explanation
| Variable | Description | Example Value | Must Update? |  
|---|---|---|---|  
| vsphere_server | vCenter server hostname or IP | vcenter.company.com | ✅ |  
| vsphere_user | vSphere login username | administrator@vsphere.local | ✅ |  
| vsphere_password | vSphere login password | SuperSecret!123 | ✅ |  
| datacenter | Name of the datacenter in vSphere | DC1 | ✅ |  
| cluster | Cluster where VM will be deployed | Prod-Cluster | ✅ |  
| datastore | Datastore to store the VM | Datastore1 | ✅ |  
| network | Network/PortGroup for VM | VM-Network | ✅ |  
| template_name | Pre-existing cloud template | ubuntu-22.04-cloudimg | ✅ |  
| vm_name | Name of the VM | app-server-01 | Optional |  
| vm_cpus | Number of vCPUs | 2 | Optional |  
| vm_memory | Memory in MB | 4096 | Optional |  
| ssh_public_key | SSH public key for access | ssh-rsa AAAA... | ✅ |  


🧾 Example terraform.tfvars
# vSphere connection
vsphere_server   = "vcenter.company.com"
vsphere_user     = "administrator@vsphere.local"
vsphere_password = "SuperSecret!123"

# Placement
datacenter   = "DC1"
cluster      = "Prod-Cluster"
datastore    = "Datastore1"
network      = "VM-Network"

# VM details
template_name   = "ubuntu-22.04-cloudimg"
vm_name         = "linux-test-vm"
vm_cpus         = 2
vm_memory       = 4096

# Access
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."

🔒 Security Best Practices

Never commit terraform.tfvars with real credentials into Git.

Store sensitive values (vsphere_user, vsphere_password) in a secret manager or pass them via environment variables.

Use SSH keys instead of passwords to access the VM.

--------------------------------------------------------------------------------------------------------------------------

🔹 What is template_name?

In vSphere, a template is a golden image of a virtual machine.

It’s a pre-installed, pre-configured VM image (e.g., Ubuntu, CentOS, Windows).

Templates are used to deploy new VMs quickly and consistently.

When Terraform provisions a VM, instead of installing the OS from scratch, it clones a VM from this template.
That’s why we pass the template name into Terraform as the variable template_name.

🔹 Why Cloud-Ready Templates?

Since your config uses cloud-init (cloudinit.tpl), the template must be cloud-ready:

Cloud-init must be installed in the template (so Terraform can inject users, SSH keys, packages, etc.).

VMware tools or Open VM Tools should be installed for vSphere to manage the VM properly.

For Linux, VMware usually provides cloud-ready images like:

ubuntu-22.04-cloudimg

centos-8-cloudimg

rocky-9-cloudimg

🔹 Where to find the template_name

In vSphere UI → VMs and Templates → look for the template you imported.

Use that name exactly in your terraform.tfvars.

Example:
If vSphere shows ubuntu-22.04-cloudimg in Templates, then in terraform.tfvars:

template_name = "ubuntu-22.04-cloudimg"

🔹 What if you don’t have a template?

If your vSphere doesn’t already have one:

Download a cloud image (e.g., from Ubuntu’s official site).

Import it into vSphere as a VM.

Convert it to a template.

Ensure it has cloud-init and VMware Tools installed.

Then, use that template’s name as template_name.

✅ In short:

template_name tells Terraform which golden image to clone from.

It must exist in vSphere ahead of time.

Choose a cloud-ready image (Ubuntu, CentOS, Rocky, etc.) that works with cloud-init.