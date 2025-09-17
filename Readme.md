How to run

terraform init

terraform plan -var-file=terraform.tfvars (optional: review)

terraform apply -var-file=terraform.tfvars and confirm

After apply completes, look at the vm_ip output and SSH as:

ssh deployer@<vm_ip> -i /path/to/your-private-key

Notes / tips (short)

This only creates a Linux user inside the VM (via cloud-init). It’s the safest and simplest way to allow someone to access/operate the VM.

If you need to create ESXi host local users (on ESXi hosts) or vCenter users, that’s a slightly different step — I can add a one-liner script (govc) after you confirm which type you want (host vs vCenter). For now I left that out to keep this clean and secure.

Security: put sensitive values (passwords/keys) into a secrets manager or Terraform Cloud variables — avoid committing terraform.tfvars with secrets.