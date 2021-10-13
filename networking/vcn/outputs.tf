output "module_vcn" {
  description = "vcn and gateways information"
  value = {
    vcn_id = module.vcn.vcn_id
  }
}

output "subnet_wev_ids" {
  description = "vcn and gateways information"
  value = {
    bastion_net_id         = module.subnets.bastion_net_id
    bastion_compartment_id = module.subnets.bastion_comp_id
    web_net_id             = module.subnets.web_net_id
    web_compartment_id     = module.subnets.web_comp_id
  }
}
