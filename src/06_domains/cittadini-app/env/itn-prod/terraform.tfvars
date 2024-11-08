# general
prefix          = "arc"
env_short       = "p"
env             = "prod"
domain          = "cittadini"
location        = "italynorth"
location_string = "Italy North"
location_short  = "itn"
cdn_location    = "westeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

gpd_payments_pull_base_url = "https://api.platform.pagopa.it/pagopa-gpd-payments-pull/v1"
bizevents_paids_base_url   = "https://api.platform.pagopa.it/bizevents/notices-service/v1"

## DNS
dns_zone_prefix = "cittadini"
external_domain = "pagopa.it"

### ARGOCD
argocd_server_addr = "argocd.internal.cittadini.pagopa.it"

alert_enabled = false # https://pagopa.atlassian.net/browse/P4PU-664
