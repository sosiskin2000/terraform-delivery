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
    key                         = "networking/instances/terraform.tfstate"
    region                      = "uk-london-1"
    endpoint                    = "https://lrgrvdnxqvyn.compat.objectstorage.uk-london-1.oraclecloud.com"
    shared_credentials_file     = "../../credentials/terraform-states_bucket_credentials"
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

data "terraform_remote_state" "vcn" {
  backend = "s3"
  config = {
    bucket                      = "terraform-backend"
    key                         = "networking/vcn/terraform.tfstate"
    region                      = "uk-london-1"
    endpoint                    = "https://lrgrvdnxqvyn.compat.objectstorage.uk-london-1.oraclecloud.com"
    shared_credentials_file     = "../../credentials/terraform-states_bucket_credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

module "instance_pltfe" {
  source                     = "./modules/compute-instance"
  compartment_ocid           = var.comp_temp
  ad_number                  = var.instance_ad_number
  instance_count             = var.instance_count
  instance_display_name      = var.instance_display_name
  shape                      = var.shape
  source_ocid                = var.source_ocid
  source_type                = var.source_type
  ssh_authorized_keys        = var.ssh_authorized_keys
  assign_public_ip           = var.assign_public_ip
  subnet_ocids               = [data.terraform_remote_state.vcn.outputs.subnet_wev_ids.web_net_id]
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
  subnet_ocids               = [data.terraform_remote_state.vcn.outputs.subnet_wev_ids.bastion_net_id]
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}

