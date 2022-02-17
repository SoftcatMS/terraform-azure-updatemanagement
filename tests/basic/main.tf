module "updatemanagement" {
  source                        = "git@github.com:SoftcatMS/azure-terraform-updatemanageemnt"
  location                      = "uksouth"
  resource_group_name           = "rg-example-updatemanagement"
  automation_account_name       = "example-auto-acct"
  log_analytics_workspace_name  = "example-log-workspace"

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }
}