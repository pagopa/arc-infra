prefix         = "arc"
env_short      = "u"
env            = "uat"
location       = "italynorth"
location_short = "itn"
domain         = "core"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

# Monitor
law_daily_quota_gb = 10

# Apim
apim_publisher_name = "ARC UAT"
apim_sku            = "Developer_1"
apim_alerts_enabled = false

# DNS
external_domain = "pagopa.it"
dns_zone_prefix = "uat.cittadini"


app_gateway_sku_name = "Standard_v2"
app_gateway_sku_tier = "Standard_v2"

# AZDOA:
enable_azdoa             = true
azdo_agent_image_version = "v20241209"