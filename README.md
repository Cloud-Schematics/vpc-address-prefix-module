# VPC Address Prefixes

This module is used to create any number of address prefixes across any number of zones in a single VPC.

## Module Variables

Name             | Type                                                                                                        | Description                                                                                              | Sensitive | Default
---------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | --------- | -----------------------------------------------------------
ibmcloud_api_key | string | | `true` |
prefix           | string                                                                                                      | The prefix that you would like to append to your resources                                               |           | icse-dev
region           | string                                                                                                      | The region where VPC is provisioned                                                                      |           | eu-de
vpc_id           | string                                                                                                      | ID of the VPC where address prefixes will be created                                                     |           | 
address_prefixes | object({ zone-1 = optional(list(string)) zone-2 = optional(list(string)) zone-3 = optional(list(string)) }) | IP range that will be defined for the VPC for a certain location. Use only with manual address prefixes. |           | { zone-1 = null zone-2 = null zone-3 = null }

## Example Usage

```terraform
##############################################################################
# Create VPC
##############################################################################

resource "ibm_is_vpc" "vpc" {
  name                        = var.vpc_name == null ? "${var.prefix}-vpc" : var.vpc_name
  resource_group              = var.resource_group_id
  classic_access              = var.classic_access
  address_prefix_management   = var.use_manual_address_prefixes == false ? null : "manual"
  default_network_acl_name    = var.default_network_acl_name
  default_security_group_name = var.default_security_group_name
  default_routing_table_name  = var.default_routing_table_name
  tags                        = var.tags
}

##############################################################################

##############################################################################
# Address Prefixes
##############################################################################

module "address_prefixes" {
  source           = "github.com/Cloud-Schematics/vpc-address-prefix-module"
  prefix           = var.prefix
  region           = var.region
  vpc_id           = ibm_is_vpc.vpc.id
  address_prefixes = var.address_prefixes
}

##############################################################################
```