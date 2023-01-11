variable "namespace" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "additional_tags" {
  type = map(string)
}

variable "vm_count" {
  type = number
}

variable "address_space" {
  type = string
}

variable "nsg_id" {
  type = string
}

variable "subnet_conf" {
  type = map(number)
}