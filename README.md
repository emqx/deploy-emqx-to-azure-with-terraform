
# terraform-emqx-emqx-azure
Deploy emqx or emqx enterprise on azure

> **Note**

> Not support EMQX 5.x currently  
Not support TLS

## Default configurations
EMQX: EMQX Enterprise 4.4.12
azure Region: westus

> **Note**

> Due to ubuntu 20.04 of node installed, you need to use emqx package associated with the corresponding os version.


## Install terraform
Please refer to [terraform install doc](https://learn.hashicorp.com/tutorials/terraform/install-cli)


## azure AccessKey Pair
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
terraform apply -auto-approve
```


## Deploy EMQX cluster
```bash
cd services/emqx_cluster
terraform init
terraform plan
terraform apply -auto-approve -var="ee_lic=${ee_lic}"
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

