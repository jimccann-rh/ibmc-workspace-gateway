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





