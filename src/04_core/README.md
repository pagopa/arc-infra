<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.116 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.116.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | 08bfcfae8b0ca536debf8452f0fe29405248dcfb |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.managed_identities_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_definition.iac_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_alerts_enabled"></a> [apim\_alerts\_enabled](#input\_apim\_alerts\_enabled) | Enable alerts | `bool` | `true` | no |
| <a name="input_apim_autoscale"></a> [apim\_autoscale](#input\_apim\_autoscale) | Configure Apim autoscale on capacity metric | <pre>object(<br/>    {<br/>      enabled                       = bool<br/>      default_instances             = number<br/>      minimum_instances             = number<br/>      maximum_instances             = number<br/>      scale_out_capacity_percentage = number<br/>      scale_out_time_window         = string<br/>      scale_out_value               = string<br/>      scale_out_cooldown            = string<br/>      scale_in_capacity_percentage  = number<br/>      scale_in_time_window          = string<br/>      scale_in_value                = string<br/>      scale_in_cooldown             = string<br/>    }<br/>  )</pre> | <pre>{<br/>  "default_instances": 1,<br/>  "enabled": false,<br/>  "maximum_instances": 5,<br/>  "minimum_instances": 1,<br/>  "scale_in_capacity_percentage": 30,<br/>  "scale_in_cooldown": "PT30M",<br/>  "scale_in_time_window": "PT30M",<br/>  "scale_in_value": "1",<br/>  "scale_out_capacity_percentage": 60,<br/>  "scale_out_cooldown": "PT45M",<br/>  "scale_out_time_window": "PT10M",<br/>  "scale_out_value": "2"<br/>}</pre> | no |
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | APIM | `string` | n/a | yes |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | n/a | `string` | n/a | yes |
| <a name="input_app_gateway_alerts_enabled"></a> [app\_gateway\_alerts\_enabled](#input\_app\_gateway\_alerts\_enabled) | Enable alerts | `bool` | `true` | no |
| <a name="input_app_gateway_max_capacity"></a> [app\_gateway\_max\_capacity](#input\_app\_gateway\_max\_capacity) | n/a | `number` | n/a | yes |
| <a name="input_app_gateway_min_capacity"></a> [app\_gateway\_min\_capacity](#input\_app\_gateway\_min\_capacity) | App Gateway | `number` | n/a | yes |
| <a name="input_app_gateway_sku_name"></a> [app\_gateway\_sku\_name](#input\_app\_gateway\_sku\_name) | The Name of the SKU to use for this Application Gateway. Possible values are Standard\_Small, Standard\_Medium, Standard\_Large, Standard\_v2, WAF\_Medium, WAF\_Large, and WAF\_v2 | `string` | n/a | yes |
| <a name="input_app_gateway_sku_tier"></a> [app\_gateway\_sku\_tier](#input\_app\_gateway\_sku\_tier) | The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard\_v2, WAF and WAF\_v2 | `string` | n/a | yes |
| <a name="input_app_gateway_waf_enabled"></a> [app\_gateway\_waf\_enabled](#input\_app\_gateway\_waf\_enabled) | Enable waf | `bool` | `false` | no |
| <a name="input_azdo_agent_image_version"></a> [azdo\_agent\_image\_version](#input\_azdo\_agent\_image\_version) | Version as suffix to define the image related to azdo agent | `string` | n/a | yes |
| <a name="input_devops_agent_balance_zones"></a> [devops\_agent\_balance\_zones](#input\_devops\_agent\_balance\_zones) | (Optional) True if the devops agent instances must be evenly balanced between the configured zones | `bool` | `false` | no |
| <a name="input_devops_agent_zones"></a> [devops\_agent\_zones](#input\_devops\_agent\_zones) | (Optional) List of zones in which the scale set for azdo agent will be deployed | `list(number)` | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable_azdoa"></a> [enable\_azdoa](#input\_enable\_azdoa) | Enable Azure DevOps agent. | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | # General | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) List of availability zones on which the API management and appgateway will be deployed | `list(number)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->