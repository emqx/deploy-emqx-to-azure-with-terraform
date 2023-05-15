# Deploy EMQX to Azure with Terraform

This project provides a Terraform script for deploying either the open-source or enterprise versions of EMQX on Microsoft Azure. EMQX is an open-source, distributed MQTT message broker for IoT applications and is designed to handle large amounts of concurrent client connections.


## Compatability

|   OS/Version | EMQX Enterprise 4.4.x | EMQX Open Source 4.4.x | EMQX Open Source 5.0.x |
|--------------|-----------------------|------------------------|------------------------|
| ubuntu 20.04 | ✓                     | ✓                      | ✓                      |


## Prerequisites

- Azure account with necessary permissions
- Terraform installed on your machine. If not, please follow this [guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Azure CLI installed and configured

## Configuration

### Azure credentials

Set up your Azure credentials by following this [guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret). After setting up, export the Azure credentials:

```bash
export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}
export ARM_TENANT_ID=${ARM_TENANT_ID}
export ARM_CLIENT_ID=${ARM_CLIENT_ID}
export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}
```

### Configuring EMQX4

To deploy EMQX version 4.4.x, provide the package URL in the emqx4_package variable. Replace ${emqx4_package_url} with your actual URL.

```bash
emqx4_package = ${emqx4_package_url}
```

### Configuring EMQX5

To deploy EMQX version 5.0.x, provide the package URL in the emqx5_package variable. Replace ${emqx5_package_url} with your actual URL.

```bash
emqx5_package = ${emqx5_package_url}
is_emqx5 = true
emqx5_core_count = 1
emqx_vm_count = 4
```

> **Note**

> The emq5_core_count should be less than or equal to emqx_vm_count. 


## Deployment

### Deploy EMQX cluster

To deploy an EMQX cluster, run the following commands:

```bash
cd services/emqx_cluster
terraform init
terraform plan
terraform apply -auto-approve
```

> **Note**

> If you want to deploy more than 10 nodes when using EMQX Enterprise, you need to apply for an EMQX license. 

Run the following command to apply the license:

``` bash
terraform apply -auto-approve -var="emqx_lic=${your_license_content}"
```

After successful deployment, you will see the following output:

```bash
Outputs:
loadbalancer_public_ip = ${loadbalancer_public_ip}
```

You can now access various services on their respective ports:

```bash
Dashboard: ${loadbalancer_public_ip}:18083
MQTT: ${loadbalancer_public_ip}:1883
MQTTS: ${loadbalancer_public_ip}:8883
WS: ${loadbalancer_public_ip}:8083
WSS: ${loadbalancer_public_ip}:8084
```

### Enable SSL/TLS

Below are some configurations for enabling SSL/TLS:


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

Run the following commands to store the CA, cert, and key to files for client connections:


``` bash
terraform output -raw tls_ca > tls_ca.pem
terraform output -raw tls_cert > tls_cert.pem
terraform output -raw tls_key > tls_key.key
```

If a client needs to verify the server's certificate chain and host name, you must configure the hosts file:

``` bash
${loadbalancer_ip} ${common_name}
```

### Cleanup

After you've finished with the EMQX cluster, you can destroy it using the following command:


```bash
terraform destroy -auto-approve
```

This will delete all resources created by Terraform in this module.

## Contribution

We welcome contributions from the community. Please submit your pull requests for bug fixes, improvements, and new features.

## License

This project is licensed under the terms of the [MIT License](https://github.com/emqx/deploy-emqx-to-azure-with-terraform/blob/main/LICENSE).

## Support

If you encounter any problems or have any questions about this module, please open an issue in the GitHub repository.


