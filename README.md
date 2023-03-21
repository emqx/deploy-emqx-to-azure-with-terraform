
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
terraform apply -auto-approve
```


## Deploy EMQX cluster
```bash
cd services/emqx_cluster
terraform init
terraform plan
terraform apply -auto-approve
```

> **Note**

> You should apply for an emqx license if you want more than 10 quotas when deploying emqx enterprise.  
terraform apply -auto-approve -var="emqx_lic=${your_license_content}"


After applying successfully, it will output the following:

```bash
Outputs:
loadbalancer_public_ip = ${loadbalancer_public_ip}
```


You can access different services with related ports
```bash
Dashboard: ${loadbalancer_public_ip}:18083
MQTT: ${loadbalancer_public_ip}:1883
MQTTS: ${loadbalancer_public_ip}:8883
WS: ${loadbalancer_public_ip}:8083
WSS: ${loadbalancer_public_ip}:8084
```

## Enable SSL/TLS
Some configurations for it

```bash
# default one-way SSL
enable_ssl_two_way = false
# common name for root ca
ca_common_name = "RootCA"
# common name for cert
common_name    = "Server"
# organization name
org = "EMQ"
# hours that the cert will valid for
validity_period_hours = 8760
# hours before its actual expiry time
early_renewal_hours = 720
```

Stores ca, cert and key to files for client connection

``` bash
terraform output -raw tls_ca > tls_ca.pem
terraform output -raw tls_cert > tls_cert.pem
terraform output -raw tls_key > tls_key.key
```

If a client need to verify server's certificate chain and host name, you have to config the hosts file

``` bash
${loadbalancer_ip} ${common_name}

## Destroy
```bash
terraform destroy -auto-approve
```

