# general
prefix         = "arc"
env_short      = "d"
env            = "dev"
domain         = "monitoring"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Grafana
grafana_zone_redundancy_enabled = false
grafana_major_version           = 10

### Synthetic
synthetic_storage_account_replication_type = "LRS"
synthetic_use_private_endpoint             = false

### DNS
external_domain = "pagopa.it"
dns_zone_prefix = "dev.cittadini"
