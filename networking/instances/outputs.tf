output "instance_pltfe" {
  description = "ocid of created instances."
  value       = module.instance_pltfe.instances_summary
}

output "instance_bastion" {
  description = "ocid of created bastions"
  value       = module.instance_bastion.instances_summary
}



