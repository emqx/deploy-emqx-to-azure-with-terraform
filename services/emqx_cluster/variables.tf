variable "location" {
  description = "(Required) The Azure Region where the Resource Group should exist"
  type    = string
  default = "westus"
}

variable "namespace" {
  description = "(Required) The prefix of these resources"
  type = string
  default = "emqx"
}

variable "additional_tags" {
  description = "(Optional) Additional resource tags"
  type = map(string)
  default = {}
}

variable "emqx_address_space" {
  description = "(Required) The address space that is used by the virtual network"
  type = string
  default = "10.0.0.0/16"
}

variable "subnet_conf" {
  description = "(Required) The netnum of subnet of emqx and lb"
  type = map(number)

  # Note: `value` represents the`netnum` argument in cidrsubnet function
  # Refer to https://www.terraform.io/language/functions/cidrsubnet
  default = {
    "emq" = 1,
    "lb" = 2
  }
}

variable "emqx_security_rules" {
  description = "(Required) Ingress of emqx with cidr blocks"
  type        = list(any)
  default = [
    {
      name = "ssh"
      priority = 100
      direction               = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range   = "*"
      destination_port_range     = "22"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "mqtt"
      priority = 101
      direction               = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range   = "*"
      destination_port_range     = "1883"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "mqtts"
      priority = 102
      direction               = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range   = "*"
      destination_port_range     = "8883"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "ws"
      priority = 103
      direction               = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range   = "*"
      destination_port_range     = "8083"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "wss"
      priority = 104
      direction               = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range   = "*"
      destination_port_range     = "8084"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "dashboard"
      priority = 105
      direction               = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range   = "*"
      destination_port_range     = "18083"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "outgoing"
      priority = 200
      direction               = "Outbound"
      access = "Allow"
      protocol = "*"
      source_port_range   = "*"
      destination_port_range     = "*"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "emqx_vm_count" {
  description = "(Required) The count of emqx node"
  type = number
  default = 3
}

variable "emqx_vm_size" {
  description = "(Required) The SKU which should be used for this Virtual Machine"
  type = string
  default = "Standard_F2s_v2"
}

variable "emqx_package" {
  description = "(Required) The install package of emqx"
  type = string
  default = "https://www.emqx.com/en/downloads/enterprise/4.4.14/emqx-ee-4.4.14-otp24.3.4.2-1-ubuntu20.04-amd64.zip"
}

variable "emqx_lic" {
  description = "(Optional) the content of the license"
  type        = string
  default     = ""
}

variable "lb_type" {
  description = "(Optional) Defined if the loadbalancer is private or public"
  type        = string
  default     = "public"
}

variable "lb_port" {
  description = "(Required) Protocols to be used for lb rules. Format as [frontend_port, protocol, backend_port]"
  type        = map(any)
  default     = {
    mqtt  = ["1883", "Tcp", "1883"]
    ws  = ["8083", "Tcp", "8083"]
    dashboard = ["18083", "Tcp", "18083"]
  }
}

variable "lb_probe" {
  description = "(Required) Protocols to be used for lb health probes. Format as [protocol, port, request_path]"
  type        = map(any)
  default     = {
    mqtt  = ["Tcp", "1883", ""]
    ws  = ["Tcp", "8083", ""]
    dashboard = ["Http", "18083", "/"]
  }
}