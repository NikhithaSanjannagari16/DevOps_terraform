variable "ASE_envs" {
  type    = list
  default = ["nsg1", "nsg2", "nsg3"]
}

locals {
  ASE_envs = toset(var.ASE_envs)
}
