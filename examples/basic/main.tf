resource "azurerm_resource_group" "rg-test-updatemanagement" {
  name     = "rg-test-updatemanagement"
  location = "uksouth"
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
