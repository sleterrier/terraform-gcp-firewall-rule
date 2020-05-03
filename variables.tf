/****************************************************************************************************************************
  Test
 ***************************************************************************************************************************/
variable network {
  description = "Network (name) to apply the rules to."
  type        = "string"
}

variable project {
  description = "The project (ID) in which the network lives."
  type        = "string"
}

variable rules {
  # See https://www.terraform.io/docs/providers/google/r/compute_firewall.html for argument reference
  description = "Map of maps defining firewall rules"
  type        = "map(map)"
}

