# general
prefix         = "arc"
env_short      = "d"
env            = "dev"
domain         = "cittadini"
location       = "italynorth"
location_short = "itn"
cdn_location   = "westeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

## Domains
external_domain = "pagopa.it"
dns_zone_prefix = "dev.cittadini"

# this is the default value for tenant pagopa.it
azuread_service_principal_azure_cdn_frontdoor_id = "f3b3f72f-4770-47a5-8c1e-aa298003be12"

# NETWORK
# Logical CIDR for cittadini domain "10.1.131.0/24" # 10.1.131.0 --> 10.1.131.255
cidr_subnet_redis = ["10.1.131.0/28"] # "10.1.131.0 --> 10.1.131.15

## Redis
redis_params = {
  capacity = 0
  sku_name = "Basic"
  family   = "C"
  version  = 6
}
