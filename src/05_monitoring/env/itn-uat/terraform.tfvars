# general
prefix         = "arc"
env_short      = "u"
env            = "uat"
domain         = "monitoring"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Grafana
grafana_zone_redundancy_enabled = false
grafana_major_version           = 10

### Synthetic
storage_account_replication_type = "ZRS"
use_private_endpoint             = true

### DNS
external_domain = "pagopa.it"
dns_zone_prefix = "uat.cittadini"
