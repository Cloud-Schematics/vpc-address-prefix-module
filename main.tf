##############################################################################
# Locals
##############################################################################

locals {
  zone_map = {
    zone-1 = 1
    zone-2 = 2
    zone-3 = 3
  }
}

##############################################################################

##############################################################################
# Create a map of zones with addresses that include the name, zone
# and CIDR block for addresses
# > Name format <prefix>-zone-<zone>-<index + 1> 
##############################################################################

module "prefix_map" {
  source         = "./config_modules/list_to_map"
  key_name_field = "zone_name"
  list = [
    for zone in ["zone-1", "zone-2", "zone-3"] :
    {
      zone_name = zone
      addresses = [
        for address in(lookup(var.address_prefixes, zone, null) == null ? [] : var.address_prefixes[zone]) :
        {
          name = format("%s-%s-%s", var.prefix, zone, index(var.address_prefixes[zone], address) + 1)
          cidr = address
          zone = format("%s-%s", var.region, local.zone_map[zone])
        }
      ]
    }
  ]
}

##############################################################################

##############################################################################
# Create a map of all needed prefixes where the key is the name of the prefix
# to be created
##############################################################################

module "address_prefixes" {
  source = "./config_modules/list_to_map"
  list = flatten([
    for zone in ["zone-1", "zone-2", "zone-3"] :
    module.prefix_map.value[zone].addresses
  ])
}

##############################################################################

##############################################################################
# Create Address Prefixes
##############################################################################

resource "ibm_is_vpc_address_prefix" "address_prefixes" {
  for_each = module.address_prefixes.value
  name     = each.value.name
  vpc      = var.vpc_id
  zone     = each.value.zone
  cidr     = each.value.cidr
}

##############################################################################
