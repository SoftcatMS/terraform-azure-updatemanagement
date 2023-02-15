data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name =  var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_resource_group_name
}

resource "random_string" "random_string" {
  length  = 5
  special = false
  lower   = true
  upper   = false
  numeric = true
}

resource "azurerm_automation_account" "update_management" {
  name = "${var.automation_account_name}"
  location = var.location != null ? var.location : data.azurerm_log_analytics_workspace.log_analytics_workspace.location
  resource_group_name = data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name
  sku_name = "Basic"
  tags = var.tags
}

resource "azurerm_log_analytics_linked_service" "update_management" {
  resource_group_name = data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name
  workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  read_access_id = azurerm_automation_account.update_management.id
}

resource "azurerm_log_analytics_solution" "update_management" {
  solution_name = "Updates"
  location = var.location != null ? var.location : data.azurerm_log_analytics_workspace.log_analytics_workspace.location
  resource_group_name = data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name
  workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  workspace_name = data.azurerm_log_analytics_workspace.log_analytics_workspace.name

  plan {
    publisher = "Microsoft"
    product = "OMSGallery/Updates"
  }
}

resource "azurerm_monitor_diagnostic_setting" "update_management" {
  name = "UpdateManagement"
  target_resource_id = azurerm_automation_account.update_management.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id

  enabled_log {
    category  = "JobLogs"
  }
  enabled_log {
    category  = "JobStreams"
  }
  enabled_log {
    category  = "DscNodeStatus"
  }
  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }


}

data "azurerm_subscription" "current" {}

resource "azurerm_portal_dashboard" "patching_dashboard" {
  name                  = "patching${random_string.random_string.result}"
  resource_group_name   = data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name
  location              = var.location != null ? var.location : data.azurerm_log_analytics_workspace.log_analytics_workspace.location
  tags = {
    hidden-title = "Softcat - UM Dashboard"
  }
  dashboard_properties  = <<DASH
{
        "lenses": {
          "0": {
            "order": 0,
            "parts": {
              "0": {
                "position": {
                  "x": 0,
                  "y": 0,
                  "rowSpan": 2,
                  "colSpan": 4
                },
                "metadata": {
                  "inputs": [
                    {
                      "name": "id",
                      "value": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}/views/Updates(${data.azurerm_log_analytics_workspace.log_analytics_workspace.name})"
                    },
                    {
                      "name": "solutionId",
                      "value": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}/providers/Microsoft.OperationsManagement/solutions/Updates(${data.azurerm_log_analytics_workspace.log_analytics_workspace.name})",
                      "isOptional": true
                    },
                    {
                      "name": "timeInterval",
                      "isOptional": true
                    },
                    {
                      "name": "timeRange",
                      "binding": "timeRange",
                      "isOptional": true
                    }
                  ],
                  "type": "Extension/Microsoft_OperationsManagementSuite_Workspace/Blade/SolutionBlade/Lens/SolutionListLens/PartInstance/View"
                }
              },
              "1": {
                "position": {
                  "x": 4,
                  "y": 0,
                  "rowSpan": 2,
                  "colSpan": 2
                },
                "metadata": {
                  "inputs": [
                    {
                      "name": "workspaceId",
                      "value": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}",
                      "isOptional": true
                    },
                    {
                      "name": "automationAccountResourceId",
                      "value": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}/providers/Microsoft.Automation/automationAccounts/${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}",
                      "isOptional": true
                    },
                    {
                      "name": "virtualMachineResourceId",
                      "value": null,
                      "isOptional": true
                    },
                    {
                      "name": "virtualMachineUniqueId",
                      "isOptional": true
                    },
                    {
                      "name": "osType",
                      "value": null,
                      "isOptional": true
                    },
                    {
                      "name": "virtualMachineImageReference",
                      "isOptional": true
                    },
                    {
                      "name": "virtualMachineSupplementalInformation",
                      "isOptional": true
                    }
                  ],
                  "type": "Extension/Microsoft_Azure_Automation/PartType/MultiVMUpdateManagementBladePinnedPart",
                  "defaultMenuItemId": "updateManagementMenuItem"
                }
              },
              "2": {
                "position": {
                  "x": 6,
                  "y": 0,
                  "rowSpan": 2,
                  "colSpan": 2
                },
                "metadata": {
                  "inputs": [
                    {
                      "name": "queryInputs",
                      "value": {
                        "id": null
                      },
                      "isOptional": true
                    }
                  ],
                  "type": "Extension/Microsoft_Azure_Monitoring/PartType/AlertsManagementSummaryBladePinnedPart",
                  "defaultMenuItemId": "alertsV2"
                }
              },
              "3": {
                "position": {
                  "x": 0,
                  "y": 2,
                  "rowSpan": 7,
                  "colSpan": 6
                },
                "metadata": {
                  "inputs": [
                    {
                      "name": "ComponentId",
                      "value": {
                        "SubscriptionId": "${data.azurerm_subscription.current.subscription_id}",
                        "ResourceGroup": "${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}",
                        "Name": "${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}"
                      }
                    },
                    {
                      "name": "Query",
                      "value": "UpdateSummary\r\n| where (TimeGenerated > ago(1d))\r\n| where CriticalUpdatesMissing > 0 or SecurityUpdatesMissing > 0\r\n| summarize by Computer,CriticalUpdatesMissing,SecurityUpdatesMissing \r\n| sort by SecurityUpdatesMissing desc\r\n| render table\n"
                    },
                    {
                      "name": "Version",
                      "value": "1.0"
                    },
                    {
                      "name": "DashboardId",
                      "value": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}'/providers/Microsoft.Portal/dashboards/patching${random_string.random_string.result}"
                    },
                    {
                      "name": "PartId",
                      "value": "${random_string.random_string.result}Part1)]"
                    },
                    {
                      "name": "PartTitle",
                      "value": "Analytics"
                    },
                    {
                      "name": "PartSubTitle",
                      "value": "${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}"
                    },
                    {
                      "name": "resourceTypeMode",
                      "value": "workspace"
                    },
                    {
                      "name": "ControlType",
                      "value": "AnalyticsGrid"
                    },
                    {
                      "name": "Dimensions",
                      "isOptional": true
                    },
                    {
                      "name": "TimeRange",
                      "isOptional": true
                    },
                    {
                      "name": "SpecificChart",
                      "isOptional": true
                    }
                  ],
                  "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                  "settings": {
                    "content": {
                      "PartTitle": "Critical & Security Updates",
                      "PartSubTitle": "Last 24 Hours",
                      "Query": "UpdateSummary\n| where (TimeGenerated > ago(1d))\n| where CriticalUpdatesMissing >= 1 or SecurityUpdatesMissing >= 1\n| summarize by Computer,CriticalUpdatesMissing,SecurityUpdatesMissing \n| sort by SecurityUpdatesMissing desc\n| render table\n"
                    }
                  },
                  "asset": {
                    "idInputName": "ComponentId",
                    "type": "ApplicationInsights"
                  }
                }
              },
              "4": {
                "position": {
                  "x": 6,
                  "y": 2,
                  "rowSpan": 7,
                  "colSpan": 11
                },
                "metadata": {
                  "inputs": [
                    {
                      "name": "ComponentId",
                      "value": {
                        "SubscriptionId": "${data.azurerm_subscription.current.subscription_id}",
                        "ResourceGroup": "${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}",
                        "Name": "${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}",
                        "ResourceId": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourcegroups/${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}/providers/microsoft.operationalinsights/workspaces/${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}"
                      }
                    },
                    {
                      "name": "Query",
                      "value": "UpdateSummary | where TimeGenerated > ago(30d) and TimeGenerated < ago(1d) | summarize by Computer,TotalUpdatesMissing, bin(TimeGenerated, 1d) | render barchart kind=stacked\n"
                    },
                    {
                      "name": "Dimensions",
                      "value": {
                        "xAxis": {
                          "name": "TimeGenerated",
                          "type": "DateTime"
                        },
                        "yAxis": [
                          {
                            "name": "TotalUpdatesMissing",
                            "type": "Int32"
                          }
                        ],
                        "splitBy": [
                          {
                            "name": "Computer",
                            "type": "String"
                          }
                        ],
                        "aggregation": "Sum"
                      }
                    },
                    {
                      "name": "Version",
                      "value": "1.0"
                    },
                    {
                      "name": "DashboardId",
                      "value": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}/providers/Microsoft.Portal/dashboards/patching${random_string.random_string.result}"
                    },
                    {
                      "name": "PartId",
                      "value": "${random_string.random_string.result}Part2"
                    },
                    {
                      "name": "PartTitle",
                      "value": "Analytics"
                    },
                    {
                      "name": "PartSubTitle",
                      "value": "${data.azurerm_log_analytics_workspace.log_analytics_workspace.name}"
                    },
                    {
                      "name": "resourceTypeMode",
                      "value": "workspace"
                    },
                    {
                      "name": "ControlType",
                      "value": "AnalyticsChart"
                    },
                    {
                      "name": "SpecificChart",
                      "value": "Bar"
                    },
                    {
                      "name": "TimeRange",
                      "isOptional": true
                    }
                  ],
                  "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                  "settings": {
                    "content": {
                      "PartTitle": "Missing Updates (30d)",
                      "PartSubTitle": "${data.azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name}"
                    }
                  },
                  "asset": {
                    "idInputName": "ComponentId",
                    "type": "ApplicationInsights"
                  },
                  "filters": {
                    "MsPortalFx_TimeRange": {
                      "model": {
                        "format": "utc",
                        "granularity": "auto",
                        "relative": "30d"
                      }
                    }
                  }
                }
              }
            }
          }
        },
        "metadata": {
          "model": {
            "timeRange": {
              "value": {
                "relative": {
                  "duration": 24,
                  "timeUnit": 1
                }
              },
              "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
            }
          }
        }
      }
      DASH
}
