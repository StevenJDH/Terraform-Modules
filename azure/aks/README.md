# Azure AKS Module

## Usage

```hcl
module "public_aks" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/aks?ref=main"

  cluster_name                 = "aks-public-example-dev"
  kubernetes_version           = "1.23"
  create_resource_group        = true
  resource_group_name          = "rg-public-aks-example-dev"
  location                     = "West Europe"
  dns_prefix                   = "public-aks"
  # Ensure that the OIDC Issuer feature flag is enabled first. See details below for more info.
  enable_oidc_issuer           = true
  enable_ssh_access            = true
  save_ssh_private_key_locally = true

  create_log_analytics_workspace_and_container_insights = true
  log_analytics_workspace_name = "log-public-aks-example-workspace-dev"

  network_profile = {
    network_plugin = "kubenet"
    network_policy = "calico"
  }
  
  default_node_pool = {
    name    = "defaultgru"
    vm_size = "Standard_D2_v2"
  }
  
  secondary_node_pools = [
    {
      name    = "minion"
      vm_size = "Standard_DS2_v2"
    },
  ]
}

module "private_aks" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/aks?ref=main"

  cluster_name              = "aks-private-example-dev"
  kubernetes_version        = "1.23"
  enable_private_cluster    = true
  create_resource_group     = true
  resource_group_name       = "rg-private-aks-example-dev"
  location                  = "West Europe"
  dns_prefix                = "private-aks"
  # Ensure that the OIDC Issuer feature flag is enabled first. See details below for more info.
  enable_oidc_issuer        = true

  create_log_analytics_workspace_and_container_insights = true
  log_analytics_workspace_name = "log-private-aks-example-workspace-dev"

  network_profile = {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = "10.100.0.0/16"
    dns_service_ip     = "10.100.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }
  
  default_node_pool = {
    name                = "defaultgru"
    vm_size             = "Standard_D2_v2"
    vnet_subnet_id      = data.azurerm_subnet.selected.id
    node_count          = 1
    enable_auto_scaling = false
    scaling_min_count   = 1
    scaling_max_count   = 1
  }
  
  secondary_node_pools = [
    {
      name                = "minion"
      node_count          = 1
      vm_size             = "Standard_DS2_v2"
      vnet_subnet_id      = data.azurerm_subnet.selected.id
      os_type             = "Linux"
      enable_auto_scaling = false
      scaling_min_count   = 1
      scaling_max_count   = 1
      node_taints         = []
    },
  ]
}
```

## Enable OIDC Issuer feature flag
Enabling the OIDC Issuer URL of the Microsoft.ContainerService provider allows the API server to discover public signing keys. This feature is still in preview, and since Terraform has issues with trying to register this via the `azurerm_resource_provider_registration` resource, this feature will have to be registered manually before running the Terraform script if needed. To enable, use the following commands:

```bash
# Register the OIDC Issuer feature:
az feature register --name EnableOIDCIssuerPreview --namespace Microsoft.ContainerService

# Wait around 15 minutes, and check to see if the `Registering` state changes to `Registered` with this command:
az feature list -o table --query "[?contains(name, 'EnableOIDCIssuerPreview')].{Name:name,State:properties.state}"

# After, if state says `Registered`, run the following required command to get the change propagated.
az provider register -n Microsoft.ContainerService
```

After the above steps, this feature can be enabled via `enable_oidc_issuer` in the AKS module, and used for things like Azure AD Workload Identities.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_log_analytics_solution.container-insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks-acr-pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.private-aks-network-contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_blob.ssh-private-key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [local_sensitive_file.ssh-private-key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_container_registry_id"></a> [attach\_container\_registry\_id](#input\_attach\_container\_registry\_id) | The Azure container registry id to attach to the Kubernetes Cluster with AcrPull role. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_cluster_sku_tier"></a> [cluster\_sku\_tier](#input\_cluster\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). | `string` | `"Free"` | no |
| <a name="input_create_log_analytics_workspace_and_container_insights"></a> [create\_log\_analytics\_workspace\_and\_container\_insights](#input\_create\_log\_analytics\_workspace\_and\_container\_insights) | Indicates whether or not to create a log analytics workspace with container insights enabled. | `bool` | `true` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Indicates whether or not to create a resource group. | `bool` | `true` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | The default node pool configuration. Changes to vm\_size forces a rebuild of AKS. | <pre>object({<br>    name                = optional(string, "default")<br>    vm_size             = string<br>    vnet_subnet_id      = optional(string)<br>    node_count          = optional(number, 1)<br>    enable_auto_scaling = optional(bool, false)<br>    scaling_min_count   = optional(number, 1)<br>    scaling_max_count   = optional(number, 1)<br>  })</pre> | <pre>{<br>  "enable_auto_scaling": false,<br>  "name": "default",<br>  "node_count": 1,<br>  "scaling_max_count": 1,<br>  "scaling_min_count": 1,<br>  "vm_size": "Standard_D2_v2",<br>  "vnet_subnet_id": null<br>}</pre> | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created. | `string` | `"aks"` | no |
| <a name="input_enable_http_application_routing"></a> [enable\_http\_application\_routing](#input\_enable\_http\_application\_routing) | Indicates whether or not to enable HTTP Application Routing (managed NGiNX controller.) This is not meant for production use cases. | `bool` | `false` | no |
| <a name="input_enable_oidc_issuer"></a> [enable\_oidc\_issuer](#input\_enable\_oidc\_issuer) | Indicates whether or not to enable the OIDC issuer URL. This is needed for things like Workload Identities. OIDC issuer URL requires that the Preview Feature Microsoft.ContainerService/EnableOIDCIssuerPreview is enabled and the Provider is re-registered to get the change propagated. | `bool` | `false` | no |
| <a name="input_enable_only_critical_addons"></a> [enable\_only\_critical\_addons](#input\_enable\_only\_critical\_addons) | Indicates whether or not to taint default node pool with CriticalAddonsOnly=true:NoSchedule taint. Requires at least one secondary node pool. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_enable_private_cluster"></a> [enable\_private\_cluster](#input\_enable\_private\_cluster) | Indicates whether or not to provide a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. | `bool` | `false` | no |
| <a name="input_enable_ssh_access"></a> [enable\_ssh\_access](#input\_enable\_ssh\_access) | Indicates whether or not to provide access for SSH communication to the linux nodes. If set to true, ensure that the Terraform state file is stored on encrypted storage like an Azure container with server-side encryption enabled to better protect the SSH private key in the state file. | `bool` | `false` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). Minor version aliases such as 1.22 are also supported. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of the log analytics workspace, which has to be globally unique. Required if workspace is being created. | `string` | `null` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | Log analytics workspace SKU. | `string` | `"PerGB2018"` | no |
| <a name="input_network_profile"></a> [network\_profile](#input\_network\_profile) | Sets up a network profile with network plugin, policy, kubernetes service address, etc. for basic and advanced networking. Changing this forces a new resource to be created. For advanced networking, AKS clusters may not use 169.254.0.0/16, 172.30.0.0/16, 172.31.0.0/16, or 192.0.2.0/24 for the Kubernetes service address range, pod address range, or cluster virtual network address range. See [Choose a network model to use](https://docs.microsoft.com/en-us/azure/aks/configure-kubenet#choose-a-network-model-to-use) for more info. | <pre>object({<br>    network_plugin     = string<br>    network_policy     = optional(string)<br>    service_cidr       = optional(string, "10.100.0.0/16")<br>    dns_service_ip     = optional(string, "10.100.0.10")<br>    docker_bridge_cidr = optional(string, "172.17.0.1/16")<br>    outbound_type      = optional(string, "loadBalancer")<br>  })</pre> | <pre>{<br>  "dns_service_ip": "10.100.0.10",<br>  "docker_bridge_cidr": "172.17.0.1/16",<br>  "network_plugin": "azure",<br>  "network_policy": "azure",<br>  "outbound_type": "loadBalancer",<br>  "service_cidr": "10.100.0.0/16"<br>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group. | `string` | n/a | yes |
| <a name="input_save_ssh_private_key_locally"></a> [save\_ssh\_private\_key\_locally](#input\_save\_ssh\_private\_key\_locally) | Indicates whether or not to save the generated SSH private key locally. If this file is removed, or a plan is done from a new machine for automation, Terraform will generate a diff to re-create it. This may cause unwanted noise in a plan. Alternatively, use `save_ssh_private_key_remotely` instead to mitigate this issue. | `bool` | `true` | no |
| <a name="input_save_ssh_private_key_remotely"></a> [save\_ssh\_private\_key\_remotely](#input\_save\_ssh\_private\_key\_remotely) | Indicates whether or not to save the generated SSH private key remotely to a pre-created Azure container. If set to true, `ssh_private_key_storage_account_name` and `ssh_private_key_container_name` are required. | `bool` | `false` | no |
| <a name="input_secondary_node_pools"></a> [secondary\_node\_pools](#input\_secondary\_node\_pools) | Secondary node pool configuration. Changes to vm\_size can be done without forcing a rebuild of AKS. | <pre>list(object({<br>    name                = optional(string, "minion")<br>    node_count          = optional(number, 1)<br>    vm_size             = string<br>    vnet_subnet_id      = optional(string)<br>    os_type             = optional(string, "Linux")<br>    enable_auto_scaling = optional(bool, false)<br>    scaling_min_count   = optional(number, 1)<br>    scaling_max_count   = optional(number, 1)<br>    node_taints         = optional(list(string))<br>  }))</pre> | <pre>[<br>  {<br>    "enable_auto_scaling": false,<br>    "name": "minion",<br>    "node_count": 1,<br>    "node_taints": [],<br>    "os_type": "Linux",<br>    "scaling_max_count": 1,<br>    "scaling_min_count": 1,<br>    "vm_size": "Standard_DS2_v2",<br>    "vnet_subnet_id": null<br>  }<br>]</pre> | no |
| <a name="input_ssh_admin_username"></a> [ssh\_admin\_username](#input\_ssh\_admin\_username) | The SSH admin username for the cluster. Changing this forces a new resource to be created. | `string` | `"azureuser"` | no |
| <a name="input_ssh_key_container_folder_prefix"></a> [ssh\_key\_container\_folder\_prefix](#input\_ssh\_key\_container\_folder\_prefix) | The folder prefix for the SSH private key file to nest within a folder like structure. For example, `backup/`, WITHOUT the leading slash, will save the SSH private key file as `backup/my-ssh.key`. Requires `save_ssh_private_key_remotely` to be set to true. | `string` | `""` | no |
| <a name="input_ssh_private_key_container_name"></a> [ssh\_private\_key\_container\_name](#input\_ssh\_private\_key\_container\_name) | Name of the container to save the SSH private key file to. Requires `save_ssh_private_key_remotely` to be set to true. Containers are encrypted by default with Microsoft-managed keys (MMK). | `string` | `null` | no |
| <a name="input_ssh_private_key_rsa_bits"></a> [ssh\_private\_key\_rsa\_bits](#input\_ssh\_private\_key\_rsa\_bits) | The size of the generated RSA key in bits. | `number` | `4096` | no |
| <a name="input_ssh_private_key_storage_account_name"></a> [ssh\_private\_key\_storage\_account\_name](#input\_ssh\_private\_key\_storage\_account\_name) | Name of the storage account to save the SSH private key file to. Requires `save_ssh_private_key_remotely` to be set to true. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | n/a |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | n/a |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_cluster_password"></a> [cluster\_password](#output\_cluster\_password) | n/a |
| <a name="output_cluster_username"></a> [cluster\_username](#output\_cluster\_username) | n/a |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_kubeconfig_cmd"></a> [kubeconfig\_cmd](#output\_kubeconfig\_cmd) | n/a |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | n/a |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | n/a |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | n/a |
| <a name="output_secondary_node_pool"></a> [secondary\_node\_pool](#output\_secondary\_node\_pool) | n/a |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | n/a |
| <a name="output_ssh_private_key_storage_blob_id"></a> [ssh\_private\_key\_storage\_blob\_id](#output\_ssh\_private\_key\_storage\_blob\_id) | n/a |
| <a name="output_ssh_private_key_storage_blob_url"></a> [ssh\_private\_key\_storage\_blob\_url](#output\_ssh\_private\_key\_storage\_blob\_url) | n/a |
<!-- END_TF_DOCS -->