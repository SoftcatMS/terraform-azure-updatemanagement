resource "azurerm_resource_group" "rg-test-updatemanagement" {
  name     = "rg-test-updatemanagement"
  location = "uksouth"
}

resource "azurerm_log_analytics_workspace" "test-log-analytics" {
  name                = "test-log-workspace"
  location            = azurerm_resource_group.rg-test-updatemanagement.location
  resource_group_name = azurerm_resource_group.rg-test-updatemanagement.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "updatemanagement" {
  source                       = "github.com/SoftcatMS/terraform-azure-updatemanagement"
  location                     = "uksouth"
  resource_group_name          = azurerm_resource_group.rg-test-updatemanagement.name
  automation_account_name      = "example-auto-acct"
  log_analytics_workspace_name = "example-log-workspace"

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }
  depends_on = [azurerm_resource_group.rg-test-updatemanagement]
}
