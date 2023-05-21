output "runtime_nic_id" {
  value = azurerm_network_interface.runtime_farm_nic.*.id
}
