##############################################################################
# Address Prefix Variables
##############################################################################

variable "prefix" {
  description = "The prefix that you would like to append to your resources"
  type        = string
  default     = "icse-dev"
}

variable "region" {
  description = "The region where VPC is provisioned"
  type        = string
  default     = "eu-de"
}

variable "vpc_id" {
  description = "ID of the VPC where address prefixes will be created"
  type        = string
}

variable "address_prefixes" {
  description = "IP range that will be defined for the VPC for a certain location. Use only with manual address prefixes."
  type = object({
    zone-1 = optional(list(string))
    zone-2 = optional(list(string))
    zone-3 = optional(list(string))
  })
  default = {
    zone-1 = null
    zone-2 = null
    zone-3 = null
  }
  validation {
    error_message = "Keys for `use_public_gateways` must be in the order `zone-1`, `zone-2`, `zone-3`."
    condition     = var.address_prefixes == null ? true : (keys(var.address_prefixes)[0] == "zone-1" && keys(var.address_prefixes)[1] == "zone-2" && keys(var.address_prefixes)[2] == "zone-3")
  }

  validation {
    error_message = "Each CIDR must be unique."
    condition = length(
      distinct([
        for zone in ["zone-1", "zone-2", "zone-3"] :
        var.address_prefixes[zone] if var.address_prefixes[zone] != null
      ])
      ) == length(
      [
        for zone in ["zone-1", "zone-2", "zone-3"] :
        var.address_prefixes[zone] if var.address_prefixes[zone] != null
      ]
    )
  }
}

##############################################################################