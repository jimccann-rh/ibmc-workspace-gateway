locals {
  deploy_date = formatdate("YYYY-MM-DD", timestamp())
  ssh_key_ids = var.existing_ssh_key != "" ? [data.ibm_compute_ssh_key.existing[0].id, ibm_compute_ssh_key.project.id] : [ibm_compute_ssh_key.project.id]
  # Tags will be applied to all resources that support them.
  tags = [
    "datacenter:${var.datacenter}",
    "project:${var.project}",
    "workspace:${terraform.workspace}",
    "provider:ibm"
  ]
}


resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "null_resource" "create_private_key" {
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ssh.private_key_pem}' > ./'${var.project}'.pem
      chmod 400 ./'${var.project}'.pem
    EOT
  }
}

resource "ibm_compute_ssh_key" "project" {
  label      = "${var.project}-sshkey-gateway"
  public_key = tls_private_key.ssh.public_key_openssh
  tags       = local.tags
}


#module "ticket" {
#  depends_on      = [module.virtual-machines]
#  source          = "./modules/ticket"
#  private_vlan_id = module.vlans.private_compute_vlan.id
#  vsi_private_ip  = module.virtual-machines[0].instance_private_ip
#  datacenter      = var.datacenter
#}

module "gateway-appliances" {
  source       = "./modules/gateway-appliance"
  datacenter   = var.datacenter
  gateway_name = "${var.project}-gateway"
  domain_name  = var.domain_name
  public_vlan  = var.gateway_public_vlan 
  private_vlan = var.gateway_private_vlan
  tags         = local.tags
  ssh_key_ids  = local.ssh_key_ids
}





