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
    key                         = "networking/vcn/terraform.tfstate"
    region                      = "uk-london-1"
    endpoints                   = { s3 = "https://lrgrvdnxqvyn.compat.objectstorage.uk-london-1.oraclecloud.com" }
    shared_credentials_files    = ["../../credentials/terraform-states_bucket_credentials"]
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    use_path_style              = true
    skip_requesting_account_id  = true  
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


