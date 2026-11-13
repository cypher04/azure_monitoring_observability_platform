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

variable "network-watcher-name" {
  description = "The name of the network watcher"
  type        = string
}

variable "network-watcher-rg" {
  description = "The resource group of the network watcher"
  type        = string
}