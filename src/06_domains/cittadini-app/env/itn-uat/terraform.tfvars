# general
prefix         = "arc"
env_short      = "u"
env            = "uat"
domain         = "cittadini"
location       = "italynorth"
location_short = "itn"
cdn_location   = "westeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

bizevents_base_url         = "https://api.uat.platform.pagopa.it/bizevents/tx-service/v1/"
gpd_payments_pull_base_url = "https://api.uat.platform.pagopa.it/pagopa-gpd-payments-pull/v1"
bizevents_paids_base_url   = "https://api.uat.platform.pagopa.it/bizevents/notices-service/v1"