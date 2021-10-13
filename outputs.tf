#output "iam_compartment" {
#   description = "compartment name, description, ocid, and parent ocid"
#   value  = { for vmid,vmdata in var.compartments : vmid => { 
#       "name" = module.iam_compartment[vmid].compartment_name, 
#       "description" = module.iam_compartment[vmid].compartment_description,
#       "ocid" = module.iam_compartment[vmid].compartment_id,
#       "parent" = module.iam_compartment[vmid].parent_compartment_id,
#     }
#   }
#}

#output "iam_subcompartment1" {
#   description = "compartment name, description, ocid, and parent ocid"
#   value = {
#     name        = module.iam_subcompartment1.compartment_name,
#     description = module.iam_subcompartment1.compartment_description,
#     ocid        = module.iam_subcompartment1.compartment_id,
#     parent      = module.iam_subcompartment1.parent_compartment_id
#   }
# }

# output "iam_subcompartment2" {
#   description = "compartment name, description, ocid, and parent ocid"
#   value = {
#     name        = module.iam_subcompartment2.compartment_name,
#     description = module.iam_subcompartment2.compartment_description,
#     ocid        = module.iam_subcompartment2.compartment_id,
#     parent      = module.iam_subcompartment1.parent_compartment_id
#   }
# }
#output "iam_users" {
#  description = "list of username and associated ocid"
#  value       = module.iam_users.name_ocid
#}

#output "iam_group" {
#  description = "group name and associated ocid"
#  value       = module.iam_group.name_ocid
#}

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

output "instance_pltfe" {
  description = "ocid of created instances."
  value       = module.instance_pltfe.instances_summary
}

output "instance_bastion" {
  description = "ocid of created bastions"
  value       = module.instance_bastion.instances_summary
}



