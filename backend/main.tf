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
    endpoints                   = { s3 = "https://lrgrvdnxqvyn.compat.objectstorage.uk-london-1.oraclecloud.com" }
    shared_credentials_files    = ["../credentials/terraform-states_bucket_credentials"]
    skip_region_validation      = true
    skip_s3_checksum            = true
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
#########################
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

