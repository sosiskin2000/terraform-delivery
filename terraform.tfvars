# provider identity parameters
api_fingerprint      = "38:32:0a:84:2b:b6:07:c6:57:99:b5:b9:67:74:66:1e"
api_private_key_path = "key.pem"
region               = "uk-london-1"
homeregion           = "uk-london-1"
tenancy_id           = "ocid1.tenancy.oc1..aaaaaaaakgbcacu75hezk4aovg6q5psc37ezdcwhc4whwri3ow4khb6xbtdq"
tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaakgbcacu75hezk4aovg6q5psc37ezdcwhc4whwri3ow4khb6xbtdq"
user_id              = "ocid1.user.oc1..aaaaaaaanjro5wkf6gurnelsaourcj24zb3swgdhj5cbuye6jqeoo2b53yxa"

# general oci parameters
compartment_id = "ocid1.tenancy.oc1..aaaaaaaakgbcacu75hezk4aovg6q5psc37ezdcwhc4whwri3ow4khb6xbtdq"
compartments = {
  "some_dev_mgmt" = { desc = "compartment for MGMT" },
  "some_dev_app"  = { desc = "compartment for App" }
}
label_prefix = "test"

# vcn parameters

create_drg               = false
internet_gateway_enabled = true
nat_gateway_enabled      = false
service_gateway_enabled  = false
vcn_cidr                 = "10.0.0.0/16"
vcn_dns_label            = "vcn"
vcn_name                 = "vcn"
tags = {
  environment = "test"
  lob         = "personal"
}

# Users
iam_users = [
  {
    name        = "alexander.stolbinko@example.com"
    description = "Alex created by terraform"
    email       = null
  },
  {
    name        = "andrey.shepel@example.com"
    description = "Andrey created by terraform"
    email       = "andrey.shepel@example.com"
  }
]

iam_policy_statements = [
  "Allow group my_oci_admins_group to read instances in compartment some_dev_app",
  "Allow group my_oci_admins_group to inspect instances in compartment some_dev_app",
]

netnum = {
  bastion = 32
  web     = 16
}

newbits = {
  bastion = 13
  web     = 8
}




# general oci parameters
#compartment_ocid = "ocid1.compartment.oc1..aaaaaaaa2cxxji4anxjd5x6gtg2tunlyrunoylsxc7oqnqx7czde2xjcu2xq"

# compute instance parameters
source_ocid = "ocid1.image.oc1.uk-london-1.aaaaaaaale63qnlvsxbcczr6wipotgxq6x7ccj7efdovifxzkcvzc6j3jd4a"

# operating system parameters
ssh_authorized_keys = "/home/opc/.ssh/authorized_keys"

# networking parameters
subnet_ocids_bastion = ["ocid1.subnet.oc1.uk-london-1.aaaaaaaahnvm2lnclb7ngff7t6fopgv4z4wtpykgj3gsc6cfzcv6vkgw6f5q"]
subnet_ocids_web     = ["ocid1.subnet.oc1.uk-london-1.aaaaaaaacnvxszultm7x2hegnu3wcwnpwclzbnx74l5dz435pim3inkilgia"]

