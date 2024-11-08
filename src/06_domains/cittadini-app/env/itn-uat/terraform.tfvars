# general
prefix          = "arc"
env_short       = "u"
env             = "uat"
domain          = "cittadini"
location        = "italynorth"
location_string = "Italy North"
location_short  = "itn"
cdn_location    = "westeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

gpd_payments_pull_base_url = "https://api.uat.platform.pagopa.it/pagopa-gpd-payments-pull/v1"
bizevents_paids_base_url   = "https://api.uat.platform.pagopa.it/bizevents/notices-service/v1"

## Domains
external_domain = "pagopa.it"
dns_zone_prefix = "uat.cittadini"

### ARGOCD
argocd_server_addr = "argocd.internal.uat.cittadini.pagopa.it"

alert_enabled = true
