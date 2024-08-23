##  Application gateway
module "app_gw" {
  source = "./.terraform/modules/__v3__/app_gateway/"

  resource_group_name = local.vnet_resource_group_name
  location            = var.location
  name                = "${local.project}-app-gw"

  # SKU
  sku_name = var.app_gateway_sku_name
  sku_tier = var.app_gateway_sku_tier

  # WAF
  waf_enabled = var.app_gateway_waf_enabled


  # Networking
  subnet_id    = data.azurerm_subnet.appgateway_snet.id
  public_ip_id = data.azurerm_public_ip.appgateway_public_ip.id
  zones        = var.zones

  # Configure backends
  backends = {
    apim = {
      protocol                    = "Https"
      host                        = local.api_domain
      port                        = 443
      ip_addresses                = module.apim.private_ip_addresses
      fqdns                       = [local.api_domain]
      probe                       = "/status-0123456789abcdef"
      probe_name                  = "probe-apim"
      request_timeout             = 60
      pick_host_name_from_backend = false
    }

    portal = {
      protocol                    = "Https"
      host                        = local.portal_domain
      port                        = 443
      ip_addresses                = module.apim.private_ip_addresses
      fqdns                       = [local.portal_domain]
      probe                       = "/signin"
      probe_name                  = "probe-portal"
      request_timeout             = 60
      pick_host_name_from_backend = false
    }

    management = {
      protocol                    = "Https"
      host                        = local.management_domain
      port                        = 443
      ip_addresses                = module.apim.private_ip_addresses
      fqdns                       = [local.management_domain]
      probe                       = "/ServiceStatus"
      probe_name                  = "probe-management"
      request_timeout             = 60
      pick_host_name_from_backend = false
    }

  }

  ssl_profiles = [
    {
      name                             = "${local.project}-ssl-profile"
      trusted_client_certificate_names = null
      verify_client_cert_issuer_dn     = false
      ssl_policy = {
        disabled_protocols = []
        policy_type        = "Custom"
        policy_name        = ""
        # with Custom type set empty policy_name (not required by the provider)
        cipher_suites = [
          "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
          "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
          "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
          "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA"
        ]
        min_protocol_version = "TLSv1_2"
      }
    }
  ]

  trusted_client_certificates = []

  # Configure listeners
  listeners = {
    api = {
      protocol           = "Https"
      host               = local.api_domain
      port               = 443
      ssl_profile_name   = "${local.project}-ssl-profile"
      firewall_policy_id = null

      certificate = {
        name = local.apim_api_certificate_name
        id = trimsuffix(
          data.azurerm_key_vault_certificate.api_apim.secret_id,
          data.azurerm_key_vault_certificate.api_apim.version
        )
      }
    }

    portal = {
      protocol           = "Https"
      host               = local.portal_domain
      port               = 443
      ssl_profile_name   = "${local.project}-ssl-profile"
      firewall_policy_id = null

      certificate = {
        name = local.portal_cert_name_proxy_endpoint
        id = trimsuffix(
          data.azurerm_key_vault_certificate.portal_apim.secret_id,
          data.azurerm_key_vault_certificate.portal_apim.version
        )
      }
    }

    management = {
      protocol           = "Https"
      host               = local.management_domain
      port               = 443
      ssl_profile_name   = "${local.project}-ssl-profile"
      firewall_policy_id = null

      certificate = {
        name = local.apim_management_certificate_name
        id = trimsuffix(
          data.azurerm_key_vault_certificate.management_apim.secret_id,
          data.azurerm_key_vault_certificate.management_apim.version
        )
      }
    }
  }

  # maps listener to backend
  routes = {

    api = {
      listener              = "api"
      backend               = "apim"
      rewrite_rule_set_name = null
      priority              = 10
    }

    portal = {
      listener              = "portal"
      backend               = "portal"
      priority              = 30
      rewrite_rule_set_name = null
    }

    mangement = {
      listener              = "management"
      backend               = "management"
      rewrite_rule_set_name = null
      priority              = 40
    }
  }

  rewrite_rule_sets = []

  # TLS
  identity_ids = [azurerm_user_assigned_identity.appgateway.id]

  # Scaling
  app_gateway_min_capacity = var.app_gateway_min_capacity
  app_gateway_max_capacity = var.app_gateway_max_capacity

  alerts_enabled = var.app_gateway_alerts_enabled

  action = [
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    #    {
    #      action_group_id    = azurerm_monitor_action_group.email.id
    #      webhook_properties = null
    #    }
  ]

  # metrics docs
  # https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftnetworkapplicationgateways
  monitor_metric_alert_criteria = {

    compute_units_usage = {
      description   = "Abnormal compute units usage, probably an high traffic peak"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 2
      auto_mitigate = true

      criteria = []
      dynamic_criteria = [
        {
          aggregation       = "Average"
          metric_name       = "ComputeUnits"
          operator          = "GreaterOrLessThan"
          alert_sensitivity = "Low"
          # todo after api app migration change to High
          evaluation_total_count   = 2
          evaluation_failure_count = 2
          dimension                = []
        }
      ]
    }

    backend_pools_status = {
      description   = "One or more backend pools are down, check Backend Health on Azure portal"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 0
      auto_mitigate = true

      criteria = [
        {
          aggregation = "Average"
          metric_name = "UnhealthyHostCount"
          operator    = "GreaterThan"
          threshold   = 0
          dimension   = []
        }
      ]
      dynamic_criteria = []
    }

    total_requests = {
      description   = "Traffic is raising"
      frequency     = "PT5M"
      window_size   = "PT15M"
      severity      = 3
      auto_mitigate = true

      criteria = []
      dynamic_criteria = [
        {
          aggregation              = "Total"
          metric_name              = "TotalRequests"
          operator                 = "GreaterThan"
          alert_sensitivity        = "Medium"
          evaluation_total_count   = 1
          evaluation_failure_count = 1
          dimension                = []
        }
      ]
    }

    failed_requests = {
      description   = "Abnormal failed requests"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 1
      auto_mitigate = true

      criteria = []
      dynamic_criteria = [
        {
          aggregation              = "Total"
          metric_name              = "FailedRequests"
          operator                 = "GreaterThan"
          alert_sensitivity        = "Medium"
          evaluation_total_count   = 2
          evaluation_failure_count = 2
          dimension                = []
        }
      ]
    }

  }

  tags = var.tags
}