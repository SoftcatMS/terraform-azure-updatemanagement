module "updatemanagement" {
  source                        = "git@github.com:SoftcatMS/azure-terraform-updatemanagement"
  location                      = "uksouth"
  resource_group_name           = "rg-test-updatemanagement"
  automation_account_name       = "test-auto-acct"
  log_analytics_workspace_name  = "test-log-workspace"

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }
}