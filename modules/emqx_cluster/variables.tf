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

variable "nic_ids" {
  type = list
}

variable "vm_count" {
  type = number
}

variable "vm_size" {
  type = string
}

variable "emqx_package" {
  type = string
}

variable "emqx_lic" {
  type = string
}