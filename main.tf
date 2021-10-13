# Version requirements

terraform {
  required_version = ">= 0.13"
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">=4.0.0"
    }
  }
  backend "s3" {
    bucket                      = "terraform-backend"
    key                         = "networking/terraform.tfstate"
    region                      = "uk-london-1"
    endpoint                    = "https://lrgrvdnxqvyn.compat.objectstorage.uk-london-1.oraclecloud.com"
    shared_credentials_file     = "credentials/terraform-states_bucket_credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }


}

provider "oci" {
  tenancy_ocid         = var.tenancy_id
  user_ocid            = var.user_id
  fingerprint          = var.api_fingerprint
  private_key_path     = var.api_private_key_path
  region               = var.region
  disable_auto_retries = false
}
#########################
# Initial commit code
data "oci_objectstorage_namespace" "ns" {}

output "namespace" {
  value = data.oci_objectstorage_namespace.ns.namespace
}

resource "oci_objectstorage_namespace_metadata" "namespace-metadata" {
  namespace                    = data.oci_objectstorage_namespace.ns.namespace
  default_s3compartment_id     = var.tenancy_ocid
  default_swift_compartment_id = var.tenancy_ocid
}

data "oci_objectstorage_namespace_metadata" "namespace-metadata" {
  namespace = data.oci_objectstorage_namespace.ns.namespace
}

output "namespace-metadata" {
  value = <<EOF

  namespace = ${data.oci_objectstorage_namespace_metadata.namespace-metadata.namespace}
  default_s3compartment_id = ${data.oci_objectstorage_namespace_metadata.namespace-metadata.default_s3compartment_id}
  default_swift_compartment_id = ${data.oci_objectstorage_namespace_metadata.namespace-metadata.default_swift_compartment_id}
EOF
}
resource "oci_objectstorage_bucket" "bucket" {
  count          = 1
  compartment_id = var.tenancy_ocid
  name           = "terraform-backend"
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  access_type    = "NoPublicAccess"

  lifecycle {
    prevent_destroy = true
  }
}


module "vcn" {
  source                   = "./modules/vcn"
  compartment_id           = var.compartment_id
  label_prefix             = var.label_prefix
  tags                     = var.tags
  create_drg               = var.create_drg
  internet_gateway_enabled = var.internet_gateway_enabled
  lockdown_default_seclist = var.lockdown_default_seclist
  nat_gateway_enabled      = var.nat_gateway_enabled
  service_gateway_enabled  = var.service_gateway_enabled
  vcn_cidr                 = var.vcn_cidr
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name
  drg_display_name         = var.drg_display_name
}

module "subnets" {
  source         = "./modules/subnets"
  vcn_id         = module.vcn.vcn_id
  ig_route_id    = module.vcn.ig_route_id
  compartment_id = var.compartment_id
  netnum         = var.netnum
  newbits        = var.newbits
}

module "instance_pltfe" {
  source                     = "./modules/compute-instance"
  compartment_ocid           = var.compartment_id
  ad_number                  = var.instance_ad_number
  instance_count             = var.instance_count
  instance_display_name      = var.instance_display_name
  shape                      = var.shape
  source_ocid                = var.source_ocid
  source_type                = var.source_type
  ssh_authorized_keys        = var.ssh_authorized_keys
  assign_public_ip           = var.assign_public_ip
  subnet_ocids               = [module.subnets.web_net_id]
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}

module "instance_bastion" {
  source                     = "./modules/compute-instance"
  compartment_ocid           = var.compartment_id
  ad_number                  = var.instance_ad_number
  instance_count             = var.instance_count
  instance_display_name      = var.instance_display_name
  shape                      = var.shape
  source_ocid                = var.source_ocid
  source_type                = var.source_type
  ssh_authorized_keys        = var.ssh_authorized_keys
  assign_public_ip           = var.assign_public_ip
  subnet_ocids               = [module.subnets.bastion_net_id]
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}

