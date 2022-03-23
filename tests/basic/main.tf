resource "azurerm_resource_group" "rg-test-updatemanagement" {
  name     = "rg-test-updatemanagement"
  location = "uksouth"
}

module "updatemanagement" {
  source                       = "../../" #Local source only used for testing
  location                     = "uksouth"
  resource_group_name          = azurerm_resource_group.rg-test-updatemanagement.name
  automation_account_name      = "test-auto-acct"
  log_analytics_workspace_name = "test-log-workspace"

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }
  depends_on = [azurerm_resource_group.rg-test-updatemanagement]
}
