# general
prefix          = "arc"
env_short       = "d"
env             = "dev"
domain          = "cittadini"
location        = "italynorth"
location_string = "Italy North"
location_short  = "itn"
cdn_location    = "westeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

bizevents_base_url         = "https://api.dev.platform.pagopa.it/bizevents/tx-service/v1/"
gpd_payments_pull_base_url = "https://api.dev.platform.pagopa.it/pagopa-gpd-payments-pull/v1"
bizevents_paids_base_url   = "https://api.dev.platform.pagopa.it/bizevents/notices-service/v1"

## Domains
external_domain = "pagopa.it"
dns_zone_prefix = "dev.cittadini"

### ARGOCD
argocd_server_addr = "argocd.internal.dev.cittadini.pagopa.it"

alert_enabled = false
