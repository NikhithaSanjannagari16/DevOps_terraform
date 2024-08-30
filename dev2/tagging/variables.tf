variable "tag_list"{
type   = list
description = "List of Mandatory tags"
default = [
    "Application",
    "CostCentre",
    "Environment",
    "ManagedBy",
    "OwnedBy",
    "SupportBy"
  ]
}