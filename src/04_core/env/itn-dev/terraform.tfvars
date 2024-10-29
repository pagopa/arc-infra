prefix         = "arc"
env_short      = "d"
env            = "dev"
location       = "italynorth"
location_short = "itn"
domain         = "core"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

# Monitor
law_daily_quota_gb = 10

# Apim
apim_publisher_name = "ARC DEV"
apim_sku            = "Developer_1"
apim_alerts_enabled = false

# DNS
external_domain = "pagopa.it"
dns_zone_prefix = "dev.cittadini"

# APPGW
app_gateway_sku_name       = "Standard_v2"
app_gateway_sku_tier       = "Standard_v2"
app_gateway_alerts_enabled = false

# AZDOA:
enable_azdoa             = true
azdo_agent_image_version = "v1"
