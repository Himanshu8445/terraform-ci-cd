# # #############################################################################
# # # OUTPUTS RTs
# # #############################################################################

# output "route_table_ids" {
#   value = [for x in azurerm_route_table.this : x.id]
# }

# output "rt_ids_map" {
#   value = { for x in azurerm_route_table.this : x.name => x.id }
# }

# output "rt_subnet_ids_map" {
#   value = { for x in azurerm_route_table.this : x.name => x.subnets }
# }

# output "rt_subnet_associations" {
#   value = [for x in azurerm_subnet_route_table_association.this : x.id]
# }
