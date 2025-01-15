# general
prefix         = "arc"
env_short      = "p"
env            = "prod"
domain         = "monitoring"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Grafana
grafana_zone_redundancy_enabled = false
grafana_major_version           = 10

### Synthetic
law_sku                                    = "CapacityReservation"
synthetic_storage_account_replication_type = "ZRS"
synthetic_use_private_endpoint             = true

### DNS
external_domain = "pagopa.it"
dns_zone_prefix = "cittadini"
