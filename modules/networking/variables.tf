variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "The subnet prefixes of the virtual network"
  type        = map(string)
}