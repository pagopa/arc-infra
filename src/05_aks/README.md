<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.116 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.33 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.116.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | 2322581d8c88868e17eef5a1c780a1e9ec9bcafc |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_alerts_enabled"></a> [aks\_alerts\_enabled](#input\_aks\_alerts\_enabled) | AKS alerts enabled? | `bool` | `false` | no |
| <a name="input_aks_cidr_system_subnet"></a> [aks\_cidr\_system\_subnet](#input\_aks\_cidr\_system\_subnet) | Aks system network address space. | `list(string)` | n/a | yes |
| <a name="input_aks_cidr_user_subnet"></a> [aks\_cidr\_user\_subnet](#input\_aks\_cidr\_user\_subnet) | Aks user network address space. | `list(string)` | n/a | yes |
| <a name="input_aks_ip_availability_zones"></a> [aks\_ip\_availability\_zones](#input\_aks\_ip\_availability\_zones) | List of zones | `list(string)` | <pre>[<br/>  "1",<br/>  "2",<br/>  "3"<br/>]</pre> | no |
| <a name="input_aks_kubernetes_version"></a> [aks\_kubernetes\_version](#input\_aks\_kubernetes\_version) | Kubernetes version specified when creating the AKS managed cluster. | `string` | n/a | yes |
| <a name="input_aks_num_outbound_ips"></a> [aks\_num\_outbound\_ips](#input\_aks\_num\_outbound\_ips) | How many outbound ips allocate for AKS cluster | `number` | `1` | no |
| <a name="input_aks_private_cluster_is_enabled"></a> [aks\_private\_cluster\_is\_enabled](#input\_aks\_private\_cluster\_is\_enabled) | Allow to configure the AKS, to be setup as a private cluster. To reach it, you need to use an internal VM or VPN | `bool` | `true` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). | `string` | n/a | yes |
| <a name="input_aks_system_node_pool"></a> [aks\_system\_node\_pool](#input\_aks\_system\_node\_pool) | AKS node pool system configuration | <pre>object({<br/>    name                         = string<br/>    vm_size                      = string<br/>    os_disk_type                 = string<br/>    os_disk_size_gb              = string<br/>    node_count_min               = number<br/>    node_count_max               = number<br/>    only_critical_addons_enabled = bool<br/>    node_labels                  = map(any)<br/>    node_tags                    = map(any)<br/>  })</pre> | n/a | yes |
| <a name="input_aks_user_node_pool"></a> [aks\_user\_node\_pool](#input\_aks\_user\_node\_pool) | AKS node pool user configuration | <pre>object({<br/>    enabled         = bool<br/>    name            = string<br/>    vm_size         = string<br/>    os_disk_type    = string<br/>    os_disk_size_gb = string<br/>    node_count_min  = number<br/>    node_count_max  = number<br/>    node_labels     = map(any)<br/>    node_taints     = list(string)<br/>    node_tags       = map(any)<br/>  })</pre> | n/a | yes |
| <a name="input_argocd_helm_release_version"></a> [argocd\_helm\_release\_version](#input\_argocd\_helm\_release\_version) | ArgoCD helm chart release version | `string` | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_keda_helm_chart_version"></a> [keda\_helm\_chart\_version](#input\_keda\_helm\_chart\_version) | keda helm chart version | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_nginx_ingress_helm_version"></a> [nginx\_ingress\_helm\_version](#input\_nginx\_ingress\_helm\_version) | Nginx ingress helm version https://github.com/kubernetes/ingress-nginx | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->