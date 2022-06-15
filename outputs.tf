##############################################################################
# Address Prefix Outputs
##############################################################################

output "list" {
  description = "List of Address Prefix Objects"
  value = [
    for prefix in ibm_is_vpc_address_prefix.address_prefixes :
    {
      name           = prefix.name
      id             = prefix.id
      zone           = prefix.zone
      address_prefix = prefix.address_prefix
    }
  ]
}

##############################################################################