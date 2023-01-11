<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.11.0, <4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.38.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_emqx_cluster"></a> [emqx\_cluster](#module\_emqx\_cluster) | ../../modules/emqx_cluster | n/a |
| <a name="module_emqx_lb"></a> [emqx\_lb](#module\_emqx\_lb) | ../../modules/loadbalancer | n/a |
| <a name="module_emqx_network"></a> [emqx\_network](#module\_emqx\_network) | ../../modules/network | n/a |
| <a name="module_emqx_network_security_group"></a> [emqx\_network\_security\_group](#module\_emqx\_network\_security\_group) | ../../modules/network_security_group | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_id.name](https://registry.terraform.io/providers/hashicorp/random/3.3.2/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | (Optional) Additional resource tags | `map(string)` | `{}` | no |
| <a name="input_emqx_address_space"></a> [emqx\_address\_space](#input\_emqx\_address\_space) | (Required) The address space that is used by the virtual network | `string` | `"10.0.0.0/16"` | no |
| <a name="input_emqx_lic"></a> [emqx\_lic](#input\_emqx\_lic) | (Optional) the content of the license | `string` | `""` | no |
| <a name="input_emqx_package"></a> [emqx\_package](#input\_emqx\_package) | (Required) The install package of emqx | `string` | `"https://www.emqx.com/en/downloads/enterprise/4.4.14/emqx-ee-4.4.14-otp24.3.4.2-1-ubuntu20.04-amd64.zip"` | no |
| <a name="input_emqx_security_rules"></a> [emqx\_security\_rules](#input\_emqx\_security\_rules) | (Required) Ingress of emqx with cidr blocks | `list(any)` | <pre>[<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "22",<br>    "direction": "Inbound",<br>    "name": "ssh",<br>    "priority": 100,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "1883",<br>    "direction": "Inbound",<br>    "name": "mqtt",<br>    "priority": 101,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "8883",<br>    "direction": "Inbound",<br>    "name": "mqtts",<br>    "priority": 102,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "8083",<br>    "direction": "Inbound",<br>    "name": "ws",<br>    "priority": 103,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "8084",<br>    "direction": "Inbound",<br>    "name": "wss",<br>    "priority": 104,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "18083",<br>    "direction": "Inbound",<br>    "name": "dashboard",<br>    "priority": 105,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "*",<br>    "direction": "Outbound",<br>    "name": "outgoing",<br>    "priority": 200,<br>    "protocol": "*",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  }<br>]</pre> | no |
| <a name="input_emqx_vm_count"></a> [emqx\_vm\_count](#input\_emqx\_vm\_count) | (Required) The count of emqx node | `number` | `3` | no |
| <a name="input_emqx_vm_size"></a> [emqx\_vm\_size](#input\_emqx\_vm\_size) | (Required) The SKU which should be used for this Virtual Machine | `string` | `"Standard_F2s_v2"` | no |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port) | (Required) Protocols to be used for lb rules. Format as [frontend\_port, protocol, backend\_port] | `map(any)` | <pre>{<br>  "dashboard": [<br>    "18083",<br>    "Tcp",<br>    "18083"<br>  ],<br>  "mqtt": [<br>    "1883",<br>    "Tcp",<br>    "1883"<br>  ],<br>  "ws": [<br>    "8083",<br>    "Tcp",<br>    "8083"<br>  ]<br>}</pre> | no |
| <a name="input_lb_probe"></a> [lb\_probe](#input\_lb\_probe) | (Required) Protocols to be used for lb health probes. Format as [protocol, port, request\_path] | `map(any)` | <pre>{<br>  "dashboard": [<br>    "Http",<br>    "18083",<br>    "/"<br>  ],<br>  "mqtt": [<br>    "Tcp",<br>    "1883",<br>    ""<br>  ],<br>  "ws": [<br>    "Tcp",<br>    "8083",<br>    ""<br>  ]<br>}</pre> | no |
| <a name="input_lb_type"></a> [lb\_type](#input\_lb\_type) | (Optional) Defined if the loadbalancer is private or public | `string` | `"public"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the Resource Group should exist | `string` | `"westus"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Required) The prefix of these resources | `string` | `"emqx"` | no |
| <a name="input_subnet_conf"></a> [subnet\_conf](#input\_subnet\_conf) | (Required) The netnum of subnet of emqx and lb | `map(number)` | <pre>{<br>  "emq": 1,<br>  "lb": 2<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer_private_ip"></a> [loadbalancer\_private\_ip](#output\_loadbalancer\_private\_ip) | The private ip address for loadbalancer resource |
| <a name="output_loadbalancer_public_ip"></a> [loadbalancer\_public\_ip](#output\_loadbalancer\_public\_ip) | The public ip address for loadbalancer resource |
<!-- END_TF_DOCS -->