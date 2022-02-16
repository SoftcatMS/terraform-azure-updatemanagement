variable "location" {
  type = string
  description = "Azure locaton to use for the deployment of resources"
}
variable "resource_group_name" {
  type = string
  description = "Azure resource group name"
}

variable "automation_account_name"{
  type = string
  description = "Azure autaomtion account name"
}

variable "log_analytics_workspace_name" {
  type = string
  description = "Azure log analytcis worksapce name"
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    ENV = "test"
  }
}