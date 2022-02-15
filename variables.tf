variable "location" {
  type = string
  description = "Locaton to use for the deployment of resources"
}
variable "locationshortname" {
  type = string
  description = "Location three letter abbreviation"
  validation {
      condition = length (var.resource_prefix) == 3
      error_message = "The location shortname must be only 3 characters long."
    }
}