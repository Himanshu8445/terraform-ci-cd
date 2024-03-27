output "data_factory_id" {
  value = [for x in azurerm_data_factory.this : x.id]
}