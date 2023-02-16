variable "location" {
  type        = string
  default     = null
  description = "Azure locaton to use for the deployment of resources"
}

variable "automation_account_name" {
  type        = string
  description = "Azure autaomtion account name"
}

variable "tags" {
  description = "The default tags to be applied"
  type        = map(string)

  default = {
    ENV = "test"
  }
}

variable "um_loganalytics_tag" {
  description = "The additional tag if required for the log analytics workspace"
  type        = map(string)

  default = {
    customtag = null
  }
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Exisitng Azure log analytics workspace name"
}

variable "log_analytics_resource_group_name" {
  type        = string
  description = "Resource group name of where log analytics workspace currently exists"
}
