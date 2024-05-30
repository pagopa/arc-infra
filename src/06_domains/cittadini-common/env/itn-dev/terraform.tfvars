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
dns_zone_prefix = "dev.cittadini-p4pa"
# this is the deafult value for tenant pagopa.it
azuread_service_principal_azure_cdn_frontdoor_id = "f3b3f72f-4770-47a5-8c1e-aa298003be12"