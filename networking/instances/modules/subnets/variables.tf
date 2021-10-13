variable "netnum" {
  description = "zero-based index of the subnet when the network is masked with the newbit. use as netnum parameter for cidrsubnet function"
  default = {
    bastion = 32
    web     = 16
  }
  type = map
}

variable "newbits" {
  description = "new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function"
  default = {
    bastion = 13
    web     = 11
  }
  type = map
}

variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "vcn_id" {
  description = "vcn id where to create all resources"
  type        = string
}

variable "ig_route_id" {
  description = "ig_route_id where to create all resources"
  type        = string
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "terraform-oci"
}

variable "vcn_cidr" {
  description = "cidr block of VCN"
  type        = string
  default     = "10.0.0.0/16"
}
