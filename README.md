
# terraform-emqx-emqx-azure
Deploy emqx or emqx enterprise on azure

## Compatability

|                          | EMQX 4.4.x      | 
|--------------------------|-----------------|
| ubuntu 20.04             | ✓               | 

> **Note**

> Not support EMQX 5.x currently  
Not support TLS 


## Install terraform
Please refer to [terraform install doc](https://learn.hashicorp.com/tutorials/terraform/install-cli)


## Config azure credentials
You could follow this [guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
```bash
export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}
export ARM_TENANT_ID=${ARM_TENANT_ID}
export ARM_CLIENT_ID=${ARM_CLIENT_ID}
export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}
```

## Deploy EMQX single node
```bash
cd services/emqx
terraform init
terraform plan
terraform apply -auto-approve -var="emqx_lic=${emqx_lic}"
```


## Deploy EMQX cluster
```bash
cd services/emqx_cluster
terraform init
terraform plan
terraform apply -auto-approve -var="emqx_lic=${emqx_lic}"
```

> **Note**

> You should apply for an emqx license if you want more than 10 quotas when deploying emqx enterprise.


After applying successfully, it will output the following:

```bash
Outputs:
loadbalancer_public_ip = ${loadbalancer_public_ip}
```


You can access different services with related ports
```bash
Dashboard: ${loadbalancer_public_ip}:18083
MQTT: ${loadbalancer_public_ip}:1883
```

## Destroy
```bash
terraform destroy -auto-approve
```

