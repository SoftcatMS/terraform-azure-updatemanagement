variable "location" {
  type = string
  description = "Azure locaton to use for the deployment of resources"
}
variable "resourcegroupname" {
  type = string
  description = "Azure resource group name"
}

variable "automationaccountname"{
  type = string
  description = "Azure autaomtion account name"
}

variable "loganalyticsworkspacename" {
  type = string
  description = "Azure log analytcis worksapce name"
}