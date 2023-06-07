resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = "az-monitor-ws"
  location            = var.location
  resource_group_name = var.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_data_collection_rule" "rule_1" {
  name                = "log_collection_rule_1"
  location            = var.location
  resource_group_name = var.name
  #  depends_on          = [azurerm_virtual_machine_extension.ama]

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log_workspace.id
      name                  = "log-analytics"
    }
  }

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = ["log-analytics"]
  }

  data_sources {
    windows_event_log {
      streams = ["Microsoft-Event"]
      x_path_queries = ["Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]",
        "Security!*[System[(band(Keywords,13510798882111488))]]",
      "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]"]
      name = "eventLogsDataSource"
    }
  }
}
