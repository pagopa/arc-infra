prefix         = "arc"
env_short      = "p"
env            = "prod"
location       = "italynorth"
location_short = "itn"
domain         = "packer"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

azdo_agent_image_version    = "v20241208"
dns_forwarder_image_version = "v20241009"
