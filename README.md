# VPC Address Prefixes

This module is used to create any number of address prefixes across any number of zones in a single VPC.

## As a module in a larger architecture

To use this module in a larger architecture without needing to pass in `ibmcloud_api_key`, remove [standalone.tf](./standalone.tf).

## Module Variables

Name             | Type                                                                                                        | Description                                                                                              | Sensitive | Default
---------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | --------- | -----------------------------------------------------------
ibmcloud_api_key | string | | `true` |
prefix           | string                                                                                                      | The prefix that you would like to append to your resources                                               |           | icse-dev
region           | string                                                                                                      | The region where VPC is provisioned                                                                      |           | eu-de
vpc_id           | string                                                                                                      | ID of the VPC where address prefixes will be created                                                     |           | 
address_prefixes | object({ zone-1 = optional(list(string)) zone-2 = optional(list(string)) zone-3 = optional(list(string)) }) | IP range that will be defined for the VPC for a certain location. Use only with manual address prefixes. |           | { zone-1 = null zone-2 = null zone-3 = null }