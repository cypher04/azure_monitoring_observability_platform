variable "location" {
  description = "The location for the resources"
  type        = string
}

variable "vm_username" {
  description = "The username for the virtual machine"
  type        = string
}

variable "vm_password" {
  description = "The password for the virtual machine"
  type        = string
}

variable "lb_backend_address_pool_id" {
  description = "The ID of the load balancer backend address pool"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = map(string)
}