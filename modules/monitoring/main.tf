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
    azure_monitor_metrics {
      name = "azure-monitor-metrics"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["azure-monitor-metrics"]
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics", "Microsoft-Perf", "Microsoft-Event"]
    destinations = ["log-analytics"]
  }

  data_flow {
    streams = [
      "Microsoft-ServiceMap"
    ]
    destinations = [
      "log-analytics"
    ]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor(*)\\% Processor Time",
        "\\.NET CLR LocksAndThreads(*)\\# of current logical Threads",
        "\\.NET CLR LocksAndThreads(*)\\# of current physical Threads",
        "\\.NET CLR LocksAndThreads(*)\\# of current recognized threads",
        "\\.NET CLR LocksAndThreads(*)\\# of total recognized threads",
        "\\.NET CLR LocksAndThreads(*)\\Contention Rate / sec",
        "\\.NET CLR LocksAndThreads(*)\\Current Queue Length",
        "\\.NET CLR LocksAndThreads(*)\\Queue Length / sec",
        "\\.NET CLR LocksAndThreads(*)\\Queue Length Peak",
        "\\.NET CLR LocksAndThreads(*)\\rate of recognized threads / sec",
        "\\.NET CLR LocksAndThreads(*)\\Total # of Contentions",
        "\\.NET CLR Memory(*)\\% Time in GC",
        "\\LogicalDisk(*)\\% Free Space",
        "\\LogicalDisk(*)\\Disk Bytes/sec",
        "\\LogicalDisk(*)\\Disk Read Bytes/sec",
        "\\LogicalDisk(*)\\Disk Reads/sec",
        "\\LogicalDisk(*)\\Disk Transfers/sec",
        "\\LogicalDisk(*)\\Disk Write Bytes/sec",
        "\\LogicalDisk(*)\\Disk Writes/sec",
        "\\LogicalDisk(*)\\Free Megabytes",
        "\\Memory(*)\\% Committed Bytes In Use",
        "\\Memory(*)\\Available Bytes",
        "\\Network Interface(*)\\Bytes Received/sec",
        "\\Network Interface(*)\\Bytes Sent/sec",
        "\\Network Interface(*)\\Output Queue Length",
        "\\Process(*)\\% Processor Time",
        "\\Process(*)\\Private Bytes",
        "\\Processor(_Total)\\% Processor Time",
        "\\System(*)\\Processor Queue Length"
      ]
      name = "performance-counter-datasource"
    }

    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\VmInsights\\DetailedMetrics"
      ]
      name = "VMInsightsPerfCounters"
    }

    windows_event_log {
      streams = ["Microsoft-Event"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2)]]",
        "Application!*[System[Provider[@Name='.NET Runtime'] and (Level=1 or Level=2 or Level=3)]]",
        "System!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
      name = "eventLogsDataSource"
    }

    extension {
      streams            = ["Microsoft-WindowsEvent"]
      input_data_sources = ["eventLogsDataSource"]
      extension_name     = "windows-event-extension"
      name               = "windows-datasource-extension"
    }

    extension {
      streams        = ["Microsoft-ServiceMap"]
      extension_name = "DependencyAgent"
      name           = "dependency-agent-data-source"
    }
  }
}
